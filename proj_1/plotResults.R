library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape)


# read in data
processPaths() ## generate plot for longest SAW
plotSAW();     ## generate plot for # SAWs vs. # of iterations

design_1 = read.csv("d1_path_length.csv")[,2];
design_2 = read.csv("d2_path_length.csv")[,2];

iter = c()
for (n in (1:38)) {
  rate = 0.2
  iter = c(iter, floor(10^(rate * n)))
}

saw = data.frame(iter, d1 = design_1, d2 = design_2)
saw_long = melt(saw, id="iter")


plotSAW(saw_long)

plotSAW = function(saw_data) {
  
  
  ggplot(saw_data, aes(x = log(iter, 10), y = log(value, 10))) + 
    geom_point(aes(colour = variable)) + geom_line(aes(colour = variable)) +
    labs(title = "Number of SAWs vs. Number of Samples",
         x = "Samples", y = "# of SAWs") +
    scale_x_continuous(breaks = log(c(10^0, 10^1, 10^2, 10^3, 10^4, 
                                      10^5, 10^6, 10^7, 10^8), 10))
  
}

processPaths = function() {
  
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

