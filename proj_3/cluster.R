# cluster.R

# STATS 202C PROJECT 3: Cluster sampling of the Ising/Potts Model
MAX_SWEEPS = 10000;
n          = 64;     # dimension of lattice
n_vertices = n * n; 
n_edges    = n_vertices - 1;
beta       = c(0.5, 0.65, 0.75);
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

## Cluster Sampling Algorithm:
while (iter < MAX_SWEEPS) {
    
    for (r in c(1:n)) {
        for (c in c(1:n)) {
            

            
            # H(X) --> pi(X) 
            p1 = (beta, n_vertices, h1)
            p2 = (beta, n_vertices, h2)
            
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



