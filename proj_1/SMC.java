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

		displayGrid(grid);

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
		// 
	 	for (int i = 0; i < M; i++) {
	 		// accummulate 1 / g(x_i) <=> accummulate G(x_i)
	 		// G(x_i) is returned by calling inv_g
	 		saw_i = SAW(dim);
	 		sum += saw_i;
	 	}

	 	return sum / M;
	} // end mcIntegrate() function


	public static void displayGrid(int[][] grid) {

		for (int r = grid.length-1; r >= 0; r--) {
			for (int c = 0; c < grid.length; c++) {
				System.out.print(grid[r][c] + " ");
			}
			System.out.println();
		}
		System.out.println();
	}


	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		int M   = 1;   // iterations of MC integration
		int dim = 3;    // dimension of the board
		double omega = 0;


		SMC simulate = new SMC();
		omega = simulate.mcIntegrate(M, dim);

		System.out.println("Total # of SAWs: " + omega);

	} // end main()
}