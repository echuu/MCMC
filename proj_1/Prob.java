/**
 * Prob.java
 * helper functions to design the probability distribution
 * and find valid paths
 * Author: Eric Chuu
 */


import java.util.*;

public class Prob {

	private static final int UP    = 0;
	private static final int DOWN  = 1;
	private static final int RIGHT = 2;
	private static final int LEFT  = 3;

	static int LONGEST_PATH = 0;

	public void callProbFunc() {

		System.out.println("callProbFunc() function");
	}

	/**
	 * design the probability used for monte carlo integration
	 * simulate a complete SAW
	 * keep track of path length
	 * return G: product of k_j's, the inverse of g()
	 */
	public double inv_g(int[][] grid) {

		double G = 1;
		int r, c;
		int move;
		int k_j = 1;
		int p;
		int path_length = 0;
		
		r = 0; // start at lower left corner
		c = 0;

		grid[r][c]++;
		ArrayList<Integer> validMoves = new ArrayList<Integer>();

		// while path satisfies SAW condition
		while(true) {

			// find valid moves
			findValidMoves(r, c, grid, validMoves);
			
			// randomly determine next move from valid moves
			k_j = validMoves.size(); // can be zero, check when re-enter

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
				default:     System.out.println("Error -- no move made");
						     break;
			} // end switch

			// update grid: mark new position as visited
			grid[r][c]++;
			path_length++;

			// running product of k_j's, 
			// k_j = # of possible paths at each point
			G = G * k_j;

		} // end while()


		if (path_length > LONGEST_PATH) {
			LONGEST_PATH = path_length;
		}

		return G; // g = 1/G, used in MC integration

	} // end inv_g() function


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
										ArrayList<Integer> validMoves) {

		int dim = grid.length;

		validMoves.clear();

		//ArrayList<Integer> validMoves = new ArrayList<Integer>();

		// determine possible paths: check bdy, check for visited
		if (((r + 1) < dim) && (grid[r+1][c] == 0)) {    		// look up
			validMoves.add(UP);    // add UP to potential moves
		}
		if ((r > 0) && (grid[r-1][c] == 0)) {       		    // look down
			validMoves.add(DOWN);  // add DOWN to potential moves
		}
		if (((c + 1) < dim) && (grid[r][c+1] == 0)) {			// look right
			validMoves.add(RIGHT); // add RIGHT to potential moves
		}
		if ((c > 0) && (grid[r][c-1] == 0)) {					// look left
			validMoves.add(LEFT);  // add LEFT to potential moves
		} 

		return validMoves;
	} // end findValidMoves() function




}