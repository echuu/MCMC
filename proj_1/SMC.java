/**
 * PROJECT 1:  Importance Sampling and Sequential Monte Carlo
 * STATS 202C: MONTE CARLO METHODS FOR OPTIMIZATION
 * Author:     Eric Chuu
 */

import java.util.*;

public class SMC {

	static Prob p;
	static Data d;

	static ArrayList<Integer> lp_r; // store row values of longest path
	static ArrayList<Integer> lp_c; // store row values of longest path

	double EPSILON = 0.1;

	public SMC() {
		p = new Prob();
		d = new Data();

		lp_r = new ArrayList<Integer>();
		lp_c = new ArrayList<Integer>();
	}

	/*
	 * returns the result of ONE call to g_inv()
	 * called each time to sim SAW
	 */
	public static double SAW(int n) {
		int[][] grid = new int[n+1][n+1];
		double g_inverse = p.inv_g(grid);
		return g_inverse;
	} // end SAW() function

	/*
	 * returns the result of ONE call to g_inv()
	 * called each time to sim SAW
	 */
	public static double SAW_2(int n, double eps) {
		int[][] grid = new int[n+1][n+1];
		double g_inverse = p.inv_g2(grid, eps);
		return g_inverse;
	} // end SAW() function

	/**
	 * monte carlo integration
	 * used to appproximate the number of SAWs
	 */
	public double mcIntegrate(int M, int dim, int design) {

		double sum = 0; // # of longest paths
		double saw_i;

		// each iteration will call spawn new grid and call inv_g() 
	 	for (int i = 0; i < M; i++) {
	 		// accummulate 1 / g(x_i) <=> accummulate G(x_i)
	 		// G(x_i) is returned by calling inv_g
	 		if (design == 1) {
	 			saw_i = SAW(dim);
	 		} else {
	 			saw_i = SAW_2(dim, this.EPSILON);
	 		}
	 			
	 		sum += saw_i;
	 	}
	 	// System.out.println("Longest path: " + p.LONGEST_PATH);

	 	return sum / M;
	} // end mcIntegrate() function


	// display the grid -- 0 means not visited, 1 means visited
	public static void displayGrid(int[][] grid) {

		for (int r = grid.length-1; r >= 0; r--) {
			for (int c = 0; c < grid.length; c++) {
				System.out.print(grid[r][c] + " ");
			}
			System.out.println();
		}
		System.out.println();
	} // end displayGrid() function


	// display the path saved by simulating the SAW
	public void displayPath(ArrayList<Integer> rows, ArrayList<Integer> cols) {

		int row_offset = rows.size() / 3;

		for (int i = 0; i < rows.size(); i++) {

			System.out.print("(" + rows.get(i) + ", " + cols.get(i) + ") ");
			if (((i+1) % row_offset) == 0) {
				System.out.println();
			}
		}
		System.out.println();
	} // end displayPath() function


	/**
	 * create an array, where each entry is the sample size for that iteration
	 * n = number of iterations
	 * growth_rate = how fast you want the powers of 10 to grow
	 */
	public int[] getSampleSize(int n, double growth_rate) {
		int[] num_samples = new int[n];

		for (int i = 1; i <= n; i++) {
			double power = growth_rate * i;
			int result = (int) Math.floor(Math.pow(10, power));

			num_samples[i-1] = result;
		}

		return num_samples;
	} // end getSampleSize()

	// display the resuling max path length ~ iter i
	public static void displayPathLengths(double[] p_len) {
		for (int i = 0; i < p_len.length; i++) {
			System.out.println(p_len[i]);
		}
	} // end displayPathLengths()


	public void updatePath() {

		if (p.LONGEST_PATH > lp_r.size()) {
			this.lp_r = p.path_r;
			this.lp_c = p.path_c;
		}

	}

	public void storeResults(double[] p_len, ArrayList<Integer> p_rows, 
											 ArrayList<Integer> p_cols,
											 int design) {
		
		int[] row_arr = new int[p_rows.size()];
		int[] col_arr = new int[p_cols.size()];
		String prefix = "";

		// store rows, cols in arrays
		for (int i = 0; i < row_arr.length; i++) {
			row_arr[i] = p_rows.get(i);
			col_arr[i] = p_cols.get(i);
		}

		if (design == 1) {
			prefix = "d1_";
		} else if (design == 2) {
			prefix = "d2_"; 
		}

		d.writeData(p_len,   prefix+"path_lengths"); 	// save path lengths
		d.writeData(row_arr, prefix+"path_rows");		// save path rows
		d.writeData(col_arr, prefix+"path_cols");		// save path cols
	}


	public void design1(int dim, int num_iter, double rate) {

		double[] p_len  = new double[num_iter]; // path lengths for each iter
		int[]    ss_arr = new int[num_iter];
		ss_arr          = this.getSampleSize(num_iter, rate);
		double omega    = 0;

		for (int i = 0; i < num_iter; i++) {
			int samp_size = ss_arr[i];
			// System.out.println(samp_size);
			omega = this.mcIntegrate(samp_size, dim, 1);
			p_len[i] = omega; // store the number of SAWs

			// update path
			this.updatePath();

			System.out.println("iter " + (i+1) + ": " + omega);
		}

		System.out.println("Writing to file");
		this.storeResults(p_len, this.lp_r, this.lp_c, 1);

	}

	public void design2(int dim, int num_iter, double rate, double eps) {

		double[] p_len  = new double[num_iter]; // path lengths for each iter
		int[]    ss_arr = new int[num_iter];
		ss_arr          = this.getSampleSize(num_iter, rate);
		double omega    = 0;

		for (int i = 0; i < num_iter; i++) {
			int samp_size = ss_arr[i];
			// System.out.println(samp_size);
			omega = this.mcIntegrate(samp_size, dim, 2);
			p_len[i] = omega; // store the number of SAWs

			// update path
			this.updatePath();

			System.out.println("iter " + (i+1) + ": " + omega);
		}

		System.out.println("Writing to file");
		this.storeResults(p_len, this.lp_r, this.lp_c, 2);
	}



	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		// SMC initialization
		SMC sim   	   = new SMC();
		int dim        = 10;	    // dimension of the board
		int num_iter   = 38;
		double rate    = 0.2;
		double eps     = 0.1;
		// end SMC initialization


//		System.out.println("Start design 1");
//		sim.design1(dim, num_iter, rate); // 0 -> no stopping criteria


		System.out.println("Start design 2");
		//sim = new SMC(); // clear contents

		sim.design2(dim, num_iter, rate, eps);


	} // end main()
}