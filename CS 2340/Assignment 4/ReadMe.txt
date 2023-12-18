Objective:
Palindromes
A palindrome is a word or phrase that reads the same from left to right as right to left.  A simple palindrome is “kayak,” for example.  Other rules are that you ignore punctuation and letter case.  For example, “Madam, I’m Adam” is a palindrome despite commas, spaces, and upper and lower case differences.  Palindromes can also contain digits, such as “12421”.  
Write a program that does the following:
1.	Request a string from the user.  If it is zero length (the first character is ‘\n’) exit the program.
2.	Determine if the string is a palindrome.  If so, print “Palindrome.”  If not, print “Not a palindrome.”
3.	Return to request another string.
Program structure:
1.	You can assume no input string is longer than 200 characters.
2.	Write a helper function that calls three functions, as defined below. This structure is required.  The parameter is the address of the input string in $a0.
a.	Within this function, you must call another function that removes anything that isn’t a letter or a number.
b.	Within the second function, call a third function that converts lower case to upper case so your comparisons work properly.
c.	You must write a function that determines whether the string is a palindrome.  Call this with the address of the string in $a0 and no other parameters.  This function must be recursive.  That is, it must test whether the initial string might be a palindrome and return true if it the outer two characters match and false if they don’t, meaning if you return false at any level, stop the recursive calls and return false.  If you return true, remove the first and last characters of the string and pass the address of the shortened string in $a0.  Treat the original string as immutable, much as Java does. (How does Java deal with this?)
3.	You must have two files.  The first has the main body of your code that requests a string, calls a function that checks a palindrome, which is item 2, above plus initialization code.  The second file has any subroutines you may need, such as removing punctuation and converting case.
This structure is part of the requirements and something you need to learn.  
Recursion is also part of this.  Consider how you pass a string as an argument such that each level gets a new string on the stack. 
Is a string of length 0 or length 1 a palindrome? 



