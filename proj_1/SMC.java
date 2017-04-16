/**
 * PROJECT 1:  Importance Sampling and Sequential Monte Carlo
 * STATS 202C: MONTE CARLO METHODS FOR OPTIMIZATION
 * Author:     Eric Chuu
 */

import java.util.*;

public class SMC {

	static Prob p;

	public SMC() {
		p = new Prob();
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

	 	System.out.println("Longest path: " + p.LONGEST_PATH);

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


	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		int M   = 10^8;   // iterations of MC integration
		int dim = 4;    // dimension of the board
		double omega = 0;


		SMC simulate = new SMC();
		omega = simulate.mcIntegrate(M, dim);
		// simulate.displayPath(simulate.p.path_r, simulate.p.path_c);

		// # of SAWs for n = 10 (M = 10^7 to 10^8)



	} // end main()
}