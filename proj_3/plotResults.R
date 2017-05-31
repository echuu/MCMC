# plotResults.R
# Project 3 Results


library(reshape2)
library(ggplot2)
library(dplyr)

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


setwd("~/MCMC/proj_3/results_1")

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
             title = paste("Beta = ", betas[i], ", ", "H(X) = ", h, sep = "")) +
        scale_x_continuous(breaks = 1:chain_length) + theme_bw() + 
        geom_vline(xintercept = chain_length, linetype = "dotted")
    beta_plots[[i]] = p_i
}

################################################################################
setwd("~/MCMC/proj_3/proj_2_betas")
gibbs_converge = list();
coalesce_time = c(48, 130, 1271, 0)
for (i in 1:length(betas)) {
    mc12         = read.csv(paste(pref, betas[i], ".csv", sep = ""));
    chain_length = dim(mc12)[1] / 2;
    moments      = mc12[,2]
    results      = data.frame(iter = rep(1:chain_length, 2),
                              mm   = moments,
                              mc   = c(rep(1, chain_length), 
                                       rep(2, chain_length)))
    if (coalesce_time[i] <= 0) {
        convergence = "--";
    } else {
        convergence = coalesce_time[i];
    }
    title_b = paste("Beta =", betas[i], ",", "time =", convergence);
    p_b = ggplot(results, aes(x = iter, y = mm, colour = as.factor(mc))) + 
        geom_line() + labs(x = "iterations", y = "Sum of Image", 
             title = title_b, colour = "MC") + 
        theme_bw()
    gibbs_converge[[i]] = p_b
}

gibbs_converge[[1]] = gibbs_converge[[1]] + 
    geom_vline(xintercept = coalesce_time[1], linetype = "dotted")

gibbs_converge[[2]] = gibbs_converge[[2]] + 
    geom_vline(xintercept = coalesce_time[2], linetype = "dotted")

gibbs_converge[[3]]= gibbs_converge[[3]] + 
    geom_vline(xintercept = coalesce_time[3], linetype = "dotted")

################################################################################

# Project Questions

# (1) plot sufficient statistics  H(X) of the current state X(t) against iter
# (2) Mark convergence time in the plots for comparison b/w 3 betas
#     and against the gibbs sampler convergence in project 2
# (4) Run the two MCs for beta = 1.0 and see how fast they converge
all_plots = append(beta_plots, gibbs_converge)
multiplot(all_plots[c(1, 2, 5, 6)], cols = 2)
multiplot(all_plots[c(3, 4, 7, 8)], cols = 2)

# (3) average size of the CPs flipped at each step (# of pixels) for each beta








