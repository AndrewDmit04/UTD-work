#----------------------------------------------------------------------------------------------------------------------------------------------#
#written by: Andrew Dmitrievsky
#NET-ID: AVD210006
#Purpose: Write a program that will take a string password, 
#and make sure that the password string is valid and within the parameters
#parameters will make sure that there at least one capital letter, 
#one lowercase letter, one number between 1-9, and at least one of these symbols
#"!@#$%^&()[],.:;", the password must not contain invalid characters
#-----------------------------------------------------------------------------------------------------------------------------------------------#	
	.data
chars:	.asciiz	"!@#$%^&()[],.:;" #string of all valid special characters
	.eqv 	firstBit, 1 	#first bit - is the Upper case letter bit will be flipped if an upper case letter is seen	
	.eqv	secondBit,2	#second bit - is the Lower case letter bit will be flipped if a lowercase letter is seen
	.eqv	thirdBit,4	#third bit - is the number bit will be flipped if a number is seen 
	.eqv	fourthBit,8 	#fourth bit - is the special character bit, will be flipped if one of the special characters is seen
	.eqv	fithBit,16	#fith bit - is the size bit will be flipped if the size is between 12 and 50
	.eqv	sixthBit,32	#sixth bit - is the error bit will be flipped if there an invalid character that has been seen
	.eqv	VALID,0x1f	#if the value is valid the value of the bits will be 0001 1111 which is 0x1f in hexadecimal
	.text 
	.globl 		check 	#declare check as globl so it can be called from main
##########################################Check password function##############################################################
#inputs: $a0 contains the password string that is being checked for being valid
#outputs: $v0 cointains a 0 if the password is invalid and a 1 if the password is valid
check:	li	$t0,0 		#status register-each bit in this register will represent a condition that can be used to see if all of them are met
	li	$t1,0 		#keep track of the length
	li	$t2,0		#hit register-will see if a character is valid 	
	subi	$sp,$sp, 4	#allocate room for the return address 
	sw	$ra, ($sp)	#save the return address
CLoop:	li	$t2,0 		#set the hit register to zero assume the character is invalid 
	lb	$t3,($a0)	#load a character from the password
	beq 	$t3,'\n',return	#if the character is a '\n' then return
	addi	$t1,$t1,1 	#add one to the length
	addi	$a0,$a0,1 	#increment the string address
	jal	CUpper		#check if the character is an uppercase letter
	jal	CLower 		#check if the character is a lowercase letter
	jal	CNum		#check f the character is a number between 1-9 
	jal	CSym		#check if the character is a special character
	jal	Chit		#check if there was a hit or one of the checks above returned as valid
	beqz	$t2,return 	#if the register $t2 is 0 at this point then the password is invalid and we can return
	j	CLoop		# continue looping until we reach '\n'
##############################################################################################################################
	
##########################################Check Upper letter function#########################################################
#inputs: A character in $t3
#outputs: checks if the character is an uppercase letter if it is, flip the first bit in $t0
CUpper:	sge	$t4,$t3,'A'	#check if the value of $t3 is greater than 'A'
	sle	$t5,$t3,'Z'	#check if the value of $t3 is less than 'Z'
	and	$t4,$t4,$t5	#if it is less than 'Z' and greater than 'A' then it's a capital letter 
	bnez	$t4,cap		#if and returns 1 then it's a capital letter jump to cap
	jr	$ra		#if not jump the to the return address
cap:	li	$t2, 1		# indicates that there has been a valid character found 
	or	$t0,$t0,firstBit#flip the first bit in the $t0 register
	jr	$ra 		#jump to the return address
##############################################################################################################################

##########################################Check Lower letter function#########################################################
#inputs: A character in $t3
#outputs: checks if the character is a lowercase letter if it is, flip the second bit in $t0
CLower:	sge	$t4,$t3,'a'	#check if the value of $t0 is greater than 'a'
	sle	$t5,$t3,'z'	#check if the value of $t0 is less than 'z' 
	and	$t4,$t4,$t5	#if it's both greater than 'a' and less than 'z' is a lowercase letter 
	bnez	$t4,low		#if and returned 1 then we know it a lower case letter so jump to low
	jr	$ra 		#jump the return address
low:	li	$t2,1 		#indicate that there has been a valid character found
	or	$t0,$t0,secondBit#flip the two-bit on 
	jr	$ra
##############################################################################################################################

##########################################Check if Number function############################################################
#inputs: A charecter in $t3
#outputs: checks if the charecter is a number between 1-9 and flips the 3rd bit in $t0 if it is
CNum:	move	$t4,$t3		#move the value to another register to compare
	subi	$t4,$t4,'0'	#subtrack '0' from the made copy 
	sge	$t5,$t4,0	#check if the character's value is above 0
	sle	$t6,$t4,9	#check if the character's value is below 0  
	and	$t5,$t5,$t6	#if it's above 0 and below 9 then it's a number, and $t5 will be 1
	bnez	$t5,num 	#if $t5 is not zero meaning its number jumps to num
	jr	$ra		#if it is zero then jump to the return address
num:	li	$t2,1 		#idicate that has been a valid character found
	or	$t0,$t0,thirdBit#flip the third bit in $t0 indicating a number has been found
	jr	$ra		#jump the return address
##############################################################################################################################

##########################################Check valid Symbol function#########################################################
#inputs: A character in $t3
#outputs: checks, if the charecter is special, will flip the 4th bit in $t0 if it is
CSym:	la	$a1,chars	#load the string of valid character into $a1
find:	lb	$t4,($a1)	#load the first character from the valid characters
	beqz	$t4,Nfoun	#if the character is 0 then it's not found as we are at the end of the string
	beq	$t4,$t3,foun	#check if the character value equals the character value of the valid characters if they do jump to four, as in found
	addi	$a1,$a1,1	#if not add one to the valid character string address 
	j	find		#jump back found and continue looping until the end of the string is reached
foun:	li	$t2,1 		#if it is found then indicate that a valid character has been found
	or	$t0,$t0,fourthBit#flip the fourth bit in $t0
Nfoun:	jr	$ra		#jump to the return address	
##############################################################################################################################

##########################################Check length function###############################################################
#inputs: A string length in $t1
#outputs: checks if the length is above 12 and below 50 if so will flip the fifth bit in $t0
Clen:	sge	$t4,$t1,12	#check if the length is above 12 
	sle	$t5,$t1,50	#check if the length is below 50
	and	$t4,$t4,$t5	#and both the results if 1 then the condition is met if 0 then not
	beqz	$t4,badL	#if $t4 is zero then the length is invalid jump to badL or bad length
	or	$t0,$t0,fithBit #if not then flip the fish bit in $t0
badL:	jr	$ra		#jump to the return address
##############################################################################################################################

##########################################Check for a hit function############################################################
#inputs: register $t2
#outputs: will flip the 6th bith $t0 if the register $t2 is 1
Chit:	bnez	$t2,hit		#if the $t2 is zero, not zero then we do not need to flip the sixth bit 
	or	$t0,sixthBit	#flip the sixth bit indicating the whole thing is invalid
hit:	jr	$ra		#jump to the return address
##############################################################################################################################

##########################################return function#####################################################################
#inputs: $t0 the status register
#outputs: $v0 will be 1 if $t0 is valid and 0 if $t0 is invalid
return:	jal	Clen		#check the length of the string to be valid
	lw	$ra, ($sp)	#load the return address of the original called function from the main
	addi	$sp, $sp,4 	#dealocate the stack pointer
	beq	$t0,VALID,val 	#if the value in $t0 matches the VALID then the password is valid and jumps to val
	li	$v0, 0		#if not then load $v0 with zero
	jr	$ra		#jump to return address loaded from the stack
val:	li	$v0,1 		#load $v0 with 1 
	jr 	$ra		#jummp to return address loaded from the stack
##############################################################################################################################
