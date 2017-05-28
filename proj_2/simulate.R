# simulate.R
library(ggplot2)


# intialize constants
beta       = c(0.5, 0.65, 0.75);
beta       = c(0.65);
n          = 64;  # dimension of the lattice
nSweeps    = 120; # of sweeps
num_points = n * n - 1
# end initialize constants

### RUN THIS CHUNK EVERY TIME ######################
mc1 = matrix(1, n, n) # MC1 starts with all sites = 1
mc2 = matrix(0, n, n) # MC2 starts with all sites = 0

mm1 = c(); # mm1 = matrix(0, nSweeps, 1);
mm2 = c(); # mm2 = matrix(0, nSweeps, 1);

mc_results = list();
coalesce   = rep(0, length(beta))
#####################################################

for (b in 1:length(beta)) {
  result = gibbs(beta[b], n, mm1, mm2, mc1, mc2);
  mc_results[[b]] = result[[1]];
  coalesce[b]   = result[[2]];
}

plots = list()
coalesce[coalesce == -1] = "--";


for (b in 1:length(beta)) {
    moments        = mc_results[[b]];
    chain_length   = length(moments) / 2;
    
    results = data.frame(iter = rep(1:chain_length, 2), 
                         mm   = moments,
                         mc   = c(rep(1, chain_length), rep(2, chain_length)));
    
    title_b = paste("Beta =", beta[b], ",", "time =", coalesce[b]);
    p_b = ggplot(results, aes(x = iter, y = mm, colour = as.factor(mc))) + 
      geom_line() + 
      labs(x = "iterations", y = "Sum of Image", title = title_b, colour = "MC") + 
      theme_bw()
    
    plots[[b]] = p_b;
}





## save to file
saveToFile = function() {
    for (b in 1:length(beta)) {
      fname = paste("beta_", beta[b], ".csv", sep = "");
      write.csv(mc_results[[b]], fname);
    }
}
## end save to file


## plotting coalesce times vs. beta
beta_time = data.frame(b = beta[1:8], time = as.numeric(coalesce[1:8]))
ggplot(beta_time, aes(x = b, y = time)) + geom_line() +
  scale_x_continuous(breaks = seq(0.5, 1, 0.02)) + theme_bw() + 
  labs(title = "Coalesce Time for varying values of Beta",
       x = "beta", y = "time") + 
  geom_vline(xintercept=0.84, linetype = "dotted", colour = "red")



