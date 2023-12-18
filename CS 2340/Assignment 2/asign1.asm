#Program written by Andrew Dmitrievsky
			
			.include	"Syscall.asm"							#include equivalent
			.data											
request:		.asciiz	"Enter an integer: "						#prompt for the user to type the numbers in
sumString:	.asciiz	"The sum is: "		#For printing the sum at the end of the program
lenNum:		.asciiz	"\nThe number of integers entered was: "	#fFor printing the len at the end of the program
endLine:	.asciiz	"\n"							 #endline at the end of the program

			.text				 #define where code starts
			.globl 	main

main:		li	$a1,0				 #intilize sum to 0
		li	$a2,0				 #intilize count of the numbers  to 0

Read:		li 	$v0, SysPrintString		 #load register with printing String function
		la 	$a0, request			 #load the prompt into the register that the function will read off 
			syscall				 #call the function and print the prompt
		li	$v0,	SysReadInt		 #read in an integer, and create a loop for entering numbers
		syscall
		add	$a1,$a1,$v0			 #add the integer to the current sum
		addi	$a2,$a2,1		         #add 1 to the current count 
		bnez  	$v0,Read			 #if the number entered by the user isn't zero go back to the Read branch
		subi	$a2,$a2,1			 #subtract one from the count of numbers because 0 is counted when exiting the loop
		#printing sum string
		li	$v0,SysPrintString		 #chose the PrintString function
		la	$a0,sumString			 #load the String associated with the sum
		syscall					 #call the function and print the sum String
		#printing sum integer
		li	$v0,SysPrintInt 		 #load the print the integer function
		la	$a0,($a1)			 #load the sum into the associated register 
		syscall					 #call the function and print the sum
		#printing the Integers entered String
		li	$v0,SysPrintString	         #load the  print String function
		la	$a0,lenNum			 #load the associated register with the string we want to print
		syscall				         #call the function and print the string
		#printing the integerts enterted integer
		li	$v0,SysPrintInt			 #load the  print int function
		la	$a0,($a2)		         #load the associated register with the int we want to print
		syscall					 #call the function and print the string
		#printing a endline 
		li 	$v0,SysPrintString	         #load the  print String function
		la	$a0,endLine			 #load the associated register with the string we want to print
		syscall				         #call the function and print the string
		#exiting program
		li	$v0,SysExit
		syscall
			
			
			
			
			
			
			
			
			
	
