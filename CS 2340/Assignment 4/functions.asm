	.eqv	SysAlloc	9	#9 is the function for system allocation 
	.eqv	TO_LOW		32 	#0010 0000 is 32 in binary so if we or with 32 we will affectivily convert all uppercase letters to lower case
	.text		
	.globl	check			#globl function to call from other file 

check:	li	$t4,0		#will keep count of the length of the string passed in
	move	$a1,$a0		#move the adress of the string to $a1
length:	lb	$a0,($a1)	#load the char in the string 
	addi 	$t4,$t4,1	#add one to the size of the string 
	addi	$a1,$a1,1	#increment the adress by 1
	bnez	$a0,length	#check if the loaded value is a binary zero if its not contunie looping 
		
	sub	$a1,$a1,$t4	#move pointer back to the start of the stri
	move	$a0,$t4		#move the count of charecters to $a0 
	li	$v0, SysAlloc	#load the memory allocation function
	syscall 		#the number of charecte
	move	$a2,$v0		#move the adress of the allocated stirng into $a2
	li	$t4,0		#reset the counter as now we only want to count the valid chareters
remove:	lbu	$t0,0($a1)	#load first letter from read string 
	addi	$a1,$a1,1	#increment the adress by 1
	beq	$t0,'\n',pali	#if the charechter we loaded is a new line we are at the end of the string so now we can call  palindrome function from here
	move	$t1,$t0		#were about to check if its a number so we need to copy the charecter into a another register $t1 in this case 
	subi	$t1,$t1,'0'	#subtrack '0' from the made copy 
	blt	$t1,0,remove	#if value is below 0 than its not a letter or a number so we can move on to the next char
	sgt	$t2,$t1,9	#if above 9 then not a number  then its not a number
	beqz	$t2,addTo	#if it is below 9 and if were here it must be above zero so its a number so add it our string
	sge	$t2,$t0,'A'	#check if the value of $t0 is greater than 'A'
	sle	$t3,$t0,'Z'	#check if the value of $t0 is less than 'Z'
	and	$t2,$t2,$t3	#if it is less than 'Z' and greater than 'A' then its a capitol letter 
	bnez	$t2,toLow	#if and return 1 into the register we not its a a capitol letter so we want to call our lowercase function
	sge	$t2,$t0,'a'	#check if the value of $t0 is greater than 'a'
	sle	$t3,$t0,'z'	#check if the calue of $t0 is less than 'z' 
	and	$t2,$t2,$t3	#if its both greater than 'a' and less than 'z' its a lower case letter 
	bnez	$t2,addTo	#if and returned 1 then we know its a lower case letter so add it to our new string 
	j	remove		#if  we get to this point the charecter is invalid so we dont add it and move on to the next char 
toLow:	ori	$t0,$t0,TO_LOW	#theres a 32 number diffreance between capitol and lowercase letters 0010 0000 is 32 in binary so if we or with 32
addTo:	sb	$t0,($v0)	#store the number inside our new string 
	addi	$v0,$v0,1 	#increment the address by one to point at the next char
	addi	$t4,$t4,1 	#add one to the size of the string 
	j	remove		#contunie looping

pali:	li	$t2,1		#this is assuming that the string is a palindrome																																												
	subi	$sp,$sp,8	#allocate 8 bytes from the stack one 4 bytes for return adress 4 bytes for string adress 
	sw	$ra,($sp)	#store the return adress inside the stack
	sw	$a2,4($sp)	#store the string adress inside the stack 
	beq	$t4,1,return	#if the length of the string is equal to 1 then start returning 
	beqz	$t4,return	#if the length of the string is equel to 0 then start returning 
	li	$t2,0		#assume now that the string is not a palindrome 
	lb	$t0,($a2)	#load first charecter of the string 
	subi	$t4,$t4,1	#subtract one to see how many times to go forward to get to last charecter of the string 
	add	$a2,$a2,$t4	#add length - 1 to move to the last charecter of the string 
	lb	$t1,($a2)	#load the last charecter of the string 
	sub	$a2,$a2,$t4 	#subtract length -1 to reset the pointer 	
	bne	$t0,$t1,return	#if first and last value not the same start  returning
	addi 	$a2,$a2,1	#we dont care about the first char anymore so move the pointer one forward 
	addi	$t4,$t4,1	#we subtracted 1 from the length earlier so now we need to add it back so the it copies correctly 
	li	$v0,SysAlloc	#load the allocation function
	subi	$t4,$t4,2	#subtract 2 from the length of the string as we are removing the first and last charecter from the string 
	move	$a0,$t4 	#move the length of the new string into $a0 which represents the number of bytes to allocate 
	syscall			#allocate the needed bytes for the string 
	move	$t0,$t4		#copy the length of the string into another register 
	move	$a3,$v0		#copy the adress of the string so we can move through it withouth losing the original
copy:	beqz 	$t0,exit	#if the length is equeal to zero exit the copy loop
	lb	$t1,($a2)	#load the charecter from string being copied 
	sb	$t1,($a3)	#store it into the new allocated string 
	addi	$a2,$a2,1	#add one to the original string, NOTE: dont need to make copy of this as its stored inside the stack
	addi	$a3,$a3,1	#increment the address of the new string by 1 
	subi	$t0,$t0,1 	#subtract 1 from the length of the string
	j	copy		#contunie looping 
exit:	move 	$a2,$v0		#move the adress of the new string into $a2 
	jal 	pali		#contunie to call the function recursively 
return:	lw	$ra,($sp)	#load the return adress from the stack
	lw	$a2,4($sp)	#load the string back from the stack, NOTE: we dont use it here but Im still loading it as im sure in higher langues like C when doing recursion it will load the varibles even if not used
	addi	$sp,$sp,8	#move forward to the stack, deallocating 
	move	$v0,$t2		#move the return value into $v0 if 0 not a palindrome if 1 a palindrome 
	jr	$ra		#jump to the adress loaded from stack 

	
		
		
		
		
