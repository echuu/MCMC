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
  set.seed(123)
  result = gibbs(beta[b], n, mm1, mm2, mc1, mc2);
  mc_results[[b]] = result[[1]];
  coalesce[b]   = result[[2]];
}

generatePlots()




