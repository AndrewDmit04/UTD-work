public class Platinum extends Customer{
    private int bucks = 0;  //set intial bonus bucks to 0 
    //overloaded constroctors 
    public Platinum(String f, String l, String I, Double s){
        super(f,l,I,s);
    }
    public Platinum(Customer i){
        super(i.getFirst(),i.getLast(),i.getID(),i.getSpent());
    }
    //mutator 
    public void setBonus(Integer buck){
        bucks = buck;
    }
    //accesor
    public int getBonus(){
        return bucks;
    }
    //functions 
    public String getInfo(){    //returns a string of the data inside the object
        return String.format("%s %d",super.getInfo(),bucks);
    }

    
}
