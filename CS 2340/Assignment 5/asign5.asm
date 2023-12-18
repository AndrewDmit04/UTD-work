#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a program to take floating point input from the user then sort the data in accesending order,
#after sorting, print the numbers in order, Then find and print the count, sum, and avarage if the numbers.
#Learn about Coprocessecer one and how assembly language sees floating point compelety diffrent than Integer values 

#functions:
#1.sort: has one parameter which is the size will be passed in $a0, will sort Double precision floating point  numbers in memory 
#the label used to sort the numbers will be under nums.

#2.print: has one parameter which is the size will be passed in $a0, will print all the double precision floating point numbers in memory under nums label 
#while printing the numbers it will add each number to a sum, after printing the numbers it will print the count, sum, calculate the avrage by dividing sum / count 
#and printing the avarage

#-----------------------------------------------------------------------------------------------------------------------------------------------#
		
	.include	"sysCall.asm"
	.data
	.eqv 	MAX_SIZE	800	#max size of the array  100 numbers each 8 bytes so 800
nums:	.space	MAX_SIZE		#allocate the array 
prompt:	.asciiz	"Enter number: "	#prompt for user to enter a number
sorted:	.asciiz	"Sorted list:\n"	#will show the sorted numbers after sort 
cnt:	.asciiz	"Count: "		#will show how many numbers were entered 
sum:	.asciiz	"Sum: "			#will show the total of all the numebrs summned up
Avrg:	.asciiz	"Average: "		#will show the avarage of all the numebrs 
noNum:	.asciiz	"no numbers were entered"#will be used if no numbers were entered
newLine:.asciiz	"\n"			#will be used as a newline character 
 	.globl	main			#declare where the program will start
	.text 
#main
main:	la	$a1,nums		#load the adress where we are storing the float values at  
	li	$t0,0			#itilize number counter to zero
	mtc1	$zero,$f2		#zero out one of the coprocceser register $f2 
	cvt.d.w $f2,$f2 		#convert the zero to double precision so that $f3 is zero as well  				  
ask:	li	$v0,SysPrintString 	#load the print string function 
	la	$a0,prompt		#load the string prompt associated with the prompt into $a0 
	syscall 			#print the prompt 
	li	$v0,SysReadDouble	#load the read double function 
	syscall 			#call the function and store the input into $f0 
	c.eq.d	$f0,$f2 		#check if the number entered is equal to zero
	bc1t	exit			#if it is equal to zero then exit if not then fall through 
	swc1	$f0,($a1)		#store the first 4 bytes from register $f0 into our "array"
	swc1	$f1,4($a1)		#store the second 4 bytes from register $f1 into our "array"
	addi 	$a1,$a1,8		#add 8 to the adress as a double is 8 bytes long 
	addi 	$t0,$t0,1		#add 1 to the counter of the current numebrs 
	j 	ask 			#go back and ask for another number 
exit:	move	$a0,$t0 		#move the count of numbers into $a0
	beq	$a0,0,noIn		#if the count is zero meaning there was no input jump to noIn which means no Input 
	beq	$a0,1,noSort		#if there was only 1 number inputed then we do not need to sort it so jump around the sort function 
	jal	sort			#call the sort function which will sort the "array" in adress of nums
noSort:	jal 	print			#call the print function which will print the "array" inside of nums
	li	$v0,SysExit 		#load the System Exit function 
	syscall 			#exit 

#printing function 
print:	la	$a1,nums 		#load the adress of the numbers into $a1
	move	$t0, $a0		#move the counter from $a0 to $t0 
	move	$a2, $a0		#move the cou
	mtc1	$zero,$f4		#move zero into $f4 
	cvt.d.w	$f4,$f4			#convert the zero into a double, register $f4 is the sum accumalator 
	li	$v0,SysPrintString 	#load the print string function
	la	$a0,sorted		#load the "sorted list" string 
	syscall				#print the string 
Ploop:	beqz 	$t0,pInfo 		#if $t0 is equal 0 which is the count inside the array start printing the info,Ploop means print loop
	lwc1	$f12,($a1)		#load the first 4 bytes of the string into $f12 
	lwc1	$f13,4($a1)		#load the second part of the 4 bytes into $g13
	li	$v0,SysPrintDouble	#laod the print double function
	syscall				#print the double
	li	$v0,SysPrintString 	#load the print string function
	la	$a0,newLine		#load the newLine charecter 
	syscall				#print a new line
	add.d	$f4,$f4,$f12 		#add double number to accumator 
	subi	$t0,$t0,1		#subtract one from the size 
	addi	$a1,$a1,8		#add 8 to the adress which will move it one numebr forward 
	j	Ploop 			#contunie looping until $t0 which is the count is 0 
pInfo:	li	$v0,SysPrintString 	#load the print string function
	la	$a0,cnt			#load the "count" string 
	syscall				#print the count 
	li	$v0,SysPrintInt		#load the print Integer function
	move	$a0,$a2			#load the count into $a0 
	syscall				#print the count 
	li	$v0,SysPrintString 	#load the print string function
	la	$a0,newLine		#load the newline
	syscall				#print the newline 
	la	$a0,sum			#load the string associated with the sum 
	syscall				#print the "sum" string 
	mov.d	$f12,$f4 		#move the value from the accumalator into $f12 
	li	$v0,SysPrintDouble 	#load the print Double funtion
	syscall				#print the sum from the accumalator
	li	$v0,SysPrintString 	#load the print String function
	la	$a0,newLine		#load the new line 
	syscall				#print the new line 
	la	$a0,Avrg		#load the "Avarage" String 
	syscall 			#print the "Avarage" String
	li	$v0,SysPrintDouble 	#load the print Double function 
	mtc1	$a2,$f6			#move the count into a floating point register 
	cvt.d.w	$f6,$f6			#convert the count from a int to double 
	div.d	$f12,$f4,$f6		#divide the sum by the count store into $f12 which is the register double will print from
	syscall				#print the double
	jr		$ra		#jump back to call adress 

#sorting function 	
sort:	la	$a1, nums		#load the adress of the "array in to $a1"
	li	$t0, 0 			#$t0 will act as bool of isSwapping so will contunie to loop while swapping 
	move	$t1,$a0			#move the count of numbers which is stored in $a0 into $t1 
	subi	$t1,$t1,1		#subtarct one as the numebr of comparisons we have to make is n-1 
for:	lwc1	$f0,($a1)		#load first part of the num into register $f0 
	lwc1	$f1,4($a1)		#load the second part of the num into register $f1
	lwc1 	$f2,8($a1)		#load the first part of the second num into register $f2
	lwc1	$f3,12($a1) 		#load the second part of the second num into regiuster $f3
	c.lt.d	$f2,$f0			#compare if the double inside $f2 is less than $f0
	bc1f	noSwap			#if false then we do not swap them else fall through 
	swc1	$f2,($a1)		#store the first 4 bytes of the second num into where the first num was  
	swc1	$f3,4($a1)		#store the second 4 bytes of the second num into where the first num was 
	swc1	$f0,8($a1)		#store the first 4 bytes of the first num into where the second num was 
	swc1	$f1,12($a1)		#store the second 4 bytes of the first num into where the second num was 
	li	$t0,1			#set $t0 to 1 which indicates that we are still swapping 
noSwap:	addi	$a1,$a1,8		#add 8 bytes to the the adress in $a1 which will move one number forward 
	subi	$t1,$t1,1		#subtract 1 from $t1 whjich has the number of comparrions needed to be made
	bnez	$t1,for			#contunie branching until the number of comparions reaches 0 
	bnez	$t0,sort		#contnie sorting until $t0 is equal to 0 which means no swaps where made
	jr	$ra			#jump back to the call adress 

#exit function if there is no input 	
noIn:	li	$v0,SysPrintString 	#load the printing function
	la	$a0,noNum		#load the string associated with no input
	syscall				#print the string 
	li	$v0,SysExit 		#load the exit function
	syscall				#exit the program

 

		


		
	
