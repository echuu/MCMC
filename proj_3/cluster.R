# cluster.R

# STATS 202C PROJECT 3: Cluster sampling of the Ising/Potts Model
MAX_SWEEPS = 10000;
n          = 64;     # dimension of lattice
n_vertices = n * n; 
n_edges    = n_vertices - 1;
betas      = c(0.65, 0.75, 0.85);
beta       = betas[1];
tau        = 0;  # store convergence time


iter     = 0;
converge = FALSE;
mc1      = matrix(1, n, n) # MC1 starts with all sites = 1
mc2      = matrix(0, n, n) # MC2 starts with all sites = 0
mm1      = c();            # mm1 = matrix(0, nSweeps, 1);
mm2      = c();            # mm2 = matrix(0, nSweeps, 1);

mc_results = list();
coalesce   = rep(0, length(beta))
suff_stat  = c();
q         = 1 - exp(-beta);

## Cluster Sampling Algorithm:
while (iter < MAX_SWEEPS) {
    
    for (r in c(1:n)) {
        for (c in c(1:n)) {
            
          
            # calculate H(X) for each markov chain
            e1 = getNeighborSpins(r, c, mc1);
            e2 = getNeighborSpins(r, c, mc2);
            
            h1 = H(r, c, mc1);
            h2 = H(r, c, mc2);
            
            # H(X) --> pi(X) 
            p1 = prob(beta, n_vertices, h1, e1, n);
            p2 = prob(beta, n_vertices, h2, e2, n);
            
            # Step 1: Clustering
            
            
            # Step 2: Flipping
            
            
        } # end inner for loop
      
    } # end outer for loop
    
    # check for convergence
    if (converge == TRUE) {
          tau = iter;
          print(paste("beta =", beta, "convergence:", tau));
          break;
    }
  
    iter = iter + 1;
} # end while loop -- end of algorithm



