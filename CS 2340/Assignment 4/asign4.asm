#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a multi-file program, the first file contains the I/O responsibilities of the program
#The second file contains functions that will check if the inputted string is a palindrome
#the program will tell if an input string is a palindrome or not ignoring everything that is not a letter 
#or number.

#function in file:
#1.length: counts the length of the input string and puts length in $t4  
#and then allocates memory for a new string address allocated adress in $a2 

#2.remove: checks if a character are valid inside $a1 if it is valid  it will pass it to the audio 
#function or toLow function which will add the character to the allocated string in $a2

#3.toLow: converts capitol letter passed in $t0 to lower case letters then passes it to addTo

#4.addTo: will add the passed charecter to it in $t0 to the allocated adress in $a2

#5.Pali: Will determine if the string passed to it in $a2 is a palindrome or not, 
#it will do this by checking if the first and last letters of the string are equal and if they
#are equal the function will create another copy of the string without the first and last 
#charecter and put it in $a2 and call itself again, will continue to recursively call itself 
#until it reaches length 1 or 0, when length is 1 or 0 will return 1 inside $v0. If at some point 
#the first and last characters are not equal then it will return 0 inside $v0
#-----------------------------------------------------------------------------------------------------------------------------------------------#
		
		.include	"sysCall.asm"
		.data
		.eqv 	SIZE	202		#max size of input 
prompt:		.asciiz	"Input string:"		# initial prompt to the user 
pali:		.asciiz	"Palindrome\n"		#if it's a palindrome print out palindrome 
notPali:	.asciiz	"Not a Palindome\n"	#if not a palindrome print out not a palindrome 
buffer:		.space	SIZE			#space for the input string 
 		.text		
ask:	li	$v0,SysPrintString 	#load print string function 
 	la	$a0,prompt		#load the prompt 
 	syscall 			#print the prompt 
 	li	$v0,SysReadString 	#load read-string function 
 	la	$a0,buffer		#load the address of the space allocated for the string 
 	li	$a1,SIZE 		#load the max size of the string 
 	syscall				#take a string input 
 	lb	$t0,($a0)		#load the first char inside the string 
 	beq	$t0,'\n',exit		#if its a new line character then exit the program
 	jal	check			#call the check function will return 0 in $v0 if not a palindrome and 1 if it is 
 	beqz	$v0,false		#if it is zero then not a palindrome go to false 
true:	li	$v0,SysPrintString	#load print string function 
 	la	$a0,pali		#else it a palindrome so load the true string 
 	syscall				#print that the string is a palindrome 
 	j	ask			#jump back and ask the user for another string 
false: 	 li	$v0,SysPrintString	#load print string function 
	la	$a0,notPali 		#load the not a palindrome string 
	syscall 			#print the string 
	j	ask			#jump back and ask the user for another string 
 exit:	li	$v0,SysExit
 	syscall 
 

		


		
	
