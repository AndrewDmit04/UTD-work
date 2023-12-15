import java.io.FileInputStream;   //include FileInputStream for input for the constructor 
import java.util.Scanner;	      //include Scanner for reading from the FileInputStrream

public class Auditorium<Any> {	  //declare a generic class with type Any 
    private int rows; 			  //utilize number of rows
    private int seats;			  //initialize number of seats 
    private Node<Any> head; 	  //Itilize the head with Node type Any
    
    //costructor
	public Auditorium(String fileName){
        rows = 0; 		//set rows to zero 
        seats = 0;		//set seats to zero 
		try{		    //set a try block for io Exceptions 
		    FileInputStream in = new FileInputStream(fileName); //open the file 
    		Scanner fileScanner = new Scanner(in);  //put the file contents in an input stream     
    	    head = new Node<Any>(); 	//declare the head as a Node type <Any>
    	    Node<Any> begRow = head; 	//will keep track of the beginning of each row 
    	    while(fileScanner.hasNextLine()){   //while the file has lines to read    
    		   Node<Any> rowPoint = begRow;    //set the row pointer to the beginning of the row 
    		   String temp = fileScanner.nextLine();  //read a line from the file 
    		   for(int i = 0; i < temp.length(); i++){  //for each character in the line read 
    		       rowPoint.setNext(new Node<Any>());   //set the next row pointer to a new node 
    		       rowPoint.getNext().setPrev(rowPoint); //set the new nodes prev to the current node
    		       rowPoint = rowPoint.getNext();   //move the pointer one forward 
    		       seats++;          //add one to the seats 
    		   }
    		   begRow.setDown(new Node<Any>());  //after the loop is done set the bottom of the beginning of the row to a new node 
    		   begRow = begRow.getDown();  //set the beginning of the row the new row just declared 
    		   
               rows++;    		//add one to the rows 
    		                                                      
    		}
    		seats = seats / rows;    //divide the total seats by the rows to get the total seats 
            fileScanner.close();     //close the file 
		}
		catch(Exception NullPointerException){
		    System.out.println("something went wrong");  //if something went wrong throw an exception 
		}   
    }
    
    //accessors 
    Node<Any> getHead(){
        return head; 
    }
    Integer getRows(){
        return rows;
    }
    Integer getSeats(){
        return seats; 
    }
}
