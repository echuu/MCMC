import java.util.*;
import java.io.IOException;
import java.io.FileReader;
import java.io.Writer;
import java.io.FileWriter;
import java.io.BufferedWriter;

public class Test {


	public static void writeData(int[] a) {
	    try {      

	    		BufferedWriter writer = new BufferedWriter(new FileWriter("data.csv"));
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
	}

	

	public static void main(String[] args) {

		System.out.println("Test write to csv");

		int[] arr = new int[10];

		for (int i = 0; i < 10; i++) {
			int p = new Random().nextInt(10) + 1;
			arr[i] = p;
			System.out.print(arr[i] + " ");
		}
		System.out.println();

		writeData(arr);

		System.out.println("Wrote array to file");


	}
}