#include "LinkedList.h"
#include <iostream>
#include <string>
#include <cmath>
//default constructor sets everything to the default value
LinkedList::LinkedList(){
    head = nullptr; 
    size = 0;
    total = 0; 
}
//overloaded constructor takes a node pointer 
LinkedList::LinkedList(Node* h){
    if(h != nullptr){                                      //check that the pointer passed in is not null to not crash
        size = 0;                                          //set size to zero as its a new list
        Node *n = new Node(h->getCoef(), h->getExp());     //copy the node sinse we want the node to be inside the object and not outside 
        head = n;                                          //and set it to the head of the list 
        size++;                                            //increment the size 
        Node *temp = head;                                 //create a temp varible pointing to head so we can move it around and asign all values of the linked list
        h = h->getNext();
        while(h != nullptr){                               //while theres still nodes in the linked list passed in 
            Node *p = new Node(h->getCoef(), h->getExp()); //create a new node 
            temp->setNext(p);                              //set equel to temp next attaching the node to the list 
            temp = p;                                      //and set temp to that node just attached so the next one can be attached 
            h = h->getNext();                              //go to the next node in the linked list passed in and increment the size by 1 sinse we just added a node
            size++; 
        }
    }
    
}

//mutators
void LinkedList::setFindAt(double n){find_at = n;}
//is the same code as the overloaded constructor as we want to make a copy inside the linekd list class and not outside
void LinkedList::setHead(Node *h){
    if(h != nullptr){
        size = 0;
        Node *n = new Node(h->getCoef(), h->getExp());
        head = n;
        size++;
        Node *temp = head;
        h = h->getNext();
        while(h != nullptr){
            Node *p = new Node(h->getCoef(), h->getExp());
            temp->setNext(p);
            temp = p;
            h = h->getNext();
            size++; 
        }
    }
}

//accesesesors 
double LinkedList::getFindAt()const{return find_at;}
double LinkedList::getTotal()const{return total;}
Node *LinkedList::getHead()const{return head;}
int LinkedList::get_size()const{return size;}

//functions 
void LinkedList::sortList(){
    if(size <= 1){
        return; 
    }
    bool switching = true;
    //all varibles needed to swap and keep track of nodes inside of the linked list 
    Node *temp1_previous = nullptr; 
    Node *temp1 = head; 
    Node *temp2 = temp1->getNext(); 
    Node *temp2_next = temp2->getNext(); 
    //will be used to swap where temp1 is pointing and where temp2 is pointing
    Node *temp_temp;
    
    while(switching){                                 //while there are swaps being made 
        switching = false; 
        while(temp2 != nullptr){
                if(temp2->getExp() > temp1->getExp()){             //if temp2 is less than temp1 then they need to be swapped 
                    if(temp1_previous == nullptr){
                        temp2->setNext(temp1);                 //if we are swapping at the begining of the list its important to make sure that the head always stays at the front of the list 
                        temp1->setNext(temp2_next);            //so for this specific reason there is a edge case for if temp1 previous is nothing that means the head is being swapped; 
                        head = temp2;                        //if temp1 and temp2 is swapped head is pointing to temp1 and temp2 is the front of the list so we set temp2 to head
                    }
                    else{
                        temp1_previous->setNext(temp2);        //if we are not swapping the front of list we set the node pointing to temp1 to point to temp2
                        temp2->setNext(temp1);                 //then we set temp2 to point to temp1 this swaps their positions 
                        temp1->setNext(temp2_next);            //and then to fully complete the swap we need to point temp1 to where temp2 was pointing to.
                    }
                    temp_temp = temp1;                       //since we just swapped the nodes position in the list, but not the acutal pointers pointing to the nodes
                    temp1 = temp2;                           //we need to make sure we swap the temp1 and temp2 so that temp2 is behind temp1
                    temp2 = temp_temp; 
                    switching = true;                        //will make sure the loop keeps going while switching
                }
            //moving the pointers as well as keeping track of everything 
            temp1_previous = temp1;            //keeping track of what is pointing to temp1
            
            //moving both the ponters forward 

            temp1 = temp1->getNext();              
 
            temp2 = temp2->getNext(); 
            
            if(temp2 == nullptr){           //the reason this condition is here is if temp2 is nothing which could happen after moving it forward
                temp2_next = nullptr;       
            }
            else{
                temp2_next = temp2->getNext();  //and we try to acceses temp2->next which is just nothing a bad acceses error will be thrown and the program will crash 
            }
        }
        //after looping through reset all the varibles back to the start 
        temp1_previous = nullptr;  
        temp1 = head; 
        temp2 = temp1->getNext(); 
        temp2_next = temp2->getNext();  
    } 
}
//goes through the list and calculates the total
void LinkedList::calcTotal(){
    Node *temp = head; //temp to loop through the list 
    double sum = 0;   //intial sum is zero 
    while(temp != nullptr){   //while theres nodes to read

        sum += (temp->getCoef() * pow(find_at,temp->getExp())); //keep calculating the sum of each node and adding them together
 
        temp = temp->getNext();                                 //go to the next node 
    }
    total = sum;                  //set the total in the linked list class to what sum calculated
}
//goes through and clears the linked list
void LinkedList::purge(){
    Node* currNode = head;              //sets a node pointer to head
    while (currNode != nullptr) {       //while that pointer is not nothing loop through 
        Node* temp = currNode;          //set a temp pointer to that pointer 
        currNode = currNode->getNext(); //itarate the original pointer 
        // delete temp;                 //delete the pointer and contunie doing that until theres nothing to delete 
    }
    head = nullptr;                     //set head to nullptr and size to zero sinse theres nothing in the list anymore
    size = 0; 
}


Node* const LinkedList::operator[](int n){
    Node *temp;                             
    if(n < size){                   //if the size of the index passed in is less than the size then it is valid if not return NULL 
        temp = head; 
        if(n == 0){                 //if index is 0 return head
            return head; 
        }
        for(int i = 0; i < n; i++){  //if not go forward how ever many times the index is and return to where pointer is pointing to
            temp = temp->getNext(); 
        }
        return temp; 
    }
    return NULL; 
 
}
std::ostream &operator<<(std::ostream &o, LinkedList &l){

    if(l.head == nullptr){                                //if the theres nothing to print return
       return o; 
       }
    Node *dd;                                             //asing a node dd so that we can use it with[] notation
    
    //print out the first function diffrent than the others because the sign has no space inbetween the function. 
    dd = l[0];                                            
    o << dd; 
    
    
    for(int i = 1; i < l.size; i++){      //loop through each node in the linked list
        dd = l[i];
        if(dd->getCoef() == 0){           //if the coeficent is zero then we dont want to print it
           continue; 
         }
        if(dd->getCoef() < 0){            //if the coeficent is negative then we must print a negative sign in the middle of the functions 
            dd->setCoef(dd->getCoef() * -1); //get rid of the negative sign 
            o << " - " << dd;                //print the function with negative sign 
            dd->setCoef(dd->getCoef() * -1); //put the negative sign back
        }
        else{
            o << " + " << dd;               //if its not negative then print a positive sign in the middle
        }
        
        
    }
    return o; 
}
LinkedList &LinkedList::operator+=(Node *h){
    //go through the list and check if thers any exp that are the same 
    Node *ptr = head;                                   
    Node *temp; 
    if(ptr != nullptr){                                        
        while(ptr != nullptr){
            if(ptr->getExp() == h->getExp()){
                ptr->setCoef(ptr->getCoef() + h->getCoef());      //if it finds one with the same exponent wont create a new node but will add to the old one
                return *this;                                     //return the list as theres no need to contunie 
            }
            ptr = ptr->getNext(); 
        }
    }
    
    //creates a new node and adds it to the linked list 
    Node *n = new Node(h->getCoef(), h->getExp());
    if (head == nullptr){                       //if head is nothing it becomes head 
       head = n;
       size = 1; 
    }
    else{
        temp = head;                           //if not will go to the end of the list and add the ndoe 
        while(temp->getNext() != nullptr){
            temp = temp->getNext(); 
        }
        temp->setNext(n);
        size++;                               //increament the size by sinse we just added a node to the linked list 
    }

    return *this;                            //return the list
}


//desctructor
LinkedList::~LinkedList(){
   Node *temp = head;                 //goes through each node and deletes it after done using the list 
   head = nullptr; 
   size = 0;  
   while(temp != nullptr){            //while temp is not nullptr 
       Node *current = temp;          //create a current node and set to temp 
       temp = temp->getNext();        //increament temp
       delete current;                //delete current 
   }
   delete head;                       //after everything also delete head 
}
