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
	private static final int STOP  = -1;

	static int LONGEST_PATH = 0;

	static ArrayList<Integer> path_r; // store row values of path
	static ArrayList<Integer> path_c; // store col values of path

	public Prob() {
		path_r = new ArrayList<Integer>();
		path_c = new ArrayList<Integer>();
	}


	/**
	 * 3rd design for distribution of SAWs
	 * Favor long walks
	 * for any walk longer than 50, generate u = 5 more children
	 * reweigh each of these children by w0 = w / u
	 */
	public double inv_g3(int[][] grid, int num_child) {

		//System.out.println("inside 3rd design");

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

				/*
				if (path_length > 50) {
					// generate u = 5 children
					double k_star = 1 / 5 * this.childSAW(grid, 5);
					G = G / k_j * k_star;
				}
				*/
				/*
				if (r == (grid.length-1) && c == (grid.length-1)) {
					G = 0;
				}
				*/
				break;
			}

			p     = new Random().nextInt(k_j);
			move  = validMoves.get(p);

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

			if (path_length > 50) {
				double k_star = 0;
				for (int i = 0; i < num_child; i++) {
					k_star += this.childSAW(grid, path_length,
									r, c, curr_path_r, curr_path_c);
				}

				k_star = 1 / num_child * k_star; // average of the child results
				G = G / k_j * k_star;	
				break;
			}

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
	}


	public int childSAW(int grid[][], int p_len,
					int r, int c,
					ArrayList<Integer> path_r, ArrayList<Integer> path_c) {

		int k_j = 1;

		int G_hat = 1;

		int child_grid[][] = grid;
		int child_plen = p_len;
		int p;
		int move;
		
		// store paths of this iteration
		ArrayList<Integer> ch_path_r = path_r;
		ArrayList<Integer> ch_path_c = path_c;

		ArrayList<Integer> childValidMoves = new ArrayList<Integer>();

		while (true) {
			findValidMoves(r, c, grid, childValidMoves);
			k_j = childValidMoves.size();

			if (k_j == 0) {
				break;
			}

			p     = new Random().nextInt(k_j);
			move  = childValidMoves.get(p);

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

			// update child path
			child_grid[r][c]++;
			child_plen++;
			ch_path_r.add(r);
			ch_path_c.add(c);
			// finish updateing child path

			G_hat = G_hat * k_j;
		}
		

		if (child_plen > LONGEST_PATH) {
			path_r = ch_path_r;
			path_c = ch_path_c;
			this.LONGEST_PATH = child_plen;
		}


		return G_hat; 
	}


	/**
	 * different design for probability distribution of SAWs
	 * eps = probability of stopping at each step
	 * return inverse of g, which is the weight summed at each
	 * iteration of SMC
	 */
	public double inv_g2(int[][] grid, double eps) {

		double G = 1;
		int r, c;
		int move;
		int k_j = 1;
		int p;
		int path_length = 0;

		int premature_stop = 0;

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

				if ((r != (grid.length-1)) && (c != (grid.length-1))) {
					G = 0;
				}
				
				break;
			} 
			
			// probability of early termination = 0.1
			boolean terminate = new Random().nextInt(10) == 0;
			if (terminate == true) {
				move = STOP;
			} else {
				p    = new Random().nextInt(k_j);
				move = validMoves.get(p);
			}

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
				case STOP:   premature_stop++;
							 break;
				default:     System.out.println("Error -- no move made");
						     break;
			} // end switch


			if (premature_stop == 1) {
				G = G * eps;
				break; // terminate SAW
			}


			// update grid, path: mark new position as visited
			grid[r][c]++;
			path_length++;
			curr_path_r.add(r);
			curr_path_c.add(c);	
			// finished updating path
			
			// running product of k_j's, 
			// k_j = # of possible paths at each point
			G = G * k_j / (1 - eps);

		} // end while()


		// update longest path
		if ((path_length > LONGEST_PATH) && (r == (grid.length-1) &&
											 c == (grid.length-1))) {
			path_r = curr_path_r;
			path_c = curr_path_c;
			LONGEST_PATH = path_length;
		}

		return G; // g = 1/G, used in MC integration
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
					
				if ((r != (grid.length-1)) && (c != (grid.length-1))) {
					G = 0;
				}

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
		if ((path_length > LONGEST_PATH) && (r == (grid.length-1) &&
											 c == (grid.length-1))) {
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

	public static void main(String[] args) {
		System.out.println("Updating Prob.java");
	}

}