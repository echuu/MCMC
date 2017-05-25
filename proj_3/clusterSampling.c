/** clusterSampling.c

STATS 202C: PROJECT 3
Cluster Sampling of the Ising/Potts Model

Author: Eric Chuu

**/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>
#include<stdbool.h>
//#include<gsl_rng.h>





// global delarations
double BETA[8]    = {0.5, 0.65, 0.75, 0.83, 0.84, 0.85, 0.9, 1.0};
int    N          = 6; // dimension of the grid
int    MAX_SWEEPS = 10000;
// end global declarations


/** functions to implement:
	
	--getNeighborSpins: calculate energy at position (r,c)
	updateState: based on random number in [0,1] and conditional probs
	--condProb: calculate the probability, metropolis ratio
	gibbs: main function that runs the gibbs sampler

**/





/** intialializeMC()
  * initialize the MC grid with 0s, 1s
**/
void initializeMC(int MC[N][N], int x0) {
	int r, c;
	for (r = 0; r < N; r++) {
		for (c = 0; c < N; c++) {
			MC[r][c] = x0;
		}
	}
} // end intializeMC()





/** getNeighborSpins()
  * look at 4 nearest neighbors of state at (r,c) and sum their spins
**/
int getNeighborSpins(int r, int c, int grid[N][N]) {
	//int *energy = malloc(4); // up, down, left, right
	int energy = 0;
	int up, down, left, right = 0;

	// update row
	if (r == 0) {
		up = grid[N-1][c];
		down = grid[r+1][c];
	} else if (r == N-1) {
		up = grid[r-1][c];
		down = grid[0][c];
	} else {
		up   = grid[r-1][c];
		down = grid[r+1][c];
	}

	// update columm
	if (c == 0) {
		left  = grid[r][N-1];
		right = grid[r][c+1]; 
	} else if (c == N-1) {
		left  = grid[r][c-1];
		right = grid[r][0];
	} else {
		left  = grid[r][c-1];
		right = grid[r][c+1];
	}

	energy = up + down + left + right;
	return energy;
} // end getNeighborSpins()





/**
 * condProb()
 * calculate the conditional probability of turning 1 in the next
 * step based on current position (r, c)
 * and value of beta
 */
double condProb(int r, int c, double beta, int mc[N][N]) {

	int energy = getNeighborSpins(r, c, mc);
	double p1  = exp(beta * energy); 
	double Z   = p1 + exp(beta * (1 - energy));
	double p   = p1 / Z;

	return p;
} // end condProb()


/**
 * unif()
 * generate uniformly distributed random number from [0,1]
 */
double unif() {
    return (double)rand() / (double)RAND_MAX ;
} // end r2()


/**
 * gibbs()
 * gibbs sampler for ising model
 * takes 2 MCs and iterates until convergence of the MCs
 * or until MAX_SWEEPS iterations
 */
int gibbs(int g1[N][N], int g2[N][N], double beta,
		  int* chain1, int* chain2, int chain_length) {

	bool    converge = false;
	int     iter     = 0;
	int     r, c, i;
	double  p1, p2;
	int     mm1, mm2;   // magnetic moment for each MC
	int     tau;     	// coalesce time for MCs
	double  runif = 0;  // update using uniform random number inside loop

	int     scale = 2; // multiplier for chain_length;
	int*    tmp1;
	int*    tmp2;

	mm1 = mm1 = 0;


	while (iter < MAX_SWEEPS) {

		for (i = 0; i < N * N; i++) {

			// runif ~ unif[0,1]
			runif = unif();

			// get coordinates
			r = i / N;
			c = i % N;

			// calculate conditional probabilties
			p1 = condProb(r, c, beta, g1);
			p2 = condProb(r, c, beta, g2);

			// update states using runif(0,1) and p1, p2
			if (runif <= p1) {
				g1[r][c] = 1;
			}
			if (runif <= p2) {
				g2[r][c] = 1;
 			}

			// update magnetic moment for this iteration (sum of grid)
 			mm1 = g1[r][c];
 			mm2 = g2[r][c];

 			
 			if (iter == chain_length) {
 				printf("resizing markov chains\n");
 				tmp1 = realloc(chain1, scale * chain_length * sizeof(int));
 				tmp2 = realloc(chain2, scale * chain_length * sizeof(int));
 				if (!tmp1 || !tmp2) {
 					printf("Failed to allocate memory.\n");
 				} else {
 					chain1 = tmp1;
 					chain2 = tmp2;
 					scale++;
 				}
 				
 			}
 			// store these in each of MCs
 			chain1[iter] = mm1;
			chain2[iter] = mm2;
		}

		// check for convergence
		if (mm1 == mm2) {
			converge = true;
			tau      = iter;
			// implement option to run for longer after convergence
		}

	}

	if (converge == true) {
		return tau;
	} else {
		return -1;
	}

} // end gibbs()



/**
 * displayGrid()
 * display the Markov Chain
 */
void displayGrid(int grid[N][N]) {

	int r, c = 0;
	for (r = 0; r < N; r++) {
		for (c = 0; c < N; c++) {
			printf("(%d, %d): %d ", r, c, grid[r][c]);
		}
		printf("\n");
	}

} // end displayGrid()



int main() {

	int mc1[N][N];
	int mc2[N][N];
	int r, c = 0;
	initializeMC(mc1, 0);
	initializeMC(mc2, 1);

	int* chain1 = malloc(1000 * sizeof(int));
	int* chain2 = malloc(1000 * sizeof(int));

	double beta = 0.7;


	printf("Running Gibbs Sampler\n");

} // end main()




