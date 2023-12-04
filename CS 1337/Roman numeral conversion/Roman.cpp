//avd210006 Andrew Dmitrievsky
#include <iostream>
#include<fstream>
#include <string>
using namespace std;



//two realated lists for easy conversions 
const int romans[13] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};                     
const string chars[13] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};

//single valid charecters that a roman numeral can be
const char valid_chars[7] = {'M', 'D', 'C', 'L', 'X','V','I'};

struct Node{
    int num; 
    string roman;
    Node *next; 

};

 
//get_num fucntion will take in a char roman numeral and return the number equvilant. 
int get_num(char roman){
    switch(roman){           //I know better to use the two realated list on top, but I wanted to get some practice using switches 
        case 'I': return 1;
        case 'V': return 5; 
        case 'X': return 10; 
        case 'L': return 50; 
        case 'C': return 100; 
        case 'D': return 500; 
        case 'M': return 1000; 
        default: return 0;
    }
}

//converts a roman numeral to a number
int roman_to_num(string roman){
    int sum = 0; 
    
    
    for(long unsigned int i = 0 ; i < roman.length(); i++){ //loop through the string
        if(get_num(roman[i]) < get_num(roman[i+1])){        //converting a single roman charecter to a number if the next number is more than the first
            sum -= get_num(roman[i]);                       //will subtrack from sum because when its IV 5-1 = 4 
        }
        else{
            sum += get_num(roman[i]);                       //if its not less add to sum
        }
    }
    return sum; 
}

//converts a number to roman
string num_to_roman(int num){
    string roman = "";
    for(int i = 0; i < 13;i ++){        //loop through the related lists   
        while(num / romans[i] != 0){  //while a number can be divided by the numbers in roman list will loop through 
            roman += chars[i];        //adds the char to the string 
            num -= romans[i];         //then subtracks the number from num
        }
    }
    return roman;                     //returns the string with all the charecters added on
    
}

//used to see if a roman character is valid takes a sing char in and return 1 for valid and -1 for invalid 
int valid_roman(char roman){
    for(int i = 0; i < 7; i++){
        if(roman == valid_chars[i] or roman == ' '){
            return 1;
        }
    }

    return -1; 

}
 

//sees if the whole string from the file is valid or not
int valid(string str){
    if(str[0] == ' '){                              //if the first charecter is empty means its a number 
        char tempp = str[17];
        if(str[17] == ' ' or str[17] == '0'){       //sees if the first number is 0 or a space either way return -1 as invalid 
                return -1;
        }
        for(int i = 0; i < 17; i++){                //make sure that each space before the numebr is empty
            if(str[i] != ' '){
                return -1;
            }
        }
        for(int i = 17; i < 21; i++){               //go through the numbers and make sure that they are all valid
            if(!(isdigit(str[i]) or str[i] == ' ')){
                return -1;
            }
        }
    return 0;                                       //if nothing is wrong and all charecters are valid return 0 meaning that the sting is a valid number
    }

    for(int i = 0; i < 17;i++){                     //if first letter not a space then it has to be a roman numeral so loop through and make sure there are no 
        if(valid_roman(str[i]) == -1){              //invalid roman charecters in that sapce 
            return -1; 
        }
    }
    for(int i = 17; i <21;i++){                     //loop through where the numbers should be if something there return -1 
        if(str[i] != ' '){
            return -1; 
        }
    }
    return 1;                                       //if everything is good then return 1 meaning that the line is a valid roman numeral
    
}

//adds things to the linked list 
void add_to_list(Node *&head,int num, string roman){
    Node *S = new Node;       //dynamecally creates the new node 
    
    S->num = num;            //assing both the number and the roman numeral to the node 
    S->roman = roman; 
    
    if(head == nullptr){    //if head is nothing then the new node will become the head 
        head = S;
        return; 
    }
    S->next = head;         //if not the node next will be head and the node will also become head
    head = S;               //the new node become head

}

//recursive function for printing the linked list
void Print_list(Node *head, int choice, fstream &o){
    //stop condition 
    if(head == nullptr){
        return;
    }
    //print out the roman numerals of the linked list
    if(choice == 1){
        cout << head->roman;
        if(head->next != nullptr){
            cout << "\n";
        }
    }
    //print out the numbers of the linked list 
    if(choice ==2){
        cout << head->num << " ";
        if(head->next != nullptr){
            cout << "\n";
        }
    }
    //print both the numbers and the roman numerals to the file of the file stream asignes in the definition of the function
    if(choice ==3){
        int spaces = head->roman.length() -1;          //number of spaces after the roman numeral is outputted 
        o << head->roman;
        for(int i = 0; i < (16 - spaces);i++){         //print those spaces 
            o << ' '; 
        }
        o << head->num;
        
        int num_spaces = to_string(head->num).length();  //number of the spaces after the number 
        
        for(int i = 0; i < 4-num_spaces;i++){           //print the spaces after the number 
            o << ' ';  
        }
        
        if(head->next != nullptr){                      //as long as head->next is not nothing we want to endl
            o << endl;
        }

    }

    Print_list(head->next,choice,o); //will contunie to be called until head is equel to nullptr 
}

//validation function for searching
int rom_or_num(string val){
    if(isdigit(val[0])){                             //if the first charecter is a number
        for(int i = 0; i < val.length(); i++){       //then check all the rest of the input to make sure that they are all numbers 
            if(!isdigit(val[i])){
                return -1; 
            }
        }
        return 0;
    }
    if(valid_roman(val[0]) == 1){                   //if the first charecter is roman numeral 
        for(int i = 0; i < val.length();i++){       //then check all the rest of the input to make sure that they are all roman numerals 
            if(valid_roman(val[i]) == -1){
                return -1; 
            }
        }
        return 1; 
    }

return -1;                                         //if neither is the case then the input is invalid
}

//linear search through the linked list
void search_list(Node *head, string input){
    int flip = rom_or_num(input);                       //used to see if the value is roman numeral or num 
    
    if(flip == -1){                                     //did this before reading that all user input is valid, good programming practice anyway just on case :)
        cout << "invalid input" << endl;                //if input is invalid will say invalid input 
        return;
    } 
    if(flip == 0){                                      //0 means that we are searching for a number 
        while(head != nullptr){
            if(head->num == stoi(input)){               //compare the head num value to what we are searching for 
                cout << input << " found" << endl;      //if it equels then print out and return ending the function
                return;
            }
            head = head->next;                          //if its not found move on to the next node 
        }

    }
    if(flip == 1){                                     //if one were searching for a roman numeral
        while(head != nullptr){
            if(head->roman == input){                  //compare values 
                cout << input << " found" << endl;     // if found print the value and end the function 
                return;
            }
            head = head->next;                        //if dont equel then move on to the next node 
        }
    }
    
    cout << input << " not found" << endl;            //if not found in any nodes 

}

//bubble sort for linked lists 
void sort_list(Node *&head,int choice){
    bool switching = true;
    //all varibles needed to swap and keep track of nodes inside of the linked list 
    Node *temp1_previous = nullptr; 
    Node *temp1 = head; 
    Node *temp2 = temp1->next; 
    Node *temp2_next = temp2->next; 

    //will be used to swap where temp1 is pointing and where temp2 is pointing
    Node *temp_temp;
    
    while(switching){                                 //while there are swaps being made 
        switching = false; 
        while(temp2 != nullptr){
            //if roman numerals are compared
            if(choice == 1){                                 //of choice is == 1 then the user chose to sort by roman numerals
                if(temp2->roman < temp1->roman){             //if temp2 is less than temp1 then they need to be swapped 
                    if(temp1_previous == nullptr){
                        temp2->next = temp1;                 //if we are swapping at the begining of the list its important to make sure that the head always stays at the front of the list 
                        temp1->next = temp2_next;            //so for this specific reason there is a edge case for if temp1 previous is nothing that means the head is being swapped; 
                        head = temp2;                        //if temp1 and temp2 is swapped head is pointing to temp1 and temp2 is the front of the list so we set temp2 to head
                    }
                    else{
                        temp1_previous->next = temp2;        //if we are not swapping the front of list we set the node pointing to temp1 to point to temp2
                        temp2->next = temp1;                 //then we set temp2 to point to temp1 this swaps their positions 
                        temp1->next = temp2_next;            //and then to fully complete the swap we need to point temp1 to where temp2 was pointing to.
                    }
                    temp_temp = temp1;                       //since we just swapped the nodes position in the list, but not the acutal pointers pointing to the nodes
                    temp1 = temp2;                           //we need to make sure we swap the temp1 and temp2 so that temp2 is behind temp1
                    temp2 = temp_temp; 
                    switching = true;                        //will make sure the loop keeps going while switching
                }
            }
            //if were comparing numbers 
            if(choice == 2){                                 
                if(temp2->num < temp1->num){                //the only diffrenace between this code and the code block above is that here we are comparing numeric values instead of roman numerals 
                    if(temp1_previous == nullptr){
                        temp2->next = temp1;
                        temp1->next = temp2_next;
                        head = temp2;  
                    }
                    else{
                        temp1_previous->next = temp2; 
                        temp2->next = temp1;
                        temp1->next = temp2_next;
                    }
                    temp_temp = temp1; 
                    temp1 = temp2; 
                    temp2 = temp_temp; 
                    switching = true; 
                }
            }
            
            //moving the pointers as well as keeping track of everything 
            temp1_previous = temp1;            //keeping track of what is pointing to temp1
            
            //moving both the ponters forward 
            temp1 = temp1->next;                
            temp2 = temp2->next; 
            
            if(temp2 == nullptr){           //the reason this condition is here is if temp2 is nothing which could happen after moving it forward
                temp2_next = nullptr;       
            }
            else{
                temp2_next = temp2->next;  //and we try to acceses temp2->next which is just nothing a bad acceses error will be thrown and the program will crash 
            }


        }
        //after looping through reset all the varibles back to the start 
        temp1_previous = nullptr;  
        temp1 = head; 
        temp2 = temp1->next; 
        temp2_next = temp2->next;  
    } 
}

        
    



int main(){

    string file_name;                       //asking user for the file input; 
    cout << "input a file name:"; 
    cin >> file_name; 

    fstream file;
    file.open(file_name, ios::in | ios::out | ios::binary);  //open file in input in output mode as well is binary so that seekg and seep could be used 
    
    
    string linee;   //itial string where each line from the file will be stored 
    
    
    string roman;  //varible used to store the roman numeral 
    int num;       //varible used to store the arabic numeral 
    
    Node *head = nullptr;  //creating a head pointer for the begining of the linked list 
    
    int start = 0;  //varible used to keep track of where the file pointer is in the file.
    int validity;   //varible used to see if a string from a file is valid or not.

    if(file.is_open() and file.good()){ //if a file is open no error bits are set then the function will start executing 
        while(getline(file,linee)){    //while theres a line to grab from the file will contunie reading a line and putting inside the linee varible
            
            if(linee == ""){ //as getline reads only until the \n it is important to check if the string that is getline gets is valid if it is empty then break
                break; 
            }
            
  
            
            validity = valid(linee); //stores the validity of the string inside a varible for later use
            
            file.seekp(start); //after reading the input the file pointer will be at the end of the line this will bring it back to the begining so that it could be edited


            

            if(validity == 0){                 //if validity returned as 0 means it is a valid number
                file.seekg(start+17);          //go where the number should start
                file >> num;                   
                roman = num_to_roman(num);     //convert num to roman
                if(num > 0 and num < 5000){
                    add_to_list(head,num,roman);        //if the number is valid and its berween 0 and 5000 it will be added to the linked list 
                }
                


            }
            if(validity == 1){               //if validity returned as 1 then it is a valid roman string 
                
                file.seekg(start);           //go to the start of the line 
                file >> roman;               
                num = roman_to_num(roman);   //conversion of a roman numeral to number
                if(num > 0 and num < 5000){
                    add_to_list(head,num,roman);       //if the roman numeral is valid and between 0 and 5000 it will be added to the list
                }

            }
            
            start += 22;             //have to add 22 to the start of the next string because the adding 21 would make the getline read the 
            file.seekg(start);       //\n char and return nothing while 22 goes past that
            
        }
    file.close(); 
    
    //user input for the loop
    int choice = 0;
    int choice2 = 0;  
    string searching_for; 
    
    while(choice != 3){                                  //while the user doesent type 3 it will contunie to prompt the user for input 
        cout << "1. Search\n2. Sort\n3. Exit\n";
        cin >> choice;
        
        //search
        if(choice == 1){
            cout << "what would you like to search for:";    //ask user what to search for 
            cin >> searching_for;                                
            search_list(head,searching_for);                 //input the value and call the function, which has output inside of the function itself 
            
        }
        //sort
        if(choice == 2){
            cout << "1. Sort by Roman numeral" << endl;    //prompt the user how they would like to sort the linked list 
            cout << "2. Sort by Arabic numeral" << endl; 
            cin >> choice2;
            sort_list(head, choice2);                      //call the sort function and print the list after its sorterd 
            Print_list(head, choice2,file); 
            cout << endl; 
            
        }
            
        
    }
    
    //printing list 
    Print_list(head,2,file);

    file.open("numbers.txt", ios::out); //opening output file 

    //printing list to the file 
    Print_list(head,3,file); 
    
    file.close();
    }
    else{
        cout << "file could not be opened" << endl; //will be printed if something went wrong while opening the file 
    }
}

   
   
