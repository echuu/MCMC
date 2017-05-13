
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

# energy function
E = function(x) {
    
}


# Some code to illustrate Gibbs sampling of a simple
# Ising model (theta=1).  To demo in class 2/23/99

nscan = 1000 
kk    = 4  # number of rows/columns in region
x     = matrix(-1, kk, kk) # a starting configuration
# Goal, to approximate P[ X_(1,1) = X_(1,2) ]

# The sampler

same <- rep(NA, nscan)  # indicator that first pixels equal
sumx <- rep(NA, nscan)  # sum(x)
for(iscan in 1:nscan)
{
    for(i in 1:kk)
    {
        for(j in 1:kk)
        {
            # figure out the relevant information from neighbors
            # (a slow implementation)
            foo <- 0
            if(i > 1) { 
                foo = foo + x[i-1,j] 
            }
            if(i < kk) { 
                foo = foo + x[i+1,j] 
            }
            if(j > 1) { 
                foo = foo + x[i,j-1] 
            }
            if(j < kk) { 
                foo = foo + x[i,j+1] 
            }
            
            # Update by the simple full conditional
            p <- exp(foo)/(exp(foo) + exp(-foo))
            x[i,j] <- ifelse(runif(1) <= p, +1, -1)
        }
    }
    same[iscan] = ifelse(x[1,1] == x[1,2], 1, 0 )
    sumx[iscan] = sum(x)
    print(iscan)
}
