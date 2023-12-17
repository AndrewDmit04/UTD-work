public class Customer{
    protected String first;     //itilize a first name 
    protected String last;      //itilize a last name 
    protected String ID;        //itilize ID
    protected Double spent;     //itilize spent
    //overloaded constructor
    public Customer(String f, String l, String I, Double s){
        first = f;
        last = l;
        ID = I; 
        spent = s;
    }
    //accsesors
    public String getFirst(){
        return first;
    }
    public String getLast(){
        return last;
    }
    public String getID(){
        return ID;
    }
    public Double getSpent(){
        return spent;
    }
    //mutators
    public void setFirst(String n){
        first = n;
    }
    public void setLast(String n){
        last = n;
    }
    public void setID(String n){
        ID = n;
    }
    public void setSpent(Double n){
        spent = n;
    }
    //functions

    public String getInfo(){    //returns the string of the data inside the object
        return String.format("%s %s %s %.2f",ID,first,last,spent); 
    }
    public void printOut(){  //for testing prints out the data
        System.out.println("name: " + first);
        System.out.println("last: " + last);
        System.out.println("ID: " + ID);
        System.out.println("spent: " + spent);
    }
}
