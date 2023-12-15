public class Node<Any>{
    private Node<Any> next;   //itilize next 
    private Node<Any> down;   //itilize down 
    private Node<Any> prev;   //itilize prev 
    private Any payload;      //itilize Payload with generic type Any 
    
    //costructor 
    public Node(){
        payload = null;  //itlizes everything to null 
        next = null;
        down = null;
        prev = null;
    }
    
    // Mutators
    public void setNext(Node<Any> n) {
        next = n;
    }
    public void setDown(Node<Any> d) {
        down = d;
    }

    public void setPrev(Node<Any> p) {
        prev = p;
    }

    public void setPay(Any p) {
        payload = p;
    }

    // Accessors
    public Node<Any> getNext() {
        return next;
    }

    public Node<Any> getDown() {
        return down;
    } 

    public Node<Any> getPrevious() {
        return prev;
    }

    public Any getPay() {
        return payload;
    }
    
}
