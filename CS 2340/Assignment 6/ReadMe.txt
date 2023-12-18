Objective:
1.	The program must have a menu with three numbered options. 
1: Encrypt the file.  2: Decrypt the file.  3. Exit.  
This implies that you have a loop that displays the menu and shows the three options until the user exits.
2.	For options 1 and 2, request an input file name from the user.  
File names have a maximum length of 255 characters.  If the file does not exist, show an error message and return to the main menu.  
If the file does exist, request the “key” from the user.  This key is a string up to 60 characters long which will be used to encrypt or decrypt.  
If it is zero length, show an error message and return to the menu.  (You can request the key before you open the file, to make things easier.)
3.	For encryption, the extension of the input file name should be .txt. 
You will create an output file of the same name with the extension .enc.  
For decryption, your input name should have the extension .enc and you will create an output file with the same name and the extension .txt. 
Overwrite existing output files.  You may assume that the extension is followed by the first period in the file name. 
For example, c:\mips\test\input.txt has the period just before the extension and there are no other periods in the string. 
However, remember that the input need not be actual text; that is only the extension.  Your program should be able to encrypt anything, from a text file to an executable.
4.	Apply the encryption or decryption algorithm, described below.
5.	Return to the menu.
