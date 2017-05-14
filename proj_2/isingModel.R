library(ggplot2)

# isingModel.R

# STATS 202C: PROJECT 2
# sampling the Ising model with coupled Markov Chains
multiplot <- function(plots, plotlist=NULL, file, cols=1, layout=NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    #plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
}
# calculate energy at position (r, c) on the lattice
# mc: (n x n) lattice
getNeighborSpins = function(r, c, mc) {
    energy = 0;
    n = dim(mc)[1];
    # udpate row
    if (r == 1) {           # top row
       UP   = mc[n, c];
       DOWN = mc[r+1, c]; 
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
    
    energy = c(UP, DOWN, LEFT, RIGHT);
    return(energy)
}

# probabilities used to calculate the ratio
# i, j represent the the coordinate of the lattice point
# mc is the markov chain for which the probability is being calculated
# beta is the coefficient used to compute the conditional probability
p = function(i, j, beta, mc) {
    energy  = getNeighborSpins(i, j, mc); # vector of neighboring spins
    indFunc = (energy ==  1);
    px      = exp(beta * sum(indFunc));
    Z       = px + exp(beta * sum(!indFunc)); # normalizing constant
    
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

gibbs = function(beta, b, n, mm1, mm2, mc1, mc2) {
    i = 1;
    tau = -1;
    converge = FALSE;
    countdown = 20;
    while (countdown > 0) {
        # each sweep traverses the entire lattice for each MC
        for (j in 0:num_points) {
            # coordinate of the lattice to find energy
            r = floor(j/n) + 1;
            c = j %% n + 1;
            
            p1 = p(c, r, beta[b], mc1); # calculate cond. probs
            p2 = p(c, r, beta[b], mc2);
            
            flips = update(p1, p2);
            mc1[r, c] = flips[1];
            mc2[r, c] = flips[2];
        }
        
        # update magnetic moments for i-th iteration
        #mm1[i,] = sum(mc1);
        #mm2[i,] = sum(mc2);
        mm1 = c(mm1, sum(mc1));
        mm2 = c(mm2, sum(mc2));
        
        if ((converge == FALSE) && (mm1[i] == mm2[i])) {
            tau = i; ## coalesce time reached
            converge = TRUE;
        }
        if (converge == TRUE) {
            countdown = countdown - 1;
        }
        i = i + 1;
        if (i > 40000) {
            break;
        }
    }
    
    # mm_matrix[, b] = rbind(mm1, mm2);
    markov_chains = c(mm1, mm2);
    print(paste("beta =", beta[b], "convergence:", tau));
    return(list(markov_chains, tau));
}

# beta = 1 / Temperature
beta = c(0.5, 0.65, 0.75, 0.83, 0.84, 0.85, 0.9, 1.0); # 8 betas
beta = c(0.5, 0.65, 0.75, 0.77, 0.79);
beta = c(0.5, 0.65, 0.75, 0.83, 0.84, 0.85, 0.86, 0.88, 0.90, 1.0)

# dimension of the lattice
n       = 64;
nSweeps = 120; # of sweeps

sweep_sequence = 1:nSweeps;
num_points     = n * n - 1

### RUN THIS CHUNK EVERY TIME ######################
# MC1 starts with all sites = 1
mc1 = matrix(1, n, n)
# mm1 = matrix(0, nSweeps, 1);
mm1 = c();

# MC2 starts with all sites = 0
mc2 = matrix(0, n, n)
# mm2 = matrix(0, nSweeps, 1);
mm2 = c();
# mm_matrix = matrix(0, nSweeps*2, length(beta))

mc_results = list();
coalesce   = rep(0, length(beta))
#####################################################

for (b in 1:length(beta)) {
    result = gibbs(beta, b, n, mm1, mm2, mc1, mc2);
    mc_results[[b]] = result[[1]];
    coalesce[b]   = result[[2]];
}

p = list()
for (b in 1:length(beta)) {
    moments        = mc_results[[b]];
    chain_length = length(moments) / 2;
    
    results = data.frame(iter = rep(1:chain_length, 2), 
                         mm = moments,
                         mc = c(rep(1, chain_length), rep(2, chain_length)));
    
    title_b = paste("Beta =", beta[b], ",", "time =", coalesce[b]);
    p_b = ggplot(results, aes(x = iter, y = mm, colour = as.factor(mc))) + 
        geom_line() + 
        labs(x = "iterations", y = "Sum of Image", title = title_b, colour = "MC") + 
        theme_bw()

    p[[b]] = p_b;
}


multiplot(p, cols = 3)
multiplot(p[5:8], cols = 2)





