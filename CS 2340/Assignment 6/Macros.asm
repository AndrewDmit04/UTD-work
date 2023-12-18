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
	#macro will print the string inside of the (" ")
	.macro printString (%String) 		#has one parameter for the string to be printed 
	.data 					#data section
temp:	.asciiz	%String 			#fill intilize the string passed in the macro to a address 
	.text	
	li		$v0, SysPrintString	#load the print String function
	la		$a0,temp 		#load the string initialized
	syscall 				#print the string 
	.end_macro				#end the macro
