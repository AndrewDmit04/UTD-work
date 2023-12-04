#include <string>
#include <iostream>
#include <iomanip>
#include "Node.h"

//constructor sets default values
Node::Node(){
    Coef = 0; 
    Exp = 0; 
    Next = nullptr; 
}
//constructor sets user values
Node::Node(double c, int ex){
    Coef = c; 
    Exp = ex; 
}

//mutators set user values for varibles 
void Node::setCoef(double c){
    Coef = c;
}
void Node::setExp(int c){
    Exp = c; 
}
void Node::setNext(Node* c){
    Next = c; 
}

//accesors return varible names 
double Node::getCoef() const{return Coef;}
int Node::getExp()const{return Exp;}
Node* Node::getNext()const{return Next;}

//overloaded << operator for nodes 
std::ostream &operator<<(std::ostream& o,Node *&n){
    if(n->Exp == 1){                      //if exp equels one do not print the exponent 
        if(n->Coef == 1){                 //if coef is 1 then only print x 
            o << "x";
        }
        else{
            o << n->Coef << "x";         //if not 1 print print the coef
        }
    }
    else if(n->Exp == 0){                //if exp is zero theres no x so just print the Coef 
        o << n->Coef;
    }
    else{                                //else print the exp 
        if(n->Coef == 1){
            o << "x^" << n->Exp;         //if coef 1 dont print coef and just x and the exponent 
        }
        else{
            o << n->Coef << "x^" << n->Exp; //if its not 1 print everything the coef and the exp and the x 
        }
    }
    return o;  //return the stream 
}


