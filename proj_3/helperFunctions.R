# helperFunctions.R
# a set of functions used in Cluster Sampling process


# sufficient statistic of X
# this is used in convergence analysis, plotted against iteration
H = function(r, c) {
  
  # measures the length of the total boundaries in X
  # normalized by the number of edges
  
  energy = 4 - getNeighborSpins(r, c, mc);
  k      = 2 * n^2;
  
  return(energy / k);
}

# conditional probability for the model
prob = function(r, c, n, beta, mc) {
  
    
  
  
}


