#-------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: This program will take an input from 3 to 160000
#and calculate all prime numbers up to that number using a sieve algorithm
#and display them 
#-------------------------------------------------------------------------------------------------------#
		
		.include	"sysCall.asm"
		.eqv		MINNUM		3 			#min input taken
		.eqv		MAXNUM		160000		#max input taken 
		.eqv		NUMS_PER_L	10			#numbers per a line		
		.data 
prompt:	.asciiz	"Enter a number between 3 and 160,000: "	#prompt  for user 
errorM:	.asciiz	"\ninvalid number try again\n"				#error message 
endLine:.asciiz	"\n"										#new line for numbers
space:	.asciiz	" "										#space for numbers 
		.text
		.globl	Main
Main:
		#input with error cheking 
input:	li		$v0,SysPrintString	#load print String function
		la		$a0,prompt	#load the prompt 
		syscall 			#displays the prompt 
		li		$v0,SysReadInt	#load read int function
		syscall 			#intake an int
		bgt		$v0,MAXNUM,error#check if the number is above max if so throw an error 
		blt		$v0,MINNUM,error#check if the number is below min if so throw an error
		j		calc		#if not contunie to calculation
error:	li		$v0,SysPrintString	#load print string function
		la		$a0,errorM	#load error message 
		syscall 			#print error message 
		j		input		#go back to the input
		#calculate number of bytes to allocate
calc:	andi	$t1,$v0,7			#check if there's a remainder if so $t1 is 1 then there's a reminder 
		srl		$t0,$v0,3	#divide by 8 to get the number of bytes needed
		move 	$t2,$v0			#store the input value in $t2 
		beqz	$t1,noA			#if there is no remainder branch as we don't need to add another byte
		addi	$t0,$t0,1		#if there is a remainder add another byte
		#allocating the memory
noA:	li		$v0,SysAlloc		#load the memory allocation function
		la		$a0,($t0)	#load the number of bytes calculated into $a0
		syscall 			#allocate the needed amount of memory 
		move	$a1,$v0			#store the beginning address in $a1 
		#intilizing the bits to all high values
		la		$t3,($t2)	#set $t3 to the input number so we know how many numbers to loop through inside the memory
		addi	$t3,$t3,1		#add one to the number of times to loop through as we 
		li		$t4,0xFF	#set $t4 to to 0xFF or highest number inside the bit
setArr:	sb		$t4,($v0)		#intilize the array to all 0xFF,store $t4 which is 0xFF into the bit at current memory location
		addi	$v0,$v0,1		#add to memory location incrementing 
		subi		$t3,$t3,1	#subtract one from the input number
		bnez	$t3,setArr		#if the input number is not zero continue to set array to all 0xFF
		#calculating prime numbers
		li		$t4,0		#itilize a number that will be used to flip the bits off
		li		$t5,2		#keeps track of current index 
		move	$t1,$t2			#move the user input from $t2 to $t1 will keep track number of times needed to loop
		srl		$t1,$t1,1	#divide the number of items by 2  since the algorithm terminates at n/2
prime:	bgt		$t5,$t1,exitL		#if the number in $t5 which is the current index is greater than $t1 which is the total times we want to loop we want to exit 
		move 	$a0,$a1			#reset pointer that points to the beginning 
		add		$a0,$a0,$t5	#set pointer to last position which is stored in $t5
		lb		$t6,($a0)	#load value in pointer
		or		$t7,$t6,$zero	#or value with zero to see if it is zero
		move	$t6,$t5			#set the value to current index	
		bnez	$t7,loop		#if the number is not zero we want to calculate each number that is multiple of that number
		addi	$t5,$t5,1		#increment the current value 
		j		prime 		#go back and check the next number 
loop:	add		$a0,$a0,$t5		#Prime increment by the multiple of it which is stored in $t5
		add		$t6,$t6,$t5	#add to $t6 of the current index to know when to break out of the loop
		sb		$t4,($a0)	#set byte at location equal to zero 
		ble		$t6,$t2,loop	#if  the value if $t6 is less than $t2 continue looping $t6 stores current index position and $t2 stores total input
		addi	$t5,$t5,1		#after the loop is done add one to the current index value 
		j 		prime		#contunie looping 
		#after loop is done
exitL:	addi	$a1,$a1,2			#Exit loop, add 2 to stored address will go to the number 2  
		li		$t4,1		#load $t4 with 1 will keep track of the current number we are at 
		li		$t1,NUMS_PER_L	#how many nums per a line 
		#checking if prime inside data
Ploop:	lb		$t3,($a1)		#Print Loop, load the current byte into $t3 
		addi	$a1,$a1,1 		#increment the pointer one forward so it's pointing to the next number 
		addi	$t4,$t4,1		#increment the current number  by 1 
		bgt		$t4,$t2,exit	#if the current number is greater than the input exit the program
		beqz	$t3,Ploop		#if the value in $t3 which is the loaded byte is 0 not a prime number and loop back look at next number 
		#printing number 
		li		$v0,SysPrintInt	#if it is not zero we want to print the number,load print int string 
		la		$a0,($t4)	#load the current number 
		syscall 			#print the current number 
		li		$v0,SysPrintString #load print String function 
		la		$a0,space	#load the space string 
		syscall				#print the space 
		subi		$t1,$t1,1	#subtract 1 from $t1 which is keeping track of how many numbers are on each line 
		bnez 	$t1,Ploop		#if the value in $t1 is not zero then we are not at 10 numbers on a line yet jump back  
		li		$t1,NUMS_PER_L	#reset the value of $t1 
		li		$v0,SysPrintString #load the print string function  
		la		$a0,endLine	#load an endline 
		syscall 			#print a endline
		j		Ploop		#go back and loop
		#exit program		
exit:		li		$v0,SysExit	#load system exit function
		syscall				#exit the program


		
	
