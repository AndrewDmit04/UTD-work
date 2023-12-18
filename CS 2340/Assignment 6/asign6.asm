#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a program that will be able to encrypt and decrypt files.
#the encryption algorithm will use a key which is a string, it will read
#the file and add the ascii value of the key to the character read in the file
#will also create a .enc file where the encryption will be stored
#decryption will do the same but subtract, will create a file a .txt file 
#where the decrypted file will be stored
#-----------------------------------------------------------------------------------------------------------------------------------------------#
	.include"SysCall.asm"					#include sysCalls for system calls 
	.include"Macros.asm"					#include Macros for printing macro 
	.text 
	.globl	main 						#declare main as globl this is where the program will start 
main:	printString("Menu:\n")					#print the menu 
	printString("1.Encrypt file\n")				#print menu option 1 Encrypt file
	printString("2.Decrypt file\n")				#print menu option 2 Dectypr file 
	printString("3.Exit\n")					#print menu option 3 Exit 
	li	$v0,SysReadInt					#load the Read Integer function
	syscall 						# takes an integer from the user 
	beq	$v0,1,enCrypt					#check if the integer is a 1 if so call Encrypt function 
	beq	$v0,2,deCrypt 					#check if the integer is a 2 if so call the Decrypt function 
	beq	$v0,3,exit					#check if the integer is a 3 if so call the exit function 
	printString("Please type a number between 1 and 3\n")	#if none of them then notify the user that the number must be between 1 and 3 
	j	main						#go back to main and ask the user again 
exit:	li	$v0,SysExit					#load the System exit function
	syscall 						#exit the program
	
	.kdata							#kernel data in the event of an error during the program 
err:	.asciiz	"Erorr something went wrong, going back to menu\n"#string in an event of invalid data when entering Integer 
	.ktext 	0x80000180					#0x80000180 is the jump address when a exception happens 
	li	$v0,SysPrintString 				#load the printing string function 
	la	$a0,err						#load the err message 
	syscall 						#print the error message
	la	$a0,main 					#load the address of main where we want to go back to 
	mtc0	$a0,$14						#move the address into the program counter 
	eret							#exception return to main 
		
		
		
		

		
		


