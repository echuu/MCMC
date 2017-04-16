library(ggplot2)
library(dplyr)

# read in data
d = read.csv("path_lengths.csv", header = FALSE);
d




#
plotSAWs = function(num_saws) {
  iters = dim(num_saws)[1];
  M = 1:iters;
  saw_data = data.frame(M, num_saws);
  names(saw_data) = c("M", "num_saws")
  
  ggplot(saw_data, aes(x = M, y = num_saws)) + 
    geom_point() + geom_line() +
    labs(title = "Number of SAWs vs. Number of Samples",
         x = "Samples", y = "# of SAWs")
}

