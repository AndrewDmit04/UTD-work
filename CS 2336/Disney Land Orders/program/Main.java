
//AVD210006 Andrew Dmitrievsky
import java.util.Scanner;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.IOException;
public class Main
{
	public static void main(String[] args) throws IOException{
	    Scanner inputFiles = new Scanner(System.in);                 //declare a system Scanner to read input 
	    System.out.print("Customer file: ");
	    String file1 = inputFiles.next();                            //read in the first file name 
	    System.out.print("Prefferd file: ");
            String file2 = inputFiles.next();                            //read in the second file name 
	    System.out.print("orders file: ");
            Strng file3 = inputFiles.next();                            //read in the third file name 
	    
	    boolean file_opened = true;                                 //declare check if the file opened boolean
////////////////////////////////inputting data from first file/////////////////////////////////////////////////////
        
        FileInputStream in = null;                                  //create a file input stream
        try{                                                        //try to open the file 
    	   in = new FileInputStream(file1);                         //open the file using FileInputStream
    	}
    	catch(Exception m){                                         //if the file doesent open
    	    System.out.println("could not find Customer file");     //print what happend
    	    System.exit(0);                                         //exit the program 
    	}
        Scanner fileScanner = new Scanner(in);                      //put the contents in a scanner object
	    
        Integer Customer_count = 0;                                 //initialize the count of customers to 0 
        while(fileScanner.hasNextLine()){                           //while the line has a new line 
            fileScanner.nextLine();                                 //read the line don't save
            Customer_count++;                                       //increment the count
        }
        Customer customers[] = new Customer[Customer_count];        //create a customer array with size counted 
        in = new FileInputStream(file1);                            //reopen the file 
        fileScanner = new Scanner(in);                              //put the contents in a scanner object
        Scanner parser;                                             //object will be used to parse each line 
        for(int i = 0; i < customers.length; i++){                  //for each line of the file 
            parser = new Scanner(fileScanner.nextLine());           //read a line of the file and put the line itself in a scanner object
            String ID = parser.next();                              //read the ID
            String first = parser.next();                           //read the first name 
            String last = parser.next();                            //read the last name 
            Double spent = parser.nextDouble();                     //read the amount spent 
            customers[i] = new Customer(first,last,ID,spent);       //create a Customer object index is i
        }
///////////////////////////////inputting data from second file/////////////////////////////////////////////////////
    	Integer pre_arr_size = 0;                                   //utilize the Prefereds arr length to 0
    	try{                                                        //try to open the file
    	    in = new FileInputStream(file2);                        //open the second file with prefereds 
            fileScanner = new Scanner(in);                          //put contents in a scanner object 
            while(fileScanner.hasNextLine()){                       //count the number of the lines inside the file 
                fileScanner.nextLine();                             //read a line each time we loop
                pre_arr_size ++;                                    //increment the arr size by 1 
            }
    	}
    	catch (Exception e){                                        //if the file doesn't exist will throw an exception
    	    file_opened = false;                                    //set file_opened to false meaning the file didn't open 
    	}
        Customer preferreds[] = null;                               //initialize the preferred arr to null
        if(file_opened && pre_arr_size != 0){                       //if the file opened and the length inside is not 0 then read contents
            preferreds = new Customer[pre_arr_size];                //Create a preferreds array with the calculated size
            in = new FileInputStream(file2);                        //reopen the file 
            fileScanner = new Scanner(in);                          //put the file contents into a scanner object 
            for(int i = 0; i < preferreds.length; i++){             //loop through each line of the file 
                parser = new Scanner(fileScanner.nextLine());       //put the individual line into a scanner object 
                String ID = parser.next();                          //read the ID
                String first = parser.next();                       //read the first name 
                String last = parser.next();                        //read the last name 
                Double spent = parser.nextDouble();                 //read the amount spent
                String bonus = parser.next();                       //read the bonus
                if(spent >= 200){                                   //if the amount spent is above 200 create a platinum customer
                    Platinum n = new Platinum(first,last,ID,spent); //Create a platinum customer 
                    n.setBonus(Integer.parseInt(bonus));            //convert the bonus bucks to int and set it to the object created 
                    preferreds[i] = n;                              //set the customer created to the i the current index inside the arr
                }
                else{                                               //if it's below 200 then it's a gold customer 
                    Gold n = new Gold(first,last,ID,spent);         //create a gold customer 
                    n.setDiscount(spent);                           //set the discount amount based on the amount spent 
                    preferreds[i] = n;                              //put the object inside the array
                }
            }
        }
///////////////////////////////proccesing orders inside file3 /////////////////////////////////////////////////////
        try{                                                        //try to open the orders file 
            in = new FileInputStream(file3);                        
        }
        catch(Exception b){                                         //if the file does not open
            System.out.println("could not find orders file");       //print out what happend
            System.exit(0);                                         //exit the program
        }
        fileScanner = new Scanner(in);                              //declare a scanner for the file 
        while(fileScanner.hasNextLine()){                           //while the scanner has something to read 
            boolean found = false;                                  //variable to see if we found the ID in the first regular customer array 
            parser = new Scanner(fileScanner.nextLine());           //put the line inside a scanner object to get the data
            String ID = parser.next();                              //get the first number which is the ID of the customer 
            String Size;                                            //initialize a size 
            String type;                                            //initialize a type
            Double area;                                            //initialize a area 
            Integer amount;                                         //initialize a amount
///////////////////////////////REGULAR CUSTOMER PROCCESING /////////////////////////////////////////////////////
            for(Customer i : customers){                            //go through each customer inside the array assign i as individual customers
                if(i.getID().equals(ID)){                           //if the ID we read is equal to the ID inside the customer object
                    found = true;                                   //set found to try as we found our customer 
                    try{                                            //try to read in the data from the file 
                        Size = parser.next();                       //read the size 
                        type = parser.next();                       //read the type 
                        area = parser.nextDouble();                 //read the area 
                        amount = parser.nextInt();                  //read the amount 
                    }
                    catch(Exception e){                             //if there is a data miss match while reading break and do process the order
                        break;
                    }
                    try{                                            //check for an extra field 
                        parser.next();                              //if this is successful then there's an extra field
                        break;                                      //break and don't process the order 
                    }
                    catch(Exception f){                             //if throws an exception then the right number of fields
                        Double spent = calculate_cost(Size, type, area, amount);    //calculate the amount spent
                        if(spent == -1.00){                         //if the amount spent is -1 one of the data fields is invalid 
                            break;                                  //break and don't process the order
                        }
                        Double total = spent + i.getSpent();        //calculate the total the customer has spent
                        if(total >= 50 && total < 200){             //if it's above 50 and below 200 we need to upgrade to gold status
                            Customer newArrs[][] = new Customer[2][]; //create a double array to store the new arrays after reassignment 
                            if(preferreds == null){                 //if preferreds array is not initialized 
                                preferreds = new Customer[0];       //initialize the preferreds array 
                            }
                            newArrs = upgrade(customers,preferreds,ID,total,0); //call the upgrade function which will return two new correct arrays 
                            customers = newArrs[0];                 //set the customer array to the first array returned
                            preferreds = newArrs[1];                //set the preferreds array to the second array returned
                            Gold currentCustomer = (Gold)preferreds[preferreds.length -1]; //create a variable for the new customer added to gold 
                            double dis = (currentCustomer.getDiscount()) / 100.00;  //calculate the discount 
                            spent = spent * (1.00-dis);             //calculate the spent using discount 
                            currentCustomer.setSpent((currentCustomer.getSpent() + spent)); //set the new total for the new gold customer
                        }
                        else if(total >= 200){                      //if total is above 200 upgrade to Platinum customer
                            Customer newArrs[][] = new Customer[2][];   //create a array of the two new arrays 
                            spent = spent * 0.85;                   //give a 15 percent discount
                            total = spent + i.getSpent();           //caltulate the total
                            if(preferreds == null){                 //if the prefferd array is not intilized 
                                preferreds = new Customer[0];       //itilize the preffered array 
                            }
                            newArrs = upgrade(customers,preferreds,ID,total,1); //upgrade regular customer to platinum 
                            customers = newArrs[0];                 //set customer array to the first array returned
                            preferreds = newArrs[1];                //set the Prefferds array to the second array returned 
                            Platinum currentCustomer = (Platinum)preferreds[preferreds.length - 1]; //get the customer just added 
                            currentCustomer.setSpent(total);        //set the total that they have spent
                        }
                        else{                                       //if the customer doesn't get upgraded 
                            i.setSpent(total);                      //just set the total spent 
                        }
                    }
                }
            }
///////////////////////////////PREFFERED CUSTOMER PROCCESING/////////////////////////////////////////////////////
            if(found == false && preferreds != null){               //if the not found in the first array and preferreds utilized 
                int index = 0;                                      //set the index to 0 
                for(Customer i : preferreds){                       //for each preferreds set i to the individual object 
                    if(i.getID().equals(ID)){                       //if the id equals the id inputted 
                        try{                                        //try to read the data
                            Size = parser.next();                   //read the size
                            type = parser.next();                   //read the type 
                            area = parser.nextDouble();             //read the area
                            amount = parser.nextInt();              //read the amount 
                        }
                        catch(Exception g){                         //if something is misread
                            break;                                  //break and don't process the order 
                        }
                        try{                                        //try to read an extra input 
                            parser.next();                          //if this works 
                            break;                                  //then break don't process 
                        }
                        catch(Exception c){                         //if throws an exception then no extra field 
                            Double spent = calculate_cost(Size, type, area, amount);    //calculate the price 
                            if(spent == -1.00){                     //if -1 incorrect field
                                break;                              //break don't process
                            }
                            if(i instanceof Gold){                  //if the i is a instantaneous of gold 
                                Gold curCustomer = (Gold)i;         //create a variable to hold the current i
                                Double discountSpent = curCustomer.getSpent() + (spent * (1.00 - (curCustomer.getDiscount() / 100.0))); //calculate price with current discount 
                                curCustomer.setDiscount(discountSpent); //set the discount based on the total spent with the last discount 
                                if(discountSpent >= 200){           //if the total is above 200 then upgrade to a platinum customer 
                                    preferreds[index] = new Platinum(preferreds[index]);    //change the array to have the Platinum customer at the index instead of Gold 
                                    Platinum cur = (Platinum)preferreds[index]; //get a temp varible to change the instance of the platinum class 
                                    cur.setSpent(cur.getSpent() + (spent * (1.00 - (curCustomer.getDiscount() / 100.0))));  //set the Platinum spent
                                    cur.setBonus(((int)(cur.getSpent() - 200))/5);  //set the bonus of the Platinum
                                }
                                else{ //if not upgrade is needed then 
                                    curCustomer.setSpent((curCustomer.getSpent() + (spent * (1.00 - (curCustomer.getDiscount() / 100.0))))); //set the spent plus the new discount applied
                                }
                            }
                            else{   //if not a gold instance then has to be platinum 
                                Platinum curCustomer = (Platinum)i; //create a platinum i to edit the i 
                                if(spent < curCustomer.getBonus()){ //if the spent is less than bonus 
                                    curCustomer.setBonus(curCustomer.getBonus() - (int)Math.ceil(spent)); //subtract the spent from the bonus 
                                    spent = 0.0;                    //set the spent to 0 
                                }
                                else{
                                    spent -= curCustomer.getBonus(); //if not less than subtract bonus from the spent 
                                    curCustomer.setBonus(0);        //set the bonus to 0
                                }
                                int bonus = (int)(spent / 5);       //calculate the new bonus to be added 
                                curCustomer.setSpent(spent + curCustomer.getSpent());   //set the new spent 
                                curCustomer.setBonus(bonus + curCustomer.getBonus());   //set the new bonus
                            }
                        }
                        
                    }
                    index++; //increment the index 
                }
            }
        }

///////////////////////////////OUTPUTTING FROM ARRAY TO FILE ////////////////////////////////////////////////////
        FileOutputStream outCustomer = new FileOutputStream("customer.dat"); //create a file output steam
        PrintWriter writeC = new PrintWriter(outCustomer);          //create a print writer to write to the file 
        if(customers != null){                                      //if the customer array is not empty
            for(Customer i : customers){                            //for each customer
                writeC.println(i.getInfo());                        //write the data to the file 
            }
        }
        writeC.close();                                             //close the file 

        FileOutputStream outPrefer = new FileOutputStream("preferred.dat"); //create a file output stream
        PrintWriter writeP = new PrintWriter(outPrefer);            //create a print writer to write to the file 
        if(preferreds != null){                                     //if preferreds is not empty
            for(Customer i : preferreds){                           //for each customer 
                if(i instanceof Gold){                              //check if the customer is Gold 
                    Gold cur = (Gold)i;                             //get a temp var as a gold 
                    writeP.println(cur.getInfo());                  //print the info to the file 
                }
                else{
                    Platinum cur = (Platinum)i;                     //create a temp cur for the Platinum customer
                    writeP.println(cur.getInfo());                  //write the data to the file 
                }
            }
        }
        writeP.close();                                             //close the file 

	}
///////////////////////////////FUNCTIONS USED/////////////////////////////////////////////////////
	//arr1 is the cusomer array, arr2 is the prefferds array, des is the mode if 0 upgrade customer to gold if 1 upgrade customer to Platinum
	public static Customer[][] upgrade(Customer arr1[], Customer arr2[], String ID, Double spent, int des){ //upgrade to gold if des = 0 if 1 then upgrade to platinum
	   int index = 0;                                       //initialize a index 
	   for(int i = 0; i < arr1.length; i++){                //go through the customer array 
	       if(arr1[i].getID().equals(ID)){                  //if the ID equals
	           index = i;                                   //then set the index to the current index 
	           break;
	       }
	   }
	   Gold g = new Gold(arr1[index]);                      //create a gold object
	   Platinum p = new Platinum(arr1[index]);              //create a Platinum object 
	   g.setDiscount(spent);                                //set the discount on Gold object 
	   p.setBonus(((int)(spent-200.00))/5);                 //set the bonus bucks on the Platinum object 
	   int arr1Length = arr1.length - 1;                    //set the Customer arr length 
	   int arr2Length = arr2.length + 1;                    //set the the Platinum arr length 
	   Customer newArr1[] = new Customer[arr1Length];       //create the new Customer array
	   Customer newArr2[] = new Customer[arr2Length];       //create the new Platinum array 
	   int addingAt = 0;                                    //create an adding at variable for copying 
	   for(Customer i : arr1){                              //for each customer inside the array
	       if(!i.getID().equals(ID)){                       //if the id doesn't equal the passed in Id
	           newArr1[addingAt] = i;                       //copy it to the new array
	           addingAt++;                                  //increment the adding at 
	       }
	   }
	   addingAt = 0;                                        //reset adding it to 0
	   for(Customer i : arr2){                              //for each customer object inside the array
	       newArr2[addingAt] = i;                           //copy it over to the new array
	       addingAt++;                                      //increment the adding at
	   }
	   if(des == 0){                                        //if the des is 0 then upgrade to gold 
	       newArr2[addingAt] = g;                           //set the end of the preferred array to gold object
	   }
	   else{                                                //else it upgrades the customer to Platinum
	       newArr2[addingAt] = p;                           //set the end of the preferred array to the Platinum object 
	   }
	   Customer arrs[][] = new Customer[2][0];              //create a two dimensional array 
	   arrs[0] = newArr1;                                   //set the first index to arry1 
	   arrs[1] = newArr2;                                   //set the second index to array2 
	   return arrs;                                         //return the two-dimensional array
	
	}
	public static Double calculate_cost(String cupSize, String type, Double sqrin, Integer num){
        Integer OZ = 0;                     //initialize the OZ
        Double diam = 0.0;                  //initialize the diameter
        Double height = 0.0;                //initialize the height
        if (cupSize.equals("S")){           //if the size is S set all cup specifications according to instructions 
            OZ = 12;
            diam = 4.0;
            height = 4.5;
        }
        else if(cupSize.equals("M")){       //if the size is M set all cup specifications according to instructions 
            OZ = 20;
            diam = 4.5;
            height = 5.75;
        }
        else if(cupSize.equals("L")){       //if the size is L set all cup specifications according to instructions 
            OZ = 32;
            diam = 5.5;
            height = 7.0;
        }
        else{                               //if the letter doesn't match anything then return -1 as its invalid data 
            return -1.00; 
        }
        Double cost = 0.0;                  //initialize the cost
        if(type.equals("soda")){            //if the type is soda then set the cost according to the instructions 
            cost = 0.2;
        }
        else if (type.equals("punch")){     //if the type is punch then set the cost according to the instructions 
            cost = 0.15;
        }
        else if (type.equals("tea")){       //if the type is tea then set the cost according to the instructions 
            cost = 0.12;
        }
        else{                               //if the type doesn't match anything then return -1 as its invalid data 
            return -1.00;
        }
        return  ((2.00 * Math.PI * (diam /2f) * height * sqrin) + (OZ * cost)) * num; //calcualte the cost
	}
}
