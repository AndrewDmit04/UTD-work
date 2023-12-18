#----------------------------------------------------------------------------------------------------------------#
#Program written by: Andrew Dmitrievksy
#netID:AVD210006
#Purpose: sum up numbers that are inputted into the console,
#error check the number for valid input as well as check for negetive numbers.
#keep track of the number of invalid and valid inputs and at the end of the program,
#output the amount correct and incorrect inputs as well as the sum
#----------------------------------------------------------------------------------------------------------------#
		 
		 .include "SysCall.asm"									#system calls for not using magic numbers 
		 .eqv	BUFSIZE   100									#set buffsize or max number of charecters to be entered to 100
		.data

askUser:.asciiz 	"Enter a number: "								#string to ask the user for a number input
ErrS:	.asciiz	"Error encountered please enter valid number\n"		#Error string printed when a invalid input is met
sum:	.asciiz	"Sum="											#sum string used to show the total sum 
valid:	.asciiz	"\nCount of valid numbers = "						#count of valid numbers string used to show number of correct inputs 
ErrC:	.asciiz	"\nTotal number of errors: "						#Error Count, used to output the error count at the end of the program
buffer:	.space 	BUFSIZE										#a total of 100 numbers can be entered before the buffer will run out of space 
		.text
		.globl 	Main 
Main:	li		$t0,0					#intilize the sum
		li		$t1,0					  #intilize the correct count 
		li		$t2,0					  #intilize the incorrect count

ask:		li		$a2,0				#ask = ask user for input, $a2 will keep track of sign if  0 positive 1 negative intially we assume that the number is positive
		li		$v0,SysPrintString		#load printString Function
		la		$a0,askUser			#load the AskUser String
		syscall							  #print
		li		$v0,SysReadString		#load the readString function
		la		$a0,buffer			#load buffer adress into $a0
		li		$a1, BUFSIZE		#load the max size the String can be 100 charecters in this case 
		syscall
		li		$t4,0					  #set number we are calculating to 0 
		lb		$t3,0($a0)			#load the first char into $t3 
		beq		$t3,'\n',endPrg	#end prog if the input is a new line char
		beq		$t3,'-',ifN			#check if the first value is a negative sign if so branch to ifN which means if negative 
		j		cal						    #if number is not negative then just jump to cal for calculate

ifN:		li		$a2,1				#ifN = if  negative, set the data adress at $a2 to 1 meaning that we are dealing with a negative number 
		addi	$a0,$a0,1				#increment the input by 1 since we dont want to validate the intial - sign 
		j		cal						    #go to calculate the number

cal:		lb		$t3,0($a0)	#cal = calculate, cload the first byte in the string 
		beq		$t3,'\n',AoS		#if its a new line we are at the end of the string and we jump to AoS which stands for Add or Subtract
		subi		$t3,$t3,'0'		#subtract the aciiz value of zero
		blt		$t3,0,Error			#if value is below zero its not a number jump to error  (num<0)
		bgt		$t3,9,Error			#if value is above 9 its not a nuber jump to error (9<num)
		mul		$t4,$t4,10			#mulriply the number already stored by 10
		add 	$t4,$t4,$t3			#add the value of asciiz value to the acumaltor
		addi	$a0,$a0,1				#increment the data adress where the string
		j		cal						    #keep looping until reaching new line 

AoS:	addi	$t1,$t1,1			#AoS =Add or Subtract, add one to the valid number cound 
		bnez	$a2,subN				#if the value inside of $a2 is 1 , will branch to subn and subtract the calculated number 
		add		$t0,$t0,$t4			#if the value in $s2 is 0 it wont branch and will insted add the number to the running sum
		j		ask						    #go and ask for another number

subN:	sub		$t0,$t0,$t4		#subN = Subtract Number, will subtract the number calculated from the running sum 
		j 		ask						  #go and ask for another number 

Error:	li		$v0,SysPrintString		#if the validation fails load the print string function 
		la 		$a0,ErrS				#load the error message into $a0 
		syscall							  #print the error message 
		addi 	$t2,$t2,1				#add one to the amount of errors
		j		ask						    #ask for another number 

endPrg:	li		$v0,SysPrintString		#endPrg = end of Program, load the printing function 
		la		$a0,sum					#load the message associated with sum
		syscall 							#print the string
		#print sum
		li		$v0,SysPrintInt	#load the print a integer function 
		move	$a0,$t0					#move the accumalitive sum into $a0 
		syscall							  #print the sum
		#print correct nums string 
		li		$v0,SysPrintString		#load the print String function 
		la		$a0,valid				#load the string associated with correct number
		syscall							  #print the valid input String
		#print correct numbers calculated
		li		$v0,SysPrintInt	#load the print Int function 
		move	$a0,$t1					#move $t1 which counts how many valid numbers there are into $a0 so it can be printed 
		syscall							  #print the valid inputs 
		#print  incorrect numbers string
		li		$v0,SysPrintString		#load the print String function 
		la		$a0,ErrC				#load the string associated with the amount of errors found 
		syscall							  #print the string 
		#print the incorrect numbers calculated 
		li		$v0,SysPrintInt #load the print ubt functiion
		move	$a0,$t2					#load the calculated value into $a0 
		syscall							  #print the intiger
		li		$v0,SysExit			#load the exut program funcrtion
		syscall							  #exit
	

			

			
