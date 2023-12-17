public class Gold extends Customer{
    private int discount = 5; //disocunt is intialy 5 
    
    //overloaded constructors
    public Gold(String f, String l, String I, Double s){
        super(f,l,I,s);
    }
    public Gold(Customer i){
        super(i.getFirst(),i.getLast(),i.getID(),i.getSpent());
    }
    
    //accessor
    public int getDiscount(){
        return discount;
    }
    
   //mutator
    public void setDiscount(Double s){ //set discount based on amount spent 
        if(s >= 50 && s < 100){
            discount = 5;
        }
        else if(s >= 100 && s < 150){
            discount = 10;
        }
        else if(s >= 150 && s < 200){
            discount = 15; 
        }
        else{
            discount = 15; 
        }
    }
    //functions 
    @Override
    public String getInfo(){ //returns a string of the data inside the object
        return String.format("%s %d%%",super.getInfo(),discount);
    }
    

    
    
}
