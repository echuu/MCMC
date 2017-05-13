
library(ggplot2)


### gamma distribution
f = function(x) {
    return(0.5 * x^2 * exp(-x))
}

reps = 50000;

chain = c(3);
for (i in 1:reps) {
    proposal = runif(1, min = chain[i] - 1, max = chain[i] + 1); ## propose y
    
    if (proposal < 0) {
        proposal = chain[i]; ## stay at x
    }
    
    met_ratio = f(proposal) / f(chain[i]); # metropolis ratio
    
    h = min(1, met_ratio); ## acceptance probability
    
    if (runif(1, min = 0, max = 1) < h) {
        chain[i+1] = proposal;
    } else {
        chain[i+1] = chain[i];
    }
}

# plot results 
plot(density(chain[1000:50000]))    # density
plot(chain[1000:50000], type = "l") # markov chain

hist(chain[1000:50000])             # histogram

chain_d = data.frame(chain)
ggplot(chain_d, aes(chain)) + geom_histogram(binwidth = 0.05) + theme_bw()


