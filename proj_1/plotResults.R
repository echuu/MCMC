library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape)


# read in data

design_1 = read.csv("d1_path_lengths.csv", header = FALSE);

path_1_r = read.csv("d1_path_rows.csv", header = FALSE);
path_1_c = read.csv("d1_path_cols.csv", header = FALSE);

processPaths(path_1_r, path_1_c)

design_2 = read.csv("d2_path_lengths.csv", header = FALSE);

path_2_r = read.csv("d2_path_rows.csv", header = FALSE);
path_2_c = read.csv("d2_path_cols.csv", header = FALSE);

design_3 = read.csv("d3_path_lengths.csv", header = FALSE);

path_3_r = read.csv("d3_path_rows.csv", header = FALSE);
path_3_c = read.csv("d3_path_cols.csv", header = FALSE);

processPaths(path_2_r, path_2_c)

if (1 == 0) {
  iter = c()
  for (n in (1:50)) {
    rate = 0.16
    #print(floor(10^(rate * n)))
    iter = c(iter, floor(10^(rate * n)))
  }
}

# other option
iter = c()
for (n in (1:38)) {
  rate = 0.2
  print(floor(10^(rate * n)))
  #iter = c(iter, floor(10^(rate * n)))
}


saw = data.frame(iter, d1 = design_1$V1, d2 = design_2$V1)
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
processPaths = function(p_rows, p_cols) {
  
  path_length = dim(p_rows)[1] - 1; ## starting point doesn't count
  
  grid_pts = data.frame(p_rows, p_cols)
  names(grid_pts) = c("row", "col");
  
  ## generate the longest SAW
  ggplot(grid_pts, aes(x = row, y = col)) + 
    geom_path(aes(colour = "red"), size = 2) +
    labs(x = "", y = "", 
         title = paste("SAW (length = ", path_length, ")", sep = ""))
  
}


