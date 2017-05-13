
# approximating cauchy distribution using metropolis hastings algorithm

reps = 50000

cauchy = function(x, x0 = 0, gamma = 1) {
    output = 1 / (pi * gamma * (1 + ((x - x0) / gamma)^2));
    return(output);
}

chain = c(0);
for (i in 1:reps) {
    proposal = chain[i] + runif(1, min = -1, max = 1);
    accept = runif(1) < cauchy(proposal)/cauchy(chain[i]);
    chain[i+1] = ifelse(accept == T, proposal, chain[i]);
}

# plot results 
plot(density(chain[1000:50000]), ylim = c(0, 0.4)) 

# plot actual cauchy distribution
den = cauchy(seq(from = -10, to = 10, by = 0.1), x = 0, gamma = 1);
lines(den ~ seq(from = -10, to = 10, by = 0.1, lty = 2))

# diagnostics:

# (0) look at the chain moving through time
plot(chain, type = "l")

# (1) thinning
library(plotMCMC)
plotAuto(chain, thin = 1)
plotAuto(chain, thin = 10)





