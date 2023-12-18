	.eqv	SysAlloc	9	#9 is the function for system allocation 
	.eqv	TO_LOW		32 	#0010 0000 is 32 in binary so if we or with 32 we will effectively convert all uppercase letters to lowercase
	.text		
	.globl	check			#globl function to call from another file 

check:	li	$t4,0		#will keep count of the length of the string passed in
	move	$a1,$a0		#move the address of the string to $a1
length:	lb	$a0,($a1)	#load the char in the string 
	addi 	$t4,$t4,1	#add one to the size of the string 
	addi	$a1,$a1,1	#increment the address by 1
	bnez	$a0,length	#check if the loaded value is a binary zero if its not continue looping 
		
	sub	$a1,$a1,$t4	#move pointer back to the start of the string
	move	$a0,$t4		#move the count of characters to $a0 
	li	$v0, SysAlloc	#load the memory allocation function
	syscall 		#the number of characters
	move	$a2,$v0		#move the address of the allocated string into $a2
	li	$t4,0		#reset the counter as now we only want to count the valid characters
remove:	lbu	$t0,0($a1)	#load first letter from read-string 
	addi	$a1,$a1,1	#increment the address by 1
	beq	$t0,'\n',pali	#if the character we loaded is a new line we are at the end of the string so now we can call  the palindrome function from here
	move	$t1,$t0		# was about to check if it is a number so we need to copy the character into another register $t1 in this case 
	subi	$t1,$t1,'0'	#subtrack '0' from the made copy 
	blt	$t1,0,remove	#if the value is below 0 than, not a letter or a number so we can move on to the next char
	sgt	$t2,$t1,9	#if above 9 then not a number  then it's not a number
	beqz	$t2,addTo	#if it is below 9, and if we hear it must be above zero so it is a number so add it to our string
	sge	$t2,$t0,'A'	#check if the value of $t0 is greater than 'A'
	sle	$t3,$t0,'Z'	#check if the value of $t0 is less than 'Z'
	and	$t2,$t2,$t3	#if it is less than 'Z' and greater than 'A' then it's a capital letter 
	bnez	$t2,toLow	#if and return 1 into the register we not its a capital letter so we want to call our lowercase function
	sge	$t2,$t0,'a'	#check if the value of $t0 is greater than 'a'
	sle	$t3,$t0,'z'	#check if the value of $t0 is less than 'z' 
	and	$t2,$t2,$t3	#if it's both greater than 'a' and less than 'z' is a lowercase letter 
	bnez	$t2,addTo	#if and returned 1 then we know it is a lowercase letter so add it to our new string 
	j	remove		#if  we get to this point the character is invalid so we don't add it and move on to the next char 
toLow:	ori	$t0,$t0,TO_LOW	# There is a 32 number difference between capital and lowercase letters 0010 0000 is 32 in binary so if we or with 32
addTo:	sb	$t0,($v0)	#store the number inside our new string 
	addi	$v0,$v0,1 	#increment the address by one to point at the next char
	addi	$t4,$t4,1 	#add one to the size of the string 
	j	remove		#contunie looping

pali:	li	$t2,1		#this is assuming that the string is a palindrome																																												
	subi	$sp,$sp,8	#allocate 8 bytes from the stack one 4 bytes for the return address and 4 bytes for the string address 
	sw	$ra,($sp)	#store the return address inside the stack
	sw	$a2,4($sp)	#store the string address inside the stack 
	beq	$t4,1,return	#if the length of the string is equal to 1 then start returning 
	beqz	$t4,return	#if the length of the string is equal to 0 then start returning 
	li	$t2,0		#assume now that the string is not a palindrome 
	lb	$t0,($a2)	#load first character of the string 
	subi	$t4,$t4,1	#subtract one to see how many times to go forward to get to last character of the string 
	add	$a2,$a2,$t4	#add length - 1 to move to the last character of the string 
	lb	$t1,($a2)	#load the last character of the string 
	sub	$a2,$a2,$t4 	#subtract length -1 to reset the pointer 	
	bne	$t0,$t1,return	#if first and last value not the same start  returning
	addi 	$a2,$a2,1	#we do not care about the first char anymore so move the pointer one forward 
	addi	$t4,$t4,1	#we subtracted 1 from the length earlier so now we need to add it back so that it copies correctly 
	li	$v0,SysAlloc	#load the allocation function
	subi	$t4,$t4,2	#subtract 2 from the length of the string as we are removing the first and last character from the string 
	move	$a0,$t4 	#move the length of the new string into $a0 which represents the number of bytes to allocate 
	syscall			#allocate the needed bytes for the string 
	move	$t0,$t4		#copy the length of the string into another register 
	move	$a3,$v0		#copy the address of the string so we can move through it without losing the original
copy:	beqz 	$t0,exit	#if the length is equal to zero exits the copy loop
	lb	$t1,($a2)	#load the character from string being copied 
	sb	$t1,($a3)	#store it into the new allocated string 
	addi	$a2,$a2,1	#add one to the original string, NOTE: don't need to make a copy of this as it's stored inside the stack
	addi	$a3,$a3,1	#increment the address of the new string by 1 
	subi	$t0,$t0,1 	#subtract 1 from the length of the string
	j	copy		#contunie looping 
exit:	move 	$a2,$v0		#move the address of the new string into $a2 
	jal 	pali		#contunie to call the function recursively 
return:	lw	$ra,($sp)	#load the return address from the stack
	lw	$a2,4($sp)	#load the string back from the stack, NOTE: we don't use it here but I am still loading it as I'm sure in higher languages like C when doing recursion it will load the variables even if not used
	addi	$sp,$sp,8	#move forward to the stack, deallocating 
	move	$v0,$t2		#move the return value into $v0 if 0 not a palindrome if 1 a palindrome 
	jr	$ra		#jump to the address loaded from the stack 

	
		
		
		
		
