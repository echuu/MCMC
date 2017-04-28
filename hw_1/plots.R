# plots.R
library(ggplot2)

# Question 1 plots
eig_values = read.csv("eigenvalues.csv", stringsAsFactors = FALSE,
                      header = FALSE)

k_mat = c(rep("k0", 5), rep("k50", 5), rep("k200", 5))
eig_values$k_mat = k_mat
names(eig_values) = c("real", "imag", "k_mat")
eig_values


ggplot(eig_values[1:5,], aes(x = real, y = imag, colour = k_mat)) +
  geom_point(size = 5) + xlim(-1, 1) + ylim(-1, 1) + 
  geom_hline(aes(y = 0)) + geom_vline(aes(x = 0))
