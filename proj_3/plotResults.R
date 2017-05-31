# plotResults.R
# Project 3 Results


library(reshape2)
library(ggplot2)
library(dplyr)

betas = c(0.65, 0.75, 0.85, "1.0");
pref = "beta_";

beta_plots = list();
for (i in 1:length(betas)) {
    q_i          = read.csv(paste(pref, betas[i], ".csv", sep = ""));
    qi_long      = melt(q_i, id = "iter");
    chain_length = dim(q_i)[1];
    h            = round(mean(q_i$mc1[chain_length], q_i$mc2[chain_length]), 3)
    
    
    p_i = ggplot(qi_long, aes(x = iter, y = value, colour = variable)) + 
        geom_line() + 
        labs(x = "iteration", y = "H(X)", 
             title = paste("Beta =", betas[i], ",", "H(X) =", h)) +
        scale_x_continuous(breaks = 1:chain_length) + theme_bw()
    beta_plots[[i]] = p_i
}
