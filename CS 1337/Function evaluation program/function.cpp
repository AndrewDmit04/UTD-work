//AVD210006 Andrew Dmitrievsky
#include <fstream>
#include <iostream>
#include <string>
#include <iomanip>
#include <sstream>
#include "LinkedList.h"

using namespace std;


void getInfo(string line,LinkedList &L){
    //varibles used to calculate what x is in the equation 
    double num_at; 
    double num_at_multy = 1; 
    
    //for the determinening the Coef and Exp of the function
    double Coef; 
    int Exp; 
    
    //intilize a string steam to read from out put the original line fed in the function to it and begin to read of the stream
    stringstream o; 
    o << line; 
    //create a varible temp read in the first thing in the stringstream which should  be "f(number)"
    string temp; 
    o >> temp;
    
    //sinse the temp is "f(numbr)" the first two charecters are "f(" so start = 2 will go to the third charecter where the number should start
    int start = 2;   //start will be used to see where the numebr starts so that substr can read from it 
    int length = 0;  //and length will be used to see how long the number is so that sunbstr can read the numebr accuretly 
    
    //if the charecter at the third position is negative then the Coef is negative and the multiplier for Coef is negative 
    if(temp[start] == '-'){
        num_at_multy = -1;
        start++;  //increment once to get to the number part
    }
    //loop until we dont see a number or . for decimal spots
    for(long unsigned int i = start; i < temp.length();i++){
        if(isdigit(temp[i]) or temp[i] == '.'){
            length++;   //each time we see a number add one or a decimal spot to length 
        }
        else{
            break;      //once its not a numeber nor a decimal spot stop looping
        }
    }
    num_at = stod(temp.substr(start,length));   //use substr to get the exact number as a string and use stod to convert that number to a double and store at num_at
    num_at *= num_at_multy;                     //use the num_at_multy in case that it is negative if it was negative earlier will multiply by -1 if not will just multiply by 1 
    o >> temp;                                  //input from the stream again as the next input will just be '=' so we can discard this
    
    //set the Coef and Exp multiplyers 
    int Exp_multy =1; 
    int Coef_multy =1; 
    
    //reset start and length varibles 
    start = 0;
    length = 0;
    int place_holder = 0;  //place holder to see where we left of while reading through the string 
    
    bool first = true;    //sinse the sign of the first function has no space between it and the function the first pass will be a little diffrent then the other ones
   
    while(o >> temp){    //while there is something in the stringstream will contunie looping
        //new node created that will be added to the list
        Node *n = new Node; 
        
        //reset all the varibles at the begining of the loop 
        Exp_multy =1; 
        start = 0;
        length = 0;
        place_holder = 0; 
        
        //on the first pass if first thing we see is a '-' we set Coef_multy to be -1 and increment once to get to the number part
        if(first){
            if(temp[start] == '-'){
                Coef_multy = -1;
                start ++; 
            }
        }
        //if we see '-' or '+' on the second pass means that only one charecter was read inside form the string stream
        else{
            if(temp[0] == '-'){     //if that one charecter is negative we set the multiplyer to be negative 
                Coef_multy = -1;
                continue;
            }
            if(temp[0] == '+'){     //if that one charecter is positive then the multiplyer is positive 
                Coef_multy = 1;
                continue;           //sinse we only have one char in temp we want to contunie so that the number part of the function can be read in
            }
        
        }

        //if the first char that was read in is a digit then there is a coefivent that we need to read in
        if(isdigit(temp[start])){
            //go until we see something other than a number
            for(long unsigned int i = start; i < temp.length(); i++){ 
                if(isdigit(temp[i]) or temp[i] == '.'){
                    length++;                                 //incremnt length to see how long the numebr is
                }
                else{
                    place_holder = static_cast<int>(i);        //record where the last char we read is at
                    break; 
                }
            }

            //use substr and stod to record the Coef as a double and from earlier Coef_multy to multyply it by a negative or a positive 
            Coef = stod(temp.substr(start,length));          
            Coef *= Coef_multy;
            
            //if place holder is which means the function we read in is only one charecter long or there is no x
            if(place_holder == 0){
                place_holder = -1;   //set place_holder to -1 so that later we know what the Exp should be if theres no x or if its one charecter long
            }
            //set start to where we last left off and incroment once so that we are looking at the next charecter that we havent looked at yet 
            start = place_holder;
            start++;
        }
        //if it was not a digit then we set Coef to 1 as if its not a digit it must be 'x' meaning Coef has to equel one
        else{
            Coef = 1;
            start++; 
        }

        //if start is less than length theres still charecters ahead meaning that theres an exponent, if place_holder is -1 as seen we asigned earlier there is no exponent
        //as Place_holder will only be -1 if theres no x meaning no exponent is possible or if it is one charecter long which also means that theres no exponent
        if(start < static_cast<int>(temp.length()) and start +1 < static_cast<int>(temp.length()) and place_holder != -1){
            start++;               //incremnt start once sense temp[start] is at the '^' charecter right now
            if(temp[start] == '-'){       //if theres a negative sign before the numebrs set the multiplyer to a negative number and incroment once 
                Exp_multy = -1;
                start++; 
            }
            //since we know that all that left in temp is the exponent, we can use of the properties of substr and just give it where the number starts
            //and the total length of the string, this works because substr will not give out an error if you put in a length bigger than the string in
            //it will just go the end of string. And after we convert it to a int using stoi and multyply it my Exp_multy which will turn it negative if need be 
            Exp = stoi(temp.substr(start,temp.length())); 
            Exp *= Exp_multy; 
        }
        //if start is not less than length which means we are at the end of temp and there is no exponent 
        else{
            if(temp[start -1] == 'x'){  //if theres an x the exp should be 1
                Exp = 1; 
            }
            else{                       //if theres no x the exp should be 0 
                Exp = 0; 
            }
            
        }
        
        if(Coef != 0){                 //if Coef is not zero we will add it to our list
            
            //set the coef and exp to the node created in the begining of the loop 
            n->setCoef(Coef); 
            n->setExp(Exp);
            //add it using the overloaded operator 
            L += n; 
        }
        //after first loop will turn false 
        first = false;
    } 
    L.setFindAt(num_at);  //set the num_at which we are evaluating the polynimal at in the linked list class
}
            
int main()
{   
    LinkedList nums;            //creating the linked list to store all the numbers
    ifstream file;              //declaring a file stream to read from
    
    //getting and opening the file_name 
    string file_name;
    cin >> file_name;
    file.open(file_name); 

    string line;                                //varible to store each line
    if(file){ 
        cout << fixed << setprecision(3);       //set precision to 3 decimal points
        while(getline(file, line)){
            if(line == ""){                     //if getline gets nothing the loop will end a pre-caution as getline look at where the newline ends so it can read in a empty string
                break; 
            }
            
            getInfo(line,nums);                 //function will parse the line for the input and put it inside of the linked list 

            nums.sortList();                    //will sort the modules inside the linked list
            nums.calcTotal();                   //will calulate the total inside the linked list class

            cout << nums << " = " << nums.getTotal() << endl;          //print out the nums using the <<overloaded operator and Total accesesor 
            nums.purge();                                              //after printed delete each node in the list and set head to nullptr
            
        } 
    }
    else{
        std::cout << "could not open file";                                 //if the file does not open this will print letting the user know that the file did not open
    }
}
