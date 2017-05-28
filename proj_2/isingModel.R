# isingModel.R



# STATS 202C: PROJECT 2
# sampling the Ising model with coupled Markov Chains

# calculate energy at position (r, c) on the lattice
# mc: (n x n) lattice
getNeighborSpins = function(r, c, mc) {
    energy = 0;
    n = 64;
    # udpate row
    if (r == 1) {           # top row
       UP   = mc[n, c];
       DOWN = mc[r + 1, c]; 
    } else if (r == n) {    # bottom row
        UP = mc[r - 1, c];
        DOWN = mc[1, c];
    } else {
        UP   = mc[r - 1, c];
        DOWN = mc[r + 1, c]
    }
    
    # update column
    if (c == 1) {           # left col
        LEFT = mc[r, n];
        RIGHT = mc[r, c + 1];
    } else if (c == n) {    # right col
        LEFT = mc[r, c - 1];
        RIGHT = mc[r, 1];
    } else {
        LEFT = mc[r, c - 1];
        RIGHT = mc[r, c + 1];
    }
    
    energy = UP + DOWN + LEFT + RIGHT;
    #if (mc[r,c] == 0) {
    #    energy = 4 - energy;
    #}
    return(4 - energy)
}

# probabilities used to calculate the ratio
# i, j represent the the coordinate of the lattice point
# mc is the markov chain for which the probability is being calculated
# beta is the coefficient used to compute the conditional probability
p = function(i, j, beta, mc) {
    energy  = getNeighborSpins(i, j, mc); # vector of neighboring spins
    px      = exp(beta * energy);
    Z       = px + exp(beta * (4 - energy)); # normalizing constant
    
    return(px / Z);
}

# update the state based on random number in [0,1] and
# conditional probabilities
update = function(p1, p2) {
    u  = runif(1);
    x1 = u <= p1;    # accept or reject flip
    x2 = u <= p2;
    return(c(x1, x2));
}

gibbs = function(b, n, mm1, mm2, mc1, mc2) {
    
    i         =  1;
    tau       = -1;
    converge  = FALSE;
    countdown = 20;
    
    while (countdown > 0) {
        # each sweep traverses the entire lattice for each MC
        tmp1 = 0;
        tmp2 = 0;
        
        for (r in c(1:n)) {
            for (c in c(1:n)) {
                p1 = p(c, r, b, mc1); # calculate cond. probs
                p2 = p(c, r, b, mc2);
                
                flips = update(p1, p2);
                mc1[r, c] = flips[1];
                mc2[r, c] = flips[2];
                
                tmp1 = tmp1 + mc1[r, c];
                tmp2 = tmp2 + mc2[r, c];
            }
        }
        
        # update magnetic moments for i-th iteration
        mm1 = c(mm1, tmp1);
        mm2 = c(mm2, tmp2);
        
        if ((converge == FALSE) && (mm1[i] == mm2[i])) {
            tau = i;          ## coalesce time reached
            converge = TRUE;
        }
        
        if (converge == TRUE) {
            countdown = countdown - 1;
        }
        i = i + 1;

        #if (i %% 1000 == 0) {
        #    print(paste('iter', i));
        #}
    }
    
    markov_chains = c(mm1, mm2);
    print(paste("beta =", b, "convergence:", tau));
    return(list(markov_chains, tau));
}
