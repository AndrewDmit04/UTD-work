Objective:
1.	Request an integer from the user.  If it is less than 3 or greater than 160,000, show an error message and go back to 1.
2.	Allocate n/8 bytes of memory and fill it with all one bits.  That is, put hex FF in each byte, meaning that initially we assume all numbers are prime.  If n is not an even multiple of 8, round up.  Use the SBRK (SysAlloc in my SysCalls.asm file) system call to allocate memory.  Do not allocate it using the .space directive in your program.
3.	Starting with bit 2, representing the number 2, set each bit to zero that is a multiple of 2, but do not set bit 2 to zero, since 2 is prime.  See example below.  (The bit may already be zero, but that doesn’t matter.)
4.	Find the next non-zero bit in the array, compute its position as a number (this will be 3) and set every third bit to zero.  The “array” is zero origin, so as shown, the first bit is numbered zero, then 1, etc.  Whether you consider the high bit or the low bit in the byte to be the “zeroth” bit in that byte is up to you as long as you are consistent.  I’m showing it with the high bit as zero for convenience because that is also the byte order.
5.	The algorithm terminates when you have used bits up to n/2.
6.	Go through the array and compute the bit position of every 1 bit, and print the position,  Those will be your primes.  Print one prime number per line, or if you’re ambitious, print 10 per line separated by spaces.
7.	Stop
