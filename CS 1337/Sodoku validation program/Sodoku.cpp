
//avd210006, Andrew Dmitrievsky 
#include <iostream>
#include <fstream>

using namespace std;



bool is_in_buffer(char *list, char num){   //function created to check if a value is inside the buffer, makes sure that there are no repeating output lines
    char *cur = list;                      
    for(int i = 0; i < 9; i++){            //creates a pointer and loops through the buffer if the pointer value is equal to the number in the function 
        if(*cur == num){                   //the function will return false as the number has already been read and doesn't need to be read again.
            return false;
        }
        cur++;
    }
    return true;                           //will return true if it's not in the buffer meaning that it still needs to be read
}

void clear_buffer(char *list){             //function will clear the buffer after checking each sector of the sodoku puzzle 
    char *cur = list;      
    for(int i = 0; i < 9; i++){            //casings a pointer to the list and loops through making it empty
        *cur = ' ';
        cur++; 
    }
    
}



string witch_box(int num){                //function created to translate the box number to a user-friendly output
    switch(num){                          
        case 0:
            return "upper left";
        case 1:
            return "upper middle";
        case 2:
            return "upper right";
        case 3:
            return "left";
        case 4:
            return "middle";
        case 5:
            return "right";
        case 6:
            return "lower left";
        case 7:
            return "lower middle";
        case 8:
            return "lower right";
        default:
            return "Error";              //the for loop in the sodoku_validition function should never go past 8 but if something goes wrong then it will print out an error
    }
    return "Error";
}

void sodoku_validation(char *puzzle,string seriel){
    //assign the number of spaces and errors in the sodoku puzzle for checking validity and if the puzzle is solved
    int spaces = 0;                                              
    int errors = 0;
    //assign two pointers to the beginning of the array so that one can move and the other can compare values
    char *pointer1 = puzzle; 
    char *pointer2 = puzzle;
    //create a buffer array so that each time we read a value it doesn't repeat itself if we make the same comparison again
    char *buffer = new char[9];
    char *buffer_pointer = buffer;  
    

    /* For each check I assign two pointers to loop through the numbers and compare the values, thus the two for loops in each check,
      while one pointer remains stationary the other is moving through and making comparisons. the third for loop on the outside is to keep
      track of which row, column or box the pointers are on. */

    ///////////////////////////////////////checking each row///////////////////////////////////////
    for(int row = 1; row < 10; row++){
        pointer1 = puzzle +(9*(row-1));     //the starting position of each pointer of each row is just the first element of the array plus the 9 times the row you're on
        
        for(int i = 0; i < 9; i++){
            pointer2 = pointer1 +1;         //set the second pointer to + 1 of where the second pointer is as we don't need to compare if they're in the same.
            
            for(int j = i+1; j < 9; j++){   //j is set to i+1 as the loop goes on we do not need to keep comparing the same values
                
                if(pointer1 == pointer2){   //if the pointers end up being the same continue 
                    pointer2++;
                    continue;
                }
                
                if(*pointer2 == ' '){       //spaces can repeat themself so if pointer2 is a space then continue
                    spaces++;               //this is the only spot where the spaces are counted, and the reason is that when checking each row it goes through every number in the sudoku puzzle, so we do not need to count spaces in other checks
                    pointer2++;
                    continue;
                }
                
                if((*pointer1 == *pointer2) and (is_in_buffer(buffer,*pointer1))){                                     //checks if the value of the pointers is the same if it is that means the sudoku puzzle is invalid also checks if the current pointer is in the buffer to make sure it doesent print something twice                           
                    cout << seriel << "\tinvalid \trow " << row << " has multiple " << *pointer1 << "s" << endl;       //prints out where is something invalid as well as the serial number
                    
                    *buffer_pointer = *pointer1;  //adding a number to the buffer so if it comes up again it doesn't
                    buffer_pointer++;             //moves it forward so if there are multiple repeating numbers it can store them
                    
                    errors++;                     //to see if the function is valid at the end of every check this will be seen in each check as we don't know if they're are errors there or not
                }
                pointer2++;                       //since we are on the same row the pointer only needs to move one forward for it to read the next number 
            }
            pointer1++;                           //moving the second pointer in the same as moving the first pointer
        }

    }
    
    //reset the buffer, as well as both the pointers
    buffer_pointer = buffer;
    clear_buffer(buffer);
    pointer1 = puzzle;
    pointer2 = puzzle; 
    
    ///////////////////////////////////////check each column///////////////////////////////////////
    for(int column = 1; column < 10; column++){
        pointer1 = puzzle + (column-1);              //the first position of each column of the pointer would just be the first row listed through
        
        for(int i = 0; i < 9; i++){
            
            pointer2 = pointer1 + 9;                 //as we are dealing with columns to get the next number we need to add 9
            
            for(int j = i+1; j<9;j++){
                
                if(pointer1 == pointer2 or *pointer2 == ' '){     //check if pointers are equal or *pointer2 is a space in which case the comparison should not be made
                    pointer2 += 9;                                //go to the next number and continue which font runs the rest of the for loop 
                    continue;
                }
                if((*pointer1 == *pointer2) and (is_in_buffer(buffer, *pointer1))){                                    //same as before if the value of pointer1 and pointer2 equel and they are not in the buffer then theres something wrong
                    cout << seriel << "\tinvalid \tcolumn " << column << " has multiple " << *pointer1 << "s" << endl; //print out what's wrong
                    
                    *buffer_pointer = *pointer1;             //add the number to the buffer so if it comes up again it doesn't repeat itself 
                    buffer_pointer++;                        //move the buffer pointer so that if there is another number that is not in the buffer it can be stored
                    errors++;                                //adds up the total errors 
                }
                pointer2 += 9;                               //the next number inside a column is directly below the current number or 9 spaces forward from where the pointer is so we move the pointer 9 spaces down 

            }
            pointer1 += 9;                                   

        }

 
    }

    /////////////////////////////////check each box///////////////////////////
    
    //reset the buffer, as well as both the pointers
    buffer_pointer = buffer;
    clear_buffer(buffer);
    pointer1 = puzzle;
    pointer2 = puzzle;
    
    //set all the necessary counters to make sure the pointer is moving properly through the array//
    int counter1 = 0;          //counter1 is used for pointer1 each time counter1 reaches 2 meaning that the pointer has moved three spaces, it will move down to the next row inside the box 
    int counter2 = 0;          //counter2 is used for pointer2, and the same thing happens as does in pointer1.
    int counter3 = 0;          //counter3 is used to keep count of which box the pointer is on, when it reaches 3 one will be added to row 1 which will move the default pointer position 18 slots down puting it at the start of the next square
    int row = 0;               //row keeps track of which row the box is on

    //NOTE: This code is just a little bit confusing to look at as there are a lot of variables being changed at the same time so for ease of reading I will put a "MOVEMENT" comment above blocks of code are responsible for moving the pointer and "MOVEMENT END where they end"//
    
    for(int box = 0; box < 9; box++){
        pointer1 = puzzle + ((box * 3) + (row*18)); //each box is on a row and each box starts 3 indexes from each other, so for each box, we add three to the initial position and for each row we add 18 as we need to skip over two rows 
        
        for(int i = 0; i < 9; i++){
            pointer2 = puzzle + ((box * 3) + (row*18));
            for(int j = 0; j < 9;j++){
                if(pointer1 == pointer2 or *pointer1 == ' '){              //as in the other checks if the pointers are the same or pointer1 is a space then continue
                    
                    //MOVEMENT FOR POINTER 2//                             //this movement is similar to other movements but every three moves it moves the pointer forward 7 times instead of 1
                    if(counter2 >= 2){
                        pointer2 += 7;
                        counter2 = 0;
                        continue;  
                    }
                    pointer2++;
                    counter2++;
                    continue;
                    //MOVEMENT ENDS//

                }
                if((*pointer1 == *pointer2) and is_in_buffer(buffer, *pointer1)){                                        //if pointers value are the same and not in the buffer will print out what's wrong with the box
                    cout << seriel << "\tinvalid \t" << witch_box(box) << " has multiple " << *pointer1 << "s" << endl;  //witch_box function takes in the current box were on and returns a string representation of that
                    *buffer_pointer = *pointer1;                 //add the value to the buffer so it doesn't repeat itself
                    buffer_pointer++;                            //move the buffer pointer so multiple values can be added 
                    errors++;                                    

                }
                
                //MOVEMENT FOR POINTER2//                 
                if(counter2 >= 2){
                    pointer2 += 7;
                    counter2 = 0; 
                    continue;
                }
                counter2++; 
                pointer2++;
                //MOVEMENT ENDS//

            }
            
            //MOVEMENT FOR POINTER1//
            if(counter1 >= 2){
                pointer1 += 7;
                counter1 = 0; 
                continue;
            }
            pointer1++;
            counter1++;
            //MOVEMENT ENDS//
        }
        
        //MOVEMENT FOR THE ROW THE BOXES ARE ON, BOTH POINTER1 AND POINTER2//
        counter3++;
        if(counter3 >= 3){
            counter3 = 0;
            row++;
        }
        //MOVEMENT ENDS//
    }
    
    if(spaces <= 0 and errors <= 0){               //if the program did not find any spaces or errors it will output solved
        cout << seriel << "\tsolved" << endl;
    }
    else if(errors <= 0){                          //if there's spaces it will check if there errors if there aren't any errors it will output valid if there are errors nothing will print out
        cout << seriel << "\tvalid" << endl; 
    }
    
    delete []buffer;                              //as we don't need buffer anymore we can delete it

}





int main(){
    //create a file stream and input the name of the file to be opened
    ifstream input; 
    string file_name; 
    cout << "input file: ";
    cin >> file_name;                        
    
    // file_name = "sssouduku.txt"; 
    input.open(file_name);                   //try opening the file 
    if(input){                               //if the file opens then start reading through it if not output the file could not be opened 
        char temp;                           //variable for holding the reading value
        
        string seriel;                       //variable for the number on the sudoku puzzle 
        
        char *sodoku = new char[81];         //array where the numbers will be stored 
        
        int counter = 0;                     //to count how many chars have been read inside the array

        while(input >> seriel){              //the first thing that this will see is the serial number and will input it
            
            char *temp_point = sodoku;       //assign a pointer to move through the array and add a value to it 
            
            while(counter < 81){             //while 81 characters have not been read continue to read characters into the array
                input.get(temp);
                if(temp != '\n'){            //if the read value is a newline then it should be read into the array            
                    
                    *temp_point = temp;      //setting the value of where the pointer is pointing to the char read and moving the pointer to the next memory location
                    temp_point++;
                    counter++;              
                }
            }
            
            sodoku_validation(sodoku,seriel);  //will take the array and the serial number and output the state of the sudoku puzzle as well as the serial number
            
            counter = 0;                       //reset the counter in case there more sodoku puzzles inside the file 


        }
        delete []sodoku;                       //after looping through we no longer need this array so we can delete it as well as close the file 
        input.close();
            
    }
    else{
        cout << "file could not be opened" << endl; 
    }
}
