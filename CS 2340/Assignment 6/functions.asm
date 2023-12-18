#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: provide helpfull functions so that the main block of code look clean and readible 
#this file will handle all I/O when entering the file name and key, as well as reading and writing from files, and encrypting and decrypting
#----------------------------------------------------------------------------------------------------------------------------------------------#
#NOTE: DO NOT RUN THIS FILE START FROM CS2340Asg6-Encryption.
#NOTE: DO NOT RUN THIS FILE START FROM CS2340Asg6-Encryption.
#NOTE: DO NOT RUN THIS FILE START FROM CS2340Asg6-Encryption.
	.include "SysCall.asm"		#include syscalls for function calls 
	.include "Macros.asm"		#include macros for printing strings 
	.data 
	.eqv	MAX_FILE_NAME 255	#max file name length
	.eqv 	MAX_KEY	60		#man key length 
	.eqv 	READ_BUFFER 1024 	#max read buffer from file length
	.eqv	Write 1		#1 for write mode when opening a file 
	.eqv	Read 0		#0 for read mode when opening a file
	.eqv	Mode 0 		#0 for Mode always ignored

fileName:.space	MAX_FILE_NAME		#intilize space for the file name 
key:	.space	MAX_KEY			#intilize space for the key
readBuf:.space	READ_BUFFER		#intilize space for rhe read buffer
Fread:	.word	0			#File read will store the file descriptor of the file being read 
Fwrite:	.word	0			#file write weill store the file descriptor of the file being written to 
txt:	.asciiz	"txt"			#will be used to copy a .txt extension to a file being decrypted
enc:	.asciiz	"enc"			#will be used to copy a .enc extension to a file being encypted
	.text 
	.globl enCrypt, deCrypt		#declare enCrypt and deCrypt as globl so we can call them from main 
enCrypt:jal 	ask			#jump and link to ask function, will get a file name and key, makes sure the file exists and the key isnt empty
	la	$a0, fileName		#load the file name adress into $a0
	la	$a1,enc			#load the enc extension adress into $a1
	li	$s0, 0			#set $s0 to 0 this will indicate to the program that we are encrypting the given file and will add the key values
	j	findDot			#jump to findDot
deCrypt:jal	ask			#jump and link to ask function, will get a file name and key, makes sure the file exists and the key isnt empty
	la	$a0, fileName 		#load the file name adress into $a0
	la	$a1,txt			#load the txt extension adress into $a1
	li	$s0,1			#set $s0 to 1 this will indicate to the program that we are decrypting the fiven file and will subtract the key values
findDot:lb	$t0, ($a0)		#find dot will find where the . is so that way we can change the extension, load the first character inside the file name 
	beq	$t0, '.', copy		#check if that charecter is a '.' if it is branch to copy
	addi	$a0,$a0,1 		#add one to the adress of the file name
	j	findDot			#jump back to findDot
copy: 	addi 	$a0,$a0,1		#move one forward on the adress of the file name
	lb	$t0,($a1)		#load the byte of the string we are copying which is the extension string 
	sb	$t0,($a0)		#store that byte into our file name string
	addi 	$a1,$a1,1		#add one to the adress of the string being copyed or the extension string
	bnez 	$t0,copy		#as long as the $t0 is not 0 which means that the extension string end contunie copying the extensins string to the file name 
	li	$v0,SysOpenFile		#load the System Open file function
	la	$a0,fileName		#load the new file name 
	li	$a1,Write		#load Write into $a1 will open the file in write mode
	li	$a2,Mode		#load the Mode which is 0 always
	syscall				#open the file
	sw	$v0, Fwrite		#store the file descriptor 
read:	li	$v0,SysReadFile 	#load the System Read file function 
	lw	$a0,Fread 		#load the file descriptor
	la	$a1,readBuf		#load the buffer we are reading into
	li	$a2,READ_BUFFER		#load the max number of bytes to read
	syscall 			#read the file
	beqz	$v0, closeFiles		#if the length of what we read is equal to zero then we can close both the files and return to the main menu
	move	$t0, $v0		#move the amount of bytes read from $v0 into $t0
	la	$a3,key			#load the adress of the key into $a3
encr:	beqz	$t0,write		#when we have read through the whole buffer and $t0 is zero start to write to the file 
	lbu	$t1, ($a3)		#load the value of the key 
	bne	$t1, '\n', noReset	#check if the value is not equal to '\n' if then we dont need to reset the key so jump to noReset
	la	$a3,key			#if it is equal then load the value of the key again
	lbu 	$t1, ($a3)		#load the first byte of the key 
noReset:lbu	$t2,($a1)		#load the byte in the buffer 
	jal	calc			#jump and link to the calc function which will either subtract or add the key and buffer depending on encryption or decryption mode 
	sb	$t1,($a1)		#store the new calculated byte
	addi 	$a1,$a1,1 		#add one to the buffer adress 
	addi	$a3,$a3,1 		#add one to the key adress 
	subi	$t0,$t0,1		#subtract one form the total number of bytes read
	j	encr			#jump back to encryption 
write:	move	$a2,$v0			#move the total charecters read from $v0 into $a2, this will be our number of bytes to write
	li	$v0,SysWriteFile	#load the System Write File function 
	lw	$a0,Fwrite 		#laod the file descriptor
	la	$a1,readBuf 		#load the buffer where all the charecters are stored 
	syscall 			#write to the file 
	j 	read			#go back to read and contunie reading until nothing is left in file 
		
#will take two inputs $t1 and $t2 and will subtact or add according to if we are decrypting or encrypting
calc:	beqz	$s0, Enc		#if $s0 is equal to zero then we are encrypting so jump to Encrypt 
	subu	$t1,$t2,$t1 		#subtract the value inside the buffer from the key
	jr	$ra			#return to call adress
Enc:	addu	$t1,$t1,$t2		#add the value inside the buffer to the value inside the key
	jr	$ra			#return and go back to the call adress
		
#function will close both the input and output file after the encrypting is done 
closeFiles:li	$v0,SysCloseFile	#load the close File function 
	lw	$a0,Fwrite		#load the File Write descriptor
	syscall 			#close the Write file 
	lw	$a0,Fread 		#laod the File Read descriptor 
	syscall 			#close the Read file
	j	main			#go back to the main menu 


#ask function will have no output but  will store the file name inside fileName and the key inside key, it will check if the file exists and if the theres a key, if there issnet will go back to main menu
ask:	printString("Enter the file name: ") #prompt user for the file name 
	li	$v0,SysReadString	#load the read String function
	la	$a0,fileName 		#load the buffer were reading into
	li	$a1,MAX_FILE_NAME	#load the maximum amount of charecters were reading
	syscall 			#read the string 
strip:	lb	$t0,($a0)		#strip will get rid of the \n charecter, load the first byte of the input string 
	addi 	$a0,$a0, 1		#add one to the adress of the input string
	bne	$t0,'\n',strip		#check if the loaded byte is a new line if not then contunie looping=
	sb	$zero, -1($a0)		#if it is a new line then null turminate the string by storing a binary 0 into the new line
	li	$v0,SysOpenFile		#load the open file finction
	la	$a0,fileName 		#load the file name
	li	$a1,Read		#load the function with read mode 
	li	$a2,Mode		#load the mode will always be 0 
	syscall 			#open the file
	beq	$v0,-1,cantOpen		#check if $v0 returns -1 if it does then the file did not open jump to cantOpen handler 
	sw	$v0,Fread		#its its not -1 then the file opened, store the descriptor in File Read 
	printString("Enter the key: ")	#prompt user for the key 
	li	$v0,SysReadString 	#load the read String function
	la	$a0,key 		#load the buffer were reading into
	li	$a1,MAX_KEY		#load the max amount of charecters
	syscall				#read a string in 
	lb	$t0,($a0)		#load the first byte of the string 
	beq	$t0,'\n',NoKey		#check if its a new line if it is then there was no key provided so jump to noKey handler
	jr	$ra			#return to call adress


#will be called if the file could be opened 
cantOpen:printString("\ncould not open file\n\n") #print out what happend 
	j	main			#jump back to the main menu 
#will be called if theres no key, will close the input file 
NoKey:	printString("\nNo key was provided\n\n")  #print out what happend 
	li	$v0, SysCloseFile	#load the system Close funciton
	lw	$a0,Fread 		#load the File read descriptor 
	syscall 			#close the file 
	j	main			#jump back to main
