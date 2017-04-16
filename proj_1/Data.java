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
//import java.lang.*;

public class Data {



	/** 
	 * given input arry of ints, write to csv file
	 * data written row-by-row
	 */
	public void writeData(double[] a, String name) {
	    try {
			String f_name = name + ".csv";
	    	FileWriter data = new FileWriter(f_name);
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

		if (1 == 0) {
			System.out.println("Test write to csv");

			Data d = new Data();

			double[] arr = new double[10];

			for (int i = 0; i < 10; i++) {
				// int p = ;
				arr[i] = new Random().nextInt(10) + 1;
				System.out.print(arr[i] + " ");
			}
			System.out.println();

			d.writeData(arr, "data");

			System.out.println("Wrote array to file");
		}

		int[] num_samples = new int[24];

		for (int n = 1; n <= 24; n++) {
			double power = 0.3 * n;
			int result = (int) Math.floor(Math.pow(10, power));

			num_samples[n-1] = result;
		}

		for (int n = 0; n < 24; n++) {
			System.out.println(num_samples[n]);
		}



	}
}