/**
 * PROJECT 1:  Importance Sampling and Sequential Monte Carlo
 * STATS 202C: MONTE CARLO METHODS FOR OPTIMIZATION
 * Author:     Eric Chuu
 */

import java.util.*;

public class SMC {

	static Prob p;
	static Data d;

	public SMC() {
		p = new Prob();
		d = new Data();
	}

	/*
	 * returns the result of ONE call to g_inv()
	 * called each time to simulate SAW
	 */
	public static double SAW(int n) {

		int[][] grid = new int[n+1][n+1];
		double g_inverse = p.inv_g(grid);

		//displayGrid(grid);

		return g_inverse;
	} // end SAW() function

	/**
	 * monte carlo integration
	 * used to appproximate the number of SAWs
	 */
	public double mcIntegrate(int M, int dim) {

		double sum       = 0; // # of longest paths
		double saw_i;

		// each iteration will call spawn new grid and call inv_g() 
	 	for (int i = 0; i < M; i++) {
	 		// accummulate 1 / g(x_i) <=> accummulate G(x_i)
	 		// G(x_i) is returned by calling inv_g
	 		saw_i = SAW(dim);
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


	public int[] getSampleSize(int n, double growth_rate) {
		int[] num_samples = new int[n];

		for (int i = 1; i <= 24; i++) {
			double power = growth_rate * i;
			int result = (int) Math.floor(Math.pow(10, power));

			num_samples[i-1] = result;
		}

		return num_samples;
	}

	// display the resuling max path length ~ iter i
	public static void displayPathLenghts(double[] p_len) {
		for (int i = 0; i < p_len.length; i++) {
			System.out.println(p_len[i]);
		}
	}

	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		// sequential MC initialization
		int M        = (int) Math.pow(10, 7);	// iterations of MC integration
		int dim      = 4;    					// dimension of the board
		double omega = 0;
		SMC simulate = new SMC();

		int num_iter       = 24;
		double growth_rate = 0.3;
		double[] p_len     = new double[num_iter]; // path lengths for each iter
		// end MC initialization


		int[] ss_arr = new int[num_iter];
		ss_arr = simulate.getSampleSize(num_iter, growth_rate);

		for (int i = 0; i < num_iter; i++) {
			int samp_size = ss_arr[i];
			// System.out.println(samp_size);
			omega = simulate.mcIntegrate(samp_size, dim);
			p_len[i] = omega;

			System.out.println("iter " + (i+1) + ": " + omega);
		}

		System.out.println("Simulation complete");
		System.out.println("Writing to file");

		simulate.d.writeData(p_len, "path_lengths");

		// simulate.displayPath(simulate.p.path_r, simulate.p.path_c);

	} // end main()
}