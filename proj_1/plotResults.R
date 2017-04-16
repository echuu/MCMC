library(ggplot2)
library(dplyr)

# read in data
plotSAW();


plotSAW = function() {
  
  d = read.csv("path_lengths.csv", header = FALSE);
  
  iters = dim(d)[1];
  M = 1:iters;
  saw_data = data.frame(M, d);
  names(saw_data) = c("M", "num_saws")
  
  ggplot(saw_data, aes(x = M, y = d)) + 
    geom_point() + geom_line() +
    labs(title = "Number of SAWs vs. Number of Samples",
         x = "Samples", y = "# of SAWs")
}

