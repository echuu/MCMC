# converge_analysis.R


multiplot <- function(plots, plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  #plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}



## generate sum of states vs. iterations
generatePlots = function() {
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
      labs(x = "iterations", y = "Sum of Image", 
           title = title_b, colour = "MC") + 
      theme_bw()
    
    plots[[b]] = p_b;
  }
  return(plots);
} ## generate sum of states vs. iterations

## save to file
saveToFile = function() {
  for (b in 1:length(beta)) {
    fname = paste("beta_", beta[b], ".csv", sep = "");
    write.csv(mc_results[[b]], fname);
  }
}
## end save to file


## plotting coalesce times vs. beta
timeVsBeta = function() {
    beta_time = data.frame(b = beta[1:8], time = as.numeric(coalesce[1:8]))
    ggplot(beta_time, aes(x = b, y = time)) + geom_line() +
      scale_x_continuous(breaks = seq(0.5, 1, 0.02)) + theme_bw() + 
      labs(title = "Coalesce Time for varying values of Beta",
           x = "beta", y = "time") + 
      geom_vline(xintercept=0.84, linetype = "dotted", colour = "red")
}
    