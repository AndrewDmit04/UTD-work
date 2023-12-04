//AVD210006 Andrew Dmitrievsky
#include <fstream>
#include <iostream>
#include <string>
#include <iomanip>
#include <sstream>
#include "LinkedList.h"

using namespace std;


void getInfo(string line,LinkedList &L){
    //variables used to calculate what x is in the equation 
    double num_at; 
    double num_at_multy = 1; 
    
    //for the determining the Coef and Exp of the function
    double Coef; 
    int Exp; 
    
    //initialize a string steam to read from output the original line fed in the function to it and begin to read of the stream
    stringstream o; 
    o << line; 
    //create a variable temp read in the first thing in the string stream which should  be "f(number)"
    string temp; 
    o >> temp;
    
    //since the temp is "f(number)" the first two characters are "f(" so start = 2 will go to the third character where the number should start
    int start = 2;   //start will be used to see where the number starts so that substr can read from it 
    int length = 0;  //and length will be used to see how long the number is so that Sunbstr can read the number accurately 
    
    //if the character at the third position is negative then the Coef is negative and the multiplier for Coef is negative 
    if(temp[start] == '-'){
        num_at_multy = -1;
        start++;  //increment once to get to the number part
    }
    //loop until we dont see a number or . for decimal spots
    for(long unsigned int i = start; i < temp.length();i++){
        if(isdigit(temp[i]) or temp[i] == '.'){
            length++;   //each time we see a number add one or a decimal spot to the length 
        }
        else{
            break;      //once it's not a number nor a decimal spot stop looping
        }
    }
    num_at = stod(temp.substr(start,length));   //use substr to get the exact number as a string and use stod to convert that number to a double and store at num_at
    num_at *= num_at_multy;                     //use the num_at_multy in case it is negative if it was negative earlier will multiply by -1 if not will just multiply by 1 
    o >> temp;                                  //input from the stream again as the next input will just be '=' so we can discard this
    
    //set the Coef and Exp multipliers 
    int Exp_multy =1; 
    int Coef_multy =1; 
    
    //reset start and length variables 
    start = 0;
    length = 0;
    int place_holder = 0;  //place holder to see where we left off while reading through the string 
    
    bool first = true;    //since the sign of the first function has no space between it and the function the first pass will be a little different then the other ones
   
    while(o >> temp){    //while there is something in the string stream will contunie looping
        //new node created that will be added to the list
        Node *n = new Node; 
        
        //reset all the variables at the beginning of the loop 
        Exp_multy =1; 
        start = 0;
        length = 0;
        place_holder = 0; 
        
        //on the first pass if the first thing we see is a '-' we set Coef_multy to be -1 and increment once to get to the number part
        if(first){
            if(temp[start] == '-'){
                Coef_multy = -1;
                start ++; 
            }
        }
        //if we see '-' or '+' on the second pass means that only one character was read inside form the string stream
        else{
            if(temp[0] == '-'){     //if that one character is negative we set the multiplier to be negative 
                Coef_multy = -1;
                continue;
            }
            if(temp[0] == '+'){     //if that one character is positive then the multiplier is positive 
                Coef_multy = 1;
                continue;           //since we only have one char in temp we want to continue so that the number part of the function can be read in
            }
        
        }

        //if the first character that was read in is a digit then there is a coeficient that we need to read in
        if(isdigit(temp[start])){
            //go until we see something other than a number
            for(long unsigned int i = start; i < temp.length(); i++){ 
                if(isdigit(temp[i]) or temp[i] == '.'){
                    length++;                                 //increment length to see how long the number is
                }
                else{
                    place_holder = static_cast<int>(i);        //record where the last char we read is at
                    break; 
                }
            }

            //use substr and stod to record the Coef as a double and from earlier Coef_multy to multiply it by a negative or a positive 
            Coef = stod(temp.substr(start,length));          
            Coef *= Coef_multy;
            
            //if place holder is which means the function we read in is only one character long or there is no x
            if(place_holder == 0){
                place_holder = -1;   //set place_holder to -1 so that later we know what the Exp should be if there is no x or if it's one character long
            }
            //set the start to where we last left off and increment once so that we are looking at the next character that we haven't looked at yet 
            start = place_holder;
            start++;
        }
        //if it was not a digit then we set Coef to 1 as if it's not a digit it must be 'x' meaning Coef has to equal one
        else{
            Coef = 1;
            start++; 
        }

        //if start is less than length there are still characters ahead meaning that there is an exponent, if place_holder is -1 as seen as we assigned earlier there is no exponent
        //as Place_holder will only be -1 if there is no x meaning no exponent is possible or if it is one character long which also means that there is no exponent
        if(start < static_cast<int>(temp.length()) and start +1 < static_cast<int>(temp.length()) and place_holder != -1){
            start++;               //increment start once sense temp[start] is at the '^' character right now
            if(temp[start] == '-'){       //if there is a negative sign before the numbers set the multiplier to a negative number and increment once 
                Exp_multy = -1;
                start++; 
            }
            //since we know that all that is left in temp is the exponent, we can use the properties of substr and just give it where the number starts
            //and the total length of the string, this works because substr will not give out an error if you put in a length bigger than the string in
            //it will just go to the end of the string. After we convert it to an int using stoi and multiply it my Exp_multy which will turn it negative if need be 
            Exp = stoi(temp.substr(start,temp.length())); 
            Exp *= Exp_multy; 
        }
        //if the start is not less than length which means we are at the end of temp and there is no exponent 
        else{
            if(temp[start -1] == 'x'){  //if there's an x the exp should be 1
                Exp = 1; 
            }
            else{                       //if theres no x the exp should be 0 
                Exp = 0; 
            }
            
        }
        
        if(Coef != 0){                 //if Coef is not zero we will add it to our list
            
            //set the coef and exp to the node created in the beginning of the loop 
            n->setCoef(Coef); 
            n->setExp(Exp);
            //add it using the overloaded operator 
            L += n; 
        }
        //after first loop will turn false 
        first = false;
    } 
    L.setFindAt(num_at);  //set the num_at which we are evaluating the polynomial at in the linked list class
}
            
int main()
{   
    LinkedList nums;            //creating the linked list to store all the numbers
    ifstream file;              //declaring a file stream to read from
    
    //getting and opening the file_name 
    string file_name;
    cin >> file_name;
    file.open(file_name); 

    string line;                                //variable to store each line
    if(file){ 
        cout << fixed << setprecision(3);       //set precision to 3 decimal points
        while(getline(file, line)){
            if(line == ""){                     //if get line gets nothing the loop will end a pre-caution as get line look at where the newline ends so it can read in an empty string
                break; 
            }
            
            getInfo(line,nums);                 //function will parse the line for the input and put it inside of the linked list 

            nums.sortList();                    //will sort the modules inside the linked list
            nums.calcTotal();                   //will calculate the total inside the linked list class

            cout << nums << " = " << nums.getTotal() << endl;          //print out the nums using the <<overloaded operator and Total accesesor 
            nums.purge();                                              //after printed delete each node in the list and set head to nullptr
            
        } 
    }
    else{
        std::cout << "could not open file";                                 //if the file does not open this will print letting the user know that the file did not open
    }
}
