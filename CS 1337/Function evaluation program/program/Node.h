#include <string>
#include <iostream>

class Node{
private:
    //varibles
    double Coef; 
    int Exp; 
    Node *Next;
public: 
    //constructors
    Node(); 
    Node(double, int);
    
    //mutators
    void setCoef(double);
    void setExp(int); 
    void setNext(Node*); 
    
    //accesesors
    double getCoef()const; 
    int getExp()const; 
    Node * getNext()const;
    
    //overloaded operators
    friend std::ostream& operator<<(std::ostream&,Node*&);
 
};

