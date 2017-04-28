
library(reshape2)
norms = read.csv("norm_results.csv", header = FALSE)
n = 1:dim(norms)[1]
norms$n = n;
names(norms) = c("TV", "KL", "bound_A", "bound_B", "n");
norm_long = melt(norms, id = "n")

ggplot(norm_long, aes(x = n, y = value, 10, colour = variable)) + 
  geom_line() + theme_bw() + theme(legend.position = c(0.9, 0.25)) +
  ggtitle("TV-norm and KL-Divergence Over Time")

