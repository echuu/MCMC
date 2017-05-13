library(mvtnorm)

reps = 20000;
conditional = function(x2, mu1, mu2, sigma1, sigma2, rho) {
    output = rnorm(1, mean = mu1 + (sigma1/sigma2) * rho * (x2 - mu2), 
                   sd = sqrt((1 - rho^2)^2 * sigma1^2));
    return(output);
}

chain1 = c(0);
chain2 = c(0);
rho = 0.25;

for (i in 1:reps) {
    
    chain1[i+1] = conditional(chain2[i], 1, -1, 0.5, 0.35, 0.25);
    chain2[i+1] = conditional(chain1[i+1], -1, 1, 0.35, 0.5, 0.25);
    
}

cov = 0.25 * 0.5 * 0.35;
samples = rmvnorm(10000, mean = c(1, -1), 
                  sigma = matrix(data = c(0.5^2, cov, cov, 0.25^2), 
                                 ncol = 2, nrow = 2));
par(mfrow = c(1,2))
plot(chain1[1000:10000], chain2[1000:10000]) # plot samples
plot(samples[,1], samples[,2]) # plot actual bivariate normal
