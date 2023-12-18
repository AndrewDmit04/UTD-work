#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a program that will take a string password, 
#and make sure that the password string is valid and within parameters
#parameters will make sure that the theres atleast one capitol letter, 
#one lower case letter, one number between 1-9, and atleast one of these symbols
#"!@#$%^&()[],.:;", the password must not contain invlaid charecters
#-----------------------------------------------------------------------------------------------------------------------------------------------#	
	#macro will print the string inside of the (" ")
	.macro printString (%String) 		#has one parameter for the string to be printed 
	.data 					#data section
temp:	.asciiz	%String 			#fill intilize the string passed in the macro to a adress 
	.text	
	li		$v0, SysPrintString	#load the print String function
	la		$a0,temp 		#load the string intilized
	syscall 				#print the string 
	.end_macro				#end the macro
