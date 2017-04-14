/**
 * PROJECT 1:  Importance Sampling and Sequential Monte Carlo
 * STATS 202C: MONTE CARLO METHODS FOR OPTIMIZATION
 * Author:     Eric Chuu
 */

import java.util.*;

public class SMC {

	private int UP    = 0;
	private int DOWN  = 1;
	private int RIGHT = 2;
	private int LEFT  = 3;

	public static void p1() {

		System.out.println("Problem 1 on Homework 1");

	}


	public static void SAW(int n) {

		int[][] grid = new int[n+1][n+1];

		for (int r = 0; r < n+1; r++) {
			for (int c = 0; c < n+1; c++) {
				System.out.print(grid[r][c] + " ");
			}
			System.out.println();
		}


	}

	/**
	 * design the probability used for monte carlo integration
	 * simulate a complete SAW
	 * keep track of path length
	 * return G: product of k_j's, the inverse of g()
	 */
	public static int inv_g(int[][] grid) {

		double G = 1;
		int r, c;
		int move;
		double k_j = 1;
		double p;
		int path_length = 0;
		
		r = 0; // start at lower left corner
		c = 0;

		grid[r][c]++;
		ArrayList<Integer> validMoves;

		// while path satisfies SAW condition
		while(1) {

			// find valid moves
			findValidMoves(r, c, grid, validMoves);
			
			// randomly determine next move from valid moves
			k_j = validMoves.size(); // can be zero, check when reenter

			if (k_j == 0) {
				break;
			}

			p          = new Random().nextInt(k_j);
			move       = validMoves.get(p);

			// make move
			switch(move) {
				case UP:     r++;
						     break;
				case DOWN:   r--;
						     break;
				case RIGHT:  c++;
						     break;
				case LEFT:   c--;
						     break;
				default:     // no valid moves -- k_j = 1;
						     break;
			} // end switch

			// update grid: mark new position as visited
			grid[r][c]++;
			path_length++;

			// running product of k_j's, 
			// k_j = # of possible paths at each point
			G = G * k_j;

		} // end while()

		return G; // g = 1/G, used in MC integration
		
	} // end g() function

	

	/**
	 * Advance to the next valid point in SAW
	 * current position (r,c)
	 * length of path so far: i
	 * grid: contains visited points, to update
	 * path: store the path the SAW takes 
	 * return the number of potential paths: k_j
	 */
	public static ArrayList<Integer> findValidMoves(int r, int c, 
														int[][] grid,
														int[][] validMoves) {

		int dim = grid.length;

		validMoves.clear();

		//ArrayList<Integer> validMoves = new ArrayList<Integer>();

		// determine possible paths: check bdy, check for visited
		if (((r + 1) < grid) && !(grid[r+1][c]) {    		// look up
			validMoves.add(UP); // add UP to potential moves
		}
		if ((r > 0) && !grid[r-1][c]) {       		        // look down
			validMoves.add(DOWN); // add DOWN to potential moves
		}
		if (((c + 1) < grid) && !grid[r][c+1]) {			// look right
			validMoves.add(RIGHT); // add RIGHT to potential moves
		}
		if ((c > 0) && !grid[r][c-1]){						// look left
			validMoves.add(LEFT); // add LEFT to potential moves
		} 

		return validMoves;
	}


	/**
	 * monte carlo integration
	 * used to appproximate the number of SAWs
	 */
	public double mcIntegrate(int M) {

		double sum = 0;
		int moves = {0, 1, 2, 3, 4}


	 	for (int i = 0; i < M; i++) {
	 		// accummulate 1 / g(x_i)
	 	}

	 	return sum / M;
	}


	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		int[] moves = {0, 0, 0, 0};

		prob(moves);

		for (int i = 0; i < moves.length; i++) {
			System.out.println("Move " + (i+1) + ": " + moves[i]);
		}

	}
}