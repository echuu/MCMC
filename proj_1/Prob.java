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

	static ArrayList<Integer> path_r; // store row values of path
	static ArrayList<Integer> path_c; // store col values of path

	public Prob() {
		path_r = new ArrayList<Integer>();
		path_c = new ArrayList<Integer>();
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

		// store paths of this iteration
		ArrayList<Integer> curr_path_r = new ArrayList<Integer>();
		ArrayList<Integer> curr_path_c = new ArrayList<Integer>();


		// initialize grid at (0,0): mark as visited, add to path
		r = 0;
		c = 0;
		grid[r][c]++; 
		curr_path_r.add(r);
		curr_path_c.add(c);		
		// end grid initialization

		//displayGrid(grid);
		ArrayList<Integer> validMoves = new ArrayList<Integer>();

		// while path satisfies SAW condition
		while(true) {

			// find valid moves
			findValidMoves(r, c, grid, validMoves);
			
			// randomly determine next move from valid moves
			k_j = validMoves.size(); // can be zero, check when re-enter

			if (k_j == 0) { // no possible moves -- SAW complete
				break;
			}

			p          = new Random().nextInt(k_j);
			move       = validMoves.get(p);

			// make move -- move needs to be saved
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

			// update grid, path: mark new position as visited
			grid[r][c]++;
			path_length++;
			curr_path_r.add(r);
			curr_path_c.add(c);	
			// finished updating path

			// running product of k_j's, 
			// k_j = # of possible paths at each point
			G = G * k_j;

		} // end while()


		// update longest path
		if (path_length > LONGEST_PATH) {
			path_r = curr_path_r;
			path_c = curr_path_c;
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

	public static void displayGrid(int[][] grid) {

		for (int r = grid.length-1; r >= 0; r--) {
			for (int c = 0; c < grid.length; c++) {
				System.out.print(grid[r][c] + " ");
			}
			System.out.println();
		}
		System.out.println();
	}


}