/**
 * Data.java
 * Contains some read/write data-related functions
 * Author: Eric Chuu
 */

import java.util.*;
import java.io.IOException;
import java.io.FileReader;
import java.io.Writer;
import java.io.FileWriter;
import java.io.BufferedWriter;

public class Data {



	/** 
	 * given input arry of ints, write to csv file
	 * data written row-by-row
	 */
	public void writeData(int[] a) {
	    try {
	    	FileWriter data = new FileWriter("data.csv");
    		BufferedWriter writer = new BufferedWriter(data);
           	for(int index11 = 0; index11 < a.length; index11++) {
           		writer.write(String.valueOf(a[index11]));
           		//writer.write(",");
               	writer.write("\n");
          	}
          	writer.close();
		}

	    catch(IOException ex){
	         ex.printStackTrace();
	    }
	} // end writeData()

	
	public static void main(String[] args) {

		System.out.println("Test write to csv");

		Data d = new Data();

		int[] arr = new int[10];

		for (int i = 0; i < 10; i++) {
			// int p = ;
			arr[i] = new Random().nextInt(10) + 1;
			System.out.print(arr[i] + " ");
		}
		System.out.println();

		d.writeData(arr);

		System.out.println("Wrote array to file");


	}
}