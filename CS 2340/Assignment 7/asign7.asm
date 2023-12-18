#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a program that will take a string password, 
#and make sure that the password string is valid and within parameters
#parameters will make sure that the theres atleast one capitol letter, 
#one lower case letter, one number between 1-9, and atleast one of these symbols
#"!@#$%^&()[],.:;", the password must not contain invlaid charecters
#-----------------------------------------------------------------------------------------------------------------------------------------------#
	.include	"Macros.asm"		#import macros
	.include 	"SysCall.asm"		#import syscalls
	.data		
	.eqv 	maxSize	100			#set the max size of the input string  
pass:	.space	maxSize				#create a buffer for the string 
	.text 
	.globl		main 			#declare main as globl program will start here
main:	printString("Enter the password: ")	#prompt user for a password 
	li	$v0,SysReadString		#load the SysReadString function
	la	$a0, pass 			#load the buffer into $a0 
	li	$a1, maxSize			#load the max size into $a1
	syscall 				#get the input
	lb 	$t0, ($a0)			#load the first charecter of the input
	beq	$t0,'\n', exit			#check if its '\n' if it is then exit program
	jal	check				#if not then check if the password is valid
	beqz	$v0, inval			#if check returned 0 then invalid jump to inval
	printString("Valid password.\n")	#if not zero then valid password print valid password
	j 	main				#go back to main 
inval:	printString("Invalid password.\n")	#if zero print invalid password
	j	main 				#go back to main 
exit:	li	$v0,SysExit			#load the SysExit fucntion
	syscall					#exit the program
	
	
