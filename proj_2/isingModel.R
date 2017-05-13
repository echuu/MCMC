
# isingModel.R
# sampling the Ising model with coupled Markov Chains


# beta = 1 / Temperature
beta = c(0.5, 0.65, 0.75, 0.83, 0.84, 0.85, 0.9, 1.0); # 8 betas

# dimension of the lattice
n = 4;

# MC1 starts with all sites = 1
lat1 = matrix(1, 4, 4)

# MC2 starts with all sites = 0
lat2 = matrix(0, 4, 4)

# calculate energy at position (r, c) on the lattice
# grid: (n x n) lattice
getNeighborSpins = function(r, c, grid, n) {
    corner = FALSE;
    energy = 0;
    
    # udpate row
    if (r == 1) {           # top row
       UP   = grid[n, c];
       DOWN = grid[r + 1, c]; 
    } else if (r == n) {    # bottom row
        UP = grid[r - 1, c];
        DOWN = grid[1, c];
    } else {
        UP   = grid[r - 1, c];
        DOWN = grid[r + c, c]
    }
    
    # update column
    if (col == 1) {           # left col
        LEFT = grid[r, n];
        RIGHT = grid[r, c + 1];
    } else if (col == n) {    # right col
        LEFT = grid[r, c - 1];
        RIGHT = grid[r, 1];
    } else {
        LEFT = grid[r, c - 1];
        RIGHT = grid[r, c + 1];
    }
    
    energy = UP + DOWN + LEFT + RIGHT;
    return(energy)
}


