/** clusterSampling.c

STATS 202C: PROJECT 3
Cluster Sampling of the Ising/Potts Model

Author: Eric Chuu

**/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

// global delarations
double BETA[8]    = {0.5, 0.65, 0.75, 0.83, 0.84, 0.85, 0.9, 1.0};
int    N          = 6; // dimension of the grid
int    MAX_SWEEPS = 10000;
// end global declarations


/** functions to implement:
	
	--getNeighborSpins: calculate energy at position (r,c)
	updateState: based on random number in [0,1] and conditional probs
	p: calculate the probability, metropolis ratio
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
int* getNeighborSpins(int r, int c, int grid[N][N]) {
	int *energy = malloc(4); // up, down, left, right

	// update row
	if (r == 0) {
		energy[0]   = grid[N-1][c];
		energy[1] = grid[r+1][c];
	} else if (r == N-1) {
		energy[0]   = grid[r-1][c];
		energy[1] = grid[0][c];
	} else {
		energy[0]   = grid[r-1][c];
		energy[1] = grid[r+1][c];
	}

	// update columm
	if (c == 0) {
		energy[2]  = grid[r][N-1];
		energy[3] = grid[r][c+1]; 
	} else if (c == N-1) {
		energy[2]  = grid[r][c-1];
		energy[3] = grid[r][0];
	} else {
		energy[2]  = grid[r][c-1];
		energy[3] = grid[r][c+1];
	}

	return energy;
} // end getNeighborSpins()



int main() {

	int mc1[N][N];
	int mc2[N][N];
	int r, c = 0;
	initializeMC(mc1, 0);
	initializeMC(mc2, 1);
	
	
	for (r = 0; r < N; r++) {
		for (c = 0; c < N; c++) {
			printf("(%d, %d): %d ", r, c, mc2[r][c]);
		}
		printf("\n");
	}
	
	

	printf("STATS 202C: PROJECT 3\n");
} // end main()




