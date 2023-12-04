#include <string>
#include <iostream>
#include "Node.h"

class LinkedList{
private:
    //varibles used through out the class 
    Node *head;
    int size;
    //used to find total and x
    double total;
    double find_at; 
public:
    //constructors
    LinkedList();
    LinkedList(Node *); 
    
    //mutators
    void setFindAt(double);
    void setHead(Node*);
    
    //accesors 
    double getFindAt()const;
    double getTotal()const;
    Node* getHead()const;
    int get_size()const;
    
    //functions
    void calcTotal(); //calculates total of all the nodes in the list
    void sortList(); //sorts the linked list based on exponents 
    void purge();   //clears the linked list 
    

    //opeverloaded operators 
    Node* const operator[](int); 
    friend std::ostream &operator<<(std::ostream &, LinkedList &);
    LinkedList &operator+=(Node *);
    

    //desctroctor
    ~LinkedList(); 
    
    
};
