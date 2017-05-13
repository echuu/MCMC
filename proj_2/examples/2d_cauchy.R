
# 2d_cauchy.R

reps = 50000
chain = matrix(data = NA, ncol = 2, nrow = reps + 1);
chain[1,] = c(0, 0);


# multivariate cauchy
mvcauchy = function(x, x0 = c(0, 0), gamma = 1) {
    output = (1 / (2* pi)) * (gamma / ((x[1] - x0[1])^2 + 
                                           (x[2] - x0[2])^2 + gamma^2)^1.5);
    return(output)
}

i = 1
for (i in 1:reps) {
    
    proposal = chain[i, ] + runif(2, min = -5, max = 5);
    accept = runif(1) < mvcauchy(proposal) / mvcauchy(chain[i,])
    if (accept == T) {
        chain[i+1,] = proposal; # jump to next state
    } else {
        chain[i+1,] = chain[i,]; # stay
    }
    
}

par(mfrow = c(1,2))
plot(chain[,1], type = "l");
plot(chain[,2], type = "l")

par(mfrow = c(1,1))
plot(chain[,1] ~ chain[,2], type = "l")

plotAuto(chain, thin = 1)
plotAuto(chain, thin = 10)



