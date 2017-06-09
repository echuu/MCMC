
# STATS 202C: HW 2
library(ggplot2)
# Problem 3 -- Shuffling Cards

# perform k shuffles (of t riffles) -> compute histogram of each card position
    # have k x 52, each row storing results of riffle
    # table for each row, divide by k to normalize to 1
    # store into position_dist matrix (match by card value)

X_0        = c(1:52);   # deck of cards
iters      = 10000;
shuffles   = 15;
randomness = rep(0, shuffles); # store randomness calculation

for (num_shuffles in 1:shuffles) {
    decks = matrix(rep(1:52, iters), nrow = iters, byrow = TRUE)
    for (k in 1:iters) {
        # shuffle t times
        X_cur = X_0;
        for (t in 1:num_shuffles) {
            X_t = shuffle(X_cur);
            X_cur = X_t;
        }
        decks[k,] = X_cur;
    }

    # iterate thru each position
    position_dist = matrix(c(rep(rep(0, 52), 52)), ncol = 52) # probs stored column-wise
    for (i in 1:52) {
        card_dist = data.frame(card_i = 1:52, p = rep(0, 52))
        df_c      = data.frame(table(decks[,i]));              # calculate freq
        df_c$Var1 = as.numeric(as.character(df_c$Var1))
        df_c$Freq = df_c$Freq / iters;                         # normalize to 1
        
        card_dist[df_c$Var1,]$p = df_c$Freq
        position_dist[,i] = card_dist$p;
    }
    
    randomness[num_shuffles] = err(position_dist)
    print(paste("iter:", num_shuffles, "-- randomness =", randomness[num_shuffles]));
}

random_results = data.frame(iter = 1:shuffles, randomness)
ggplot(random_results, aes(x = iter, y = randomness)) + geom_line() + 
    geom_point() + theme_bw() + labs(x = "Iteration", y = "err(t)", 
                      title = "Randomness as a function of time") + 
    scale_x_continuous(breaks = 1:15)
    

# shuffling function, takes input of current state
# returns next iteration (one iteration of shuffling)
shuffle = function(X_cur) {
    omega = c(0,1);          # sample space
    p     = 0.5;             # probaiblity of heads/tails
    N     = 52;              # number of bernoulli trials
    flips = sample(omega, size = N, replace = TRUE, prob = c(p, 1 - p));
    
    num_zeros = 1:(N - sum(flips))
    
    X_next = X_cur;
    
    X_next[flips == 0] = X_cur[num_zeros];
    X_next[flips == 1] = X_cur[-num_zeros];
    
    return(X_next);
}

# measure of randomness as function of time
# H is 52 x 52 matrix storing the probability distributions of the cards
# for each position in the deck -- positions are stored column-wise
# probabilities of each card are then stored row-wise
err = function(H) {
    uniform_dist = rep(1/52, 52);
    unif_matrix  = matrix(rep(uniform_dist, 52), ncol = 52);
    
    result = abs(H - unif_matrix);
    pos_sums = colSums(result) / 2;
    
    rand_measure = sum(pos_sums) / 52;
    return(rand_measure);
}




