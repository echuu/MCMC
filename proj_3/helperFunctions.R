# helperFunctions.R
# a set of functions used in Cluster Sampling process


# sufficient statistic of X
# this is used in convergence analysis, plotted against iteration
H = function(r, c, mc) {
  
    # measures the length of the total boundaries in X
    # normalized by the number of edges
    
    energy = 4 - getNeighborSpins(r, c, mc);
    k      = 2 * n^2;
    
    return(energy / k);
}


## turn edges around (r,c) on/off based on coloring
processEdge = function(r, c, mc) {
    color = mc[r, c];
    
  
  
}



# conditional probability for the model
prob = function(beta, num_vert, h, energy, n) {
    
    p = exp(-2 * num_vert * beat * h);
    Z = p + exp( - 2 * num_vert * beta * (4 - energy) / (2 * n^2));
        
    return(p/Z);
}


