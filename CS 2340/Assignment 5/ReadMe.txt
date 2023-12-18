Objective: 
Part 1: The main loop asks the user for a double-precision number.  Use system call 7 to read the number.  If the number is zero, exit this loop and go to part 2.  
If the number is not zero, store it in memory.  I hesitate to say “store it in an array,” but that is what you will be doing.  You can use the .space directive to allocate this.  
Since assembly language doesn’t really understand anything but memory (no type checking) this works.  Keep track of how many numbers you have.  Do not print the number.  
You may assume there will be no more than 100 numbers entered. 

Part 2: Sorting.  Write a function (do not fall through to in-line code) that sorts the numbers from smallest to largest.  
You can use any sorting algorithm you know; I suggest bubble sort because it is easy and you probably know it.  
Parameters to this function are: $a0 contains the count of numbers entered.  
You can code this function in the same module as your main program so it can use the name of your list of entered numbers.  (Grammatical note: numbers are entered, not inputted.)

Part 3: Printing.  Write a function, called from your main program, that prints the sorted numbers one per line followed by the count of numbers entered, the sum, and the average.  
You can sum and average the numbers in this function.  
You can also code this function in the same module as your main program so it can use the name of your list of entered numbers.  
Register $a0 will contain the number of items in your list.
