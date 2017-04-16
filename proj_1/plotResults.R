library(ggplot2)
library(dplyr)


for (n in (1:30)) {
  rate = 0.25
  print(10^(rate * n))
}

# read in data
plotSAW();


processPaths = function(dim) {
  
  p_rows = read.csv("path_rows.csv", header = FALSE);
  p_cols = read.csv("path_cols.csv", header = FALSE);
  
  path_length = dim(p_rows)[1] - 1; ## starting point doesn't count
  
  grid_pts = data.frame(p_rows, p_cols)
  names(grid_pts) = c("row", "col");
  
  ## generate the longest SAW
  ggplot(grid_pts, aes(x = row, y = col)) + 
    geom_path(aes(colour = "red"), size = 2) +
    labs(x = "", y = "", title = paste("SAW (length = ", path_length, ")",
                                       sep = ""))
  
}


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

