#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a multi file program, the first file contains the I/O responsibilities of the program
#The second file contains functions that will check if the inputted string is a palindrome
#the program will tell if a input string is a palindrome or not ignoring everything that is not a letter 
#or number.

#function in file:
#1.length: counts the length of the input string puts length in $t4  
#and then allocates memory for new string adress allocted adress in $a2 

#2.remove: checks if a charecters are valid inside $a1 if it is valid  it will pass it to the addTo 
#function or toLow function which will add the charecter to the allocated string in $a2

#3.toLow: converts capitol letter passed in $t0 to lower case letters then passes it to addTo

#4.addTo: will add the passed charecter to it in $t0 to the allocated adress in $a2

#5.Pali: Will determine if the string passed to it in $a2 is a palindrome or not, 
#it will do this by checking if the first and last letter of the string are equal, if they
#are equal the function will create another copy of the string without the first and last 
#charecter and put it in $a2 and call itself again, will contunie to recursively call itself 
#until it reached length 1 or 0, when length is 1 or 0 will return 1 inside $v0. If at some point 
#the first and last charecter are not equal then it will return 0 inside $v0
#-----------------------------------------------------------------------------------------------------------------------------------------------#
		
		.include	"sysCall.asm"
		.data
		.eqv 	SIZE	202		#max size of input 
prompt:		.asciiz	"Input string:"		#intial prompt to the user 
pali:		.asciiz	"Palindrome\n"		#if its a palindrome print out palindrome 
notPali:	.asciiz	"Not a Palindome\n"	#if not a palindrome print out not a palindrome 
buffer:		.space	SIZE			#space for the input string 
 		.text		
ask:	li	$v0,SysPrintString 	#load print string fucntion 
 	la	$a0,prompt		#load the prompt 
 	syscall 			#print the prompt 
 	li	$v0,SysReadString 	#load read string function 
 	la	$a0,buffer		#load the adress of the space allocated for the stirng 
 	li	$a1,SIZE 		#load the max size of the string 
 	syscall				#take a string input 
 	lb	$t0,($a0)		#load the first char inside the string 
 	beq	$t0,'\n',exit		#if the its a new line charecter then exit the program
 	jal	check			#call the check function will return 0 in $v0 if not a palindrome and 1 if it is 
 	beqz	$v0,false		#if it is zero then not a pandrome go to false 
true:	li	$v0,SysPrintString	#load print string function 
 	la	$a0,pali		#else its a palindrome so load the true string 
 	syscall				#print that the string is a palindrome 
 	j	ask			#jump back and ask user for another string 
false: 	 li	$v0,SysPrintString	#load print string function 
	la	$a0,notPali 		#load the not a palindrome string 
	syscall 			#print the string 
	j	ask			#jump back and ask user for another string 
 exit:	li	$v0,SysExit
 	syscall 
 

		


		
	
