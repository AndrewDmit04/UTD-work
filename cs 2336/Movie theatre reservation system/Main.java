//AVD210006, Andrew Dmitrievky

import java.io.FileInputStream;      //file input Stream for reading files 
import java.io.FileOutputStream;     //file output Stream for outputting files 
import java.io.PrintWriter;          //print writers to write to file 
import java.util.Scanner;            //scanner for reading output 
import java.io.IOException;          //for ioExceptions 

public class Main
{
	public static void main(String[] args) throws IOException {
		Scanner scnr = new Scanner(System.in);                      //itilize scanner for user input
        String file_name = scnr.next();                             //get a file name 
        //String file_name = "text.txt";
		String Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";             //itilize alphabet for printing audotorium
		Auditorium<Seat> audo = new Auditorium<Seat>(file_name);    //itilize Audotorium class will build empty linked list in the needed shape 
		FileInputStream in = new FileInputStream(file_name);        //create a file input stream 
		Scanner fileScanner = new Scanner(in);                      //create a scanner object to read the file 
		Node<Seat> r = audo.getHead();                              //create a row pointer 
		for(int i = 0; i < audo.getRows(); i++){                    //for each row 
		    String temp = fileScanner.nextLine();                   //read the line 
		    Node<Seat> s = r;                                       //set the seat pointer to the current row pointer 
		    for (int j = 0; j < audo.getSeats(); j++){              //for each seat 
		        s.setPay(new Seat(i,Alphabet.charAt(j),temp.charAt(j))); //set the payload of the seat pointer to a new seat object, itilized with current charecter in the string
		        s = s.getNext();                                    //move the seat pointer one forward 
		    }
		    r = r.getDown();                                        //move row pointer one down
		}
        fileScanner.close();                                        //close the file 

		
		int user_row = -1, user_A  = -1, user_C = -1, user_S = -1;  //user input for row, and number of Adult, Child and Senior tickets
		String user_seat = "";                                      //string for the user input for the seat 
		String userInput = "";                                      //string for the user input for menu option 
		
        while(!userInput.equals("2")){                     //while user input doesent equal 2 
            System.out.print("\n1. Reserve Seats\n2. Exit\n");    //print 1out menu
            if(scnr.hasNext()){                                     //if theres a user input     
                userInput = scnr.nextLine();                        //read in the user input
            }
            else{                                                   //if no user input then break 
                break; 
            }
            if(userInput.equals("1")){                              //if user chose one start the booking proccess
                printAudo(audo.getHead(), audo.getRows(), audo.getSeats(), Alphabet);                 //print the audotorium 
                //row number
                while(true){                                        //ask user for the row number validate only break if a row is displayed
                    System.out.print("Enter row: ");                //prompt user for row
                    user_row = scnr.nextInt();                      //take a int input from scanner
                    if(user_row > 0 && user_row <= audo.getRows()){            //if input is above zero and below or equal row size then it is valid
                        break;                                      //break if valid
                    }
                    System.out.println("Invalid");                  //if row is not displayed will print invalid 
                }
                //seat letter
                while(true){                                        //ask user fot the seat validate only seats are displayed are valid
                    System.out.print("Enter Seat: ");               //prompt user for Seat
                    user_seat = scnr.next();                        //take in a string input
                    if(checkSeat(user_seat,audo.getSeats(),Alphabet)){        //checkSeat checks to see if a letter is on the screen
                        break;                                      //break if valid 
                    }
                    System.out.println("Invalid");                  //if it isnt will print invalid 
                }
                //Adult tickets
                while(true){                                        //validates number of adult tickets
                    System.out.print("Enter Number of Adult tickets: ");//prompt user for adult tickets
                    String temp = scnr.next();                        //take in a int
                    try{
                        user_A = Integer.parseInt(temp);              //see if we can convert to a number 
                    }
                    catch(Exception e){                              //if we cant then set user_A to -1
                        user_A = -1;
                    }
                    if(user_A >= 0){                                //if its above zero then we break and its valid
                        break;
                    }
                    System.out.println("invalid");                  //other wise invalid contunie asking for valid input
                }
                //Childen tickets
                while(true){                                        //validates number of Child tickets
                    System.out.print("Enter Number of Child tickets: ");//prompt user for child tickets
                   String temp = scnr.next();                        //take in a int
                    try{
                        user_C = Integer.parseInt(temp);            //chek if we can covert the number to a int 
                    }
                    catch(Exception e){ 
                        user_C = -1;                                //if not set the value to -1
                    }
                    if(user_C >= 0){                                //if above zero break and its valid
                        break;
                    }
                    System.out.println("invalid");                  //print invalid and contunie looping
                }
                //senior tickets
                while(true){                                        //validate number of Senior tickets
                    System.out.print("Enter Number of Senior tickets: ");//prompt user for Senior tickets
                   String temp = scnr.next();                        //take in a int
                    try{
                        user_S = Integer.parseInt(temp);            //try to convert to a number 
                    }
                    catch(Exception e){
                        user_S = -1;                                //if doesent work set the value to -1 
                    }
                    if(user_S >= 0){                                //if above zero break
                        break;
                    }
                    System.out.println("invalid");                  //print invalid and contunie looping
                }
                int seatIndex = Alphabet.indexOf(user_seat);          //get the seat index which the user selected 
                int total = user_A + user_C + user_S;                 //get the total seats the user selcted 
                if(checkAvalible(audo.getHead(),user_row - 1, seatIndex, total )){    //check if the seats are avalible 
                    bookSeats(audo.getHead(), user_row -1, seatIndex, user_A, user_C, user_S);  //book the seats if avalible
                }
                else{
                    bestAvalibileSeats(audo,user_A,user_C,user_S,Alphabet,scnr);  //else find and ask about best seats in audotorium 
                }
                
            

            }
            
        }
        scnr.close();   //close the scnr object which we dont need anymore 
        FileOutputStream out = new FileOutputStream("A1.txt"); //create a fileOutputStream
        PrintWriter printToFile  = new PrintWriter(out);    //create a print writer and set to output stream to output to file
        double A = 0 , C = 0, S = 0;    //while outputting count the number of tickets sold 
        r = audo.getHead();            //set the row to the begining of the audotorium 
        for(int i = 0; i < audo.getRows(); i++){   //go though each row 
            Node<Seat> s = r;                      //set the row 
            for(int j = 0; j < audo.getSeats(); j++){ //go though each letter in the sub array
                printToFile.print(s.getPay().getTicket()); //print the charecter at the pointer to the file 
                if(s.getPay().getTicket() == 'A'){          //if the char is A add 1 to A meaning that its one adult ticket
                    A++; 
                }
                if(s.getPay().getTicket() == 'C'){          //if the char is C add 1 to C meaning that its one child ticket
                    C++;
                }
                if(s.getPay().getTicket() == 'S'){          //if the char is S add 1 to S meaning that its one child ticket
                    S++;
                }
                s = s.getNext();                             //go to the next seat on that row 
            }
            r = r.getDown();                           //go to the next row
            printToFile.print("\n");            //endline each time we move on to another sub list
        }
        printToFile.close();                    //close the printwriter to save what we wrote
        System.out.println("\nTotal Seats: " + audo.getRows() * audo.getSeats());        //display total seats will be the total rows times Seats
        System.out.printf("Total Tickets: %.0f\n",(A+C+S));         //display total tickets sold will be all the Adult plus child plus Senior tickets sold
        System.out.printf("Adult Tickets: %.0f\n", (A));            //dislay adult tickets sold 
        System.out.printf("Child Tickets: %.0f\n", (C));            //d1isplay child tickets sold
        System.out.printf("Senior Tickets: %.0f\n", (S));           //display senior tickets sold 
        System.out.printf("Total Sales: $%.2f\n",(((A) * 10)+((C) * 5) + ((S) * 7.50))); //find the total sales from selling all the tickets
		
		
		
	}
	
    public static void  printAudo(Node<Seat> head,int rows, int seats,String alpha){
	    System.out.println("\t" + alpha.substring(0,seats)); //print out how many seats there are as alphabet letters 
	    Node<Seat> r = head;  //set the begining of the row the head, the begining of the audotorium
	    for(int i = 0; i < rows; i++){         //for each row of the audotorium            
	        Node<Seat> s = r;     //set the seat to the begining of the row 
	        System.out.print((i+1) + "\t"); //print out the row number followed by tab                
	        for(int j = 0; j < seats; j++){     //for each seat                  
                if(s.getPay().getTicket() == '.'){  //check if the seat is empty
                    System.out.print('.');      //if epmpty print '.'
                }
                else{
                    System.out.print('#');      //if not empty then print '#'
                    //System.out.print(s.getPay().getTicket());
                }
                s = s.getNext();       //go to the next seat 
	        }
	        r = r.getDown();       //go to the next row 
	        System.out.println(""); //print a new line for the next row 
	    }
	}
	
	public static boolean checkSeat(String seat, int total_seats, String alpha){   //checks if seat is a valid input 
	    int index = alpha.indexOf(seat);        //sees if the input is apart of the alphabet
	    if(index == -1){                        //if not the input is invalid
	        return false;
	    }
	    return index < total_seats;               //if valid checks to see if the letter index is below the total seats, if so valid
	}
	
	public static boolean checkAvalible(Node<Seat> head, int row, int seat, int total){
	    Node<Seat> p = head;                //set p to the begining of the audotorium 
	    for(int i = 0;  i < row; i++){      //go down to the needed row
            p = p.getDown(); 
	    }
	    for(int i = 0; i < seat; i++){      //go up to the needed seat
	        p = p.getNext(); 
	    }
	    for(int i = 0; i < total; i++){     //loop each time until we reach total
	        if(p == null || p.getPay() == null){ //if p is null or the payLoad is null then the seats are not avalible
	            return false; 
	        }
	        if(p.getPay().getTicket() != '.'){ //if the seat does not equal '.' then the seats are not avalible 
	            return false; 
	        }
	        p = p.getNext();               //go to the next seat in the row 
	    }
	    return true;    // if each seat is empty and we dont hit the end of the list then the seats are avalible 
	}
	
	public static void bookSeats(Node<Seat> head, int row, int seat, int A, int C, int S){
	    Node<Seat> p = head;         //place a pointer at the begining of the audotorium
	    for(int i = 0;  i < row; i++){  //go down to the row 
            p = p.getDown(); 
	    }
	    for(int i = 0; i < seat; i++){  //go to the seat 
	        p = p.getNext(); 
	    }
	    for(int i = 0; i < A; i++){     //for each audlt ticket ordered 
	        p.getPay().setTicket('A'); //set the pointer payload ticket type to A
	        p = p.getNext();            //go to the next seat 
	    }
	    for(int i = 0; i < C; i++){     //for each ticker ordered 
	        p.getPay().setTicket('C');  //set the pointer payload ticket type to C
	        p = p.getNext();             //go to the next sea
	    }
	    for(int i = 0; i < S; i++){     //for each ticker ordered 
	        p.getPay().setTicket('S');//set the pointer payload ticket type to S
	        p = p.getNext();            //go to the next sea
	    }
	}
    public static void bestAvalibileSeats(Auditorium<Seat> audo, int A, int C, int S, String Alhpa,Scanner scnr){
        int total = A + C + S;                  //calcualte the total seats 
        double middleX = audo.getSeats() / 2 ;  //calculate middle of the seats in the audotorium
        double middleY = audo.getRows() / 2;    //calculate middle of the rows in the audotorium 
        double minDist = -1;                   //itilize minDist to -1 
 
        double Dist;                          //itilize dist 

        int minX = -1;                        //itilize minX will keep track of the minimum seat index 
        int minY = -1;                        //itilize minY will keep track of the minimum row index 
        for(int i = 0; i < audo.getRows(); i++){ //for each row 
            for(int j = 0; j < audo.getSeats(); j++){ //for each seat 
                int row =  i;  //set the row equal to i 
                int seat = j;  //set the seat equal to j 
                double t = total;  //set the total equal to t converts to double for calculation 
                if(checkAvalible(audo.getHead(),row,seat, total)){ //check if the seats are avalible 
                    if(minDist == -1){      //if minDist is equal to -1 then asign minDist intial 
                        minDist = Math.sqrt(Math.pow(((seat + (t/ 2)) - middleX), 2) + Math.pow((row - middleY),2)); //calculation follows the formula based of the middle of the of the avalible seats 
                        minX = seat; //set the min seat index 
                        minY = row;  //set the max seat index 
                        continue;    //contunie looking for better seats 
                    }
                    Dist = Math.sqrt(Math.pow(((seat + (t/ 2)) - middleX), 2) + Math.pow((row - middleY),2)); //calculation follows the formula based of the middle of the of the avalible seats 
                    if(Dist < minDist || (Dist <= minDist && Math.abs(middleY - row) < Math.abs(middleY-minY))){ //if the dist calcualted is less thena the current minDist, also if distances are equal then considers the closest row to the middle 
                        minDist = Dist; //change minDist to the new calculated Dist 
                        minX = seat;  //set min seat index 
                        minY = row;   //set min row index 
                    }
                }
            } 
        }
        if(minDist == -1){ //if minDist is -1 then there are no seats avalible 
            System.out.println("No seats are avalible.");
            return;
        }
        if(total == 1){ //if total is 1 then we only want to print one letter 
            System.out.println((minY+ 1) + "" + (Alhpa.charAt(minX))); //print the min row and min letter to the user
        }
        else{ //if the total is above 1 then it will be a range of numbers 
            System.out.println((minY+ 1) + "" + (Alhpa.charAt(minX) + "-" + (minY + 1) + "" + Alhpa.charAt(minX + total -1 ))); //print out the range avalible to the user
        }
        
        System.out.print("Would you like to reserve 'Y' for yes and 'N' for no:");  //prompt user if they would like to book 
        String booking = scnr.next();  //take a string input
        if(booking.equals("Y")){    //if yes then book seats if not yes then go back to main menu
            bookSeats(audo.getHead(), minY, minX,A,C,S); //book the seats 
        }
    }

    
	
	
}
