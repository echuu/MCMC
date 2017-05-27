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
#include<time.h>


// global delarations
double BETA[3]    = {0.65, 0.75, 0.85};
int    N          = 64;                  // dimension of the grid
int    MAX_SWEEPS = 100000;
int    NUM_POINTS = 64 * 64 - 1;
// end global declarations


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

	int current_state = grid[r][c];

	// update row
	if (r == 0) {
		up    = grid[N-1][c];
		down  = grid[r+1][c];
	} else if (r == N-1) {
		up    = grid[r-1][c];
		down  = grid[0][c];
	} else {
		up    = grid[r-1][c];
		down  = grid[r+1][c];
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
	if (current_state == 0) {
		energy = 4 - energy;
	}
	//printf("Energy = %d\n", energy);
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
	double Z   = p1 + exp(beta * (4 - energy));
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


void displayGrid(int grid[N][N]);

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
	double  p1, p2;		// store conditional probabilities
	int     mm1, mm2;   // magnetic moment for each MC
	int     tau;     	// coalesce time for MCs
	double  runif = 0;  // update using uniform random number inside loop

	int     scale = 2;  // multiplier for chain_length;
	int*    tmp1;		// for storing MCs when resizing chains
	int*    tmp2;

	while (iter < MAX_SWEEPS) {

		mm1 = mm2 = 0;
		
		for (i = 0; i < NUM_POINTS; i++) {

			// runif ~ unif[0,1]
			runif = unif();

			// get coordinates
			r = i / N;
			c = i % N;

			// calculate conditional probabilties
			p1 = condProb(r, c, beta, g1);
			p2 = condProb(r, c, beta, g2);

			//printf("(%d, %d): p1 = %.3f, p2 = %.3f\n", r, c, p1, p2);

			//sleep(1);

			// update states using runif(0,1) and p1, p2
			if (runif <= p1) {
				g1[r][c] = 1;
			} else {
				g1[r][c] = 0;
			}
			if (runif <= p2) {
				//printf("i = %d -- state change\n", i);
				g2[r][c] = 1;
 			} else {
 				g2[r][c] = 0;
 			}

			// accumulate magnetic moment for each state
 			mm1 += g1[r][c];
 			mm2 += g2[r][c];
		} // end for loop (traverse entire grid)


		// check for resize of chain storing magnetic moments
		if (iter == chain_length) {
			printf("resizing markov chains\n");
			tmp1 = realloc(chain1, scale * chain_length * sizeof(int));
			tmp2 = realloc(chain2, scale * chain_length * sizeof(int));
			if (!tmp1 || !tmp2) {
				printf("Failed to allocate memory.\n");
			} else {
				chain1 = tmp1;
				chain2 = tmp2;
				chain_length = scale * chain_length;
				scale++;
			}
		} // end of resize

		
		/*
		if (iter % 1000 == 0) {
			printf("iter = %d, mm1 = %d, mm2 = %d\n", iter, mm1, mm2);	
		}
		*/

		// store magnetic moments for both of the MCs
		// these are plotted over iteration in convergence analysis
		chain1[iter] = mm1;
		chain2[iter] = mm2;

		// check for convergence
		if (mm1 == mm2) {
			converge = true;
			printf("convergence time: %d\n", iter);
			tau      = iter;
			break;
			// implement option to run for longer after convergence
		} // end if

		iter++;

	} // end while

	if (converge == true) {
		printf("Markov Chain converged.\n");
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
			printf("%d ", grid[r][c]);
		}
		printf("\n");
	}

} // end displayGrid()



int main() {

	int mc1[N][N];
	int mc2[N][N];
	int r, c = 0;
	int chain_length = 1000;

	initializeMC(mc1, 1);
	initializeMC(mc2, 0);

	int* chain1 = malloc(chain_length * sizeof(int));
	int* chain2 = malloc(chain_length * sizeof(int));

	double          beta = 0.7;
	int    convergence_t = 0;
	
	srand(time(NULL));
	convergence_t = gibbs(mc1, mc2, beta, chain1, chain2, chain_length);
	
	printf("beta = %.2f, coalesce time = %d\n", beta, convergence_t);

} // end main()
