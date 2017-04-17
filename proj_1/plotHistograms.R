library(ggplot2)


path_length = 1:120
freq = rep(0, 120)


plen_dist = data.frame(path_length, freq)

d1 = plen_dist # 100ish walks
d1$freq = d1$freq + 0.1
d1$freq[83:120] = d1$freq[83:120] + 0.3
d1$freq[95:105] = d1$freq[95:105] + 0.3
d1$freq[98:102] = d1$freq[98:102] + 0.3

freq_small1 = runif(70, 0, 0.1)
freq_med = runif(4, 0, 0.1) + 0.1
freq_large1 = runif(6, 0, 0.25) + 0.2 # 80

freq_large11 = runif(2, 0, 0.3) + 1
freq_large111 = runif(3, 0, 0.3) + 2
freq_large1111 = runif(3, 0, 0.3) + 3
freq_large11111 = runif(1, 0, 0.3) + 4

freq_large111111 = runif(1, 0, 0.5) + 9 ## 90
freq_largest = runif(1, 0, 0.25) + 8.5
freq_largest1 = runif(1, 0, 0.25) + 8.3
freq_large22 = runif(1, 0, 0.25) + 7.5
freq_large222 = runif(2, 0, 0.1) + 6.5 # 98
freq_large2222 = runif(2, 0, 0.1) + 6 # 98
freq_small2 = runif(3, 0, 0.5) + 3     # 104
freq_endsmall = runif(3, 0, 0.1) + 2
freq_endsmall1 = runif(2, 0, 0.1) + 1.5
freq_endsmall11 = runif(6, 0, 0.1) + 0.2
freq_small = runif(9, 0, 0.05)

result = c(freq_small1, freq_med, freq_large1,
           freq_large11, freq_large111, freq_large1111,
           freq_large11111, freq_large111111,
           freq_largest, freq_largest1, 
           freq_large22, freq_large222, freq_large2222, freq_small2,
           freq_endsmall, freq_endsmall1, freq_endsmall11,
           freq_small)
walk = 1:120
plen_dist = data.frame(walk, result)
plen_dist = plen_dist %>% mutate(occ = round(result * 100))
freq = c()
for (i in walk) {
  freq_i = rep(i, plen_dist$occ[i])
  freq = c(freq, freq_i)
}
freq = data.frame(freq)
ggplot(freq, aes(x = freq)) + geom_histogram(binwidth = 1)
ggplot(freq, aes(x = freq)) + geom_density() +
  scale_x_continuous(breaks=seq(10, 120, 10))


ggplot(plen_dist, aes(x = walk, y = result)) +
  geom_histogram(stat = "identity", binwidth = 0.5, fill="black")


d2 = plen_dist # 90 ish walks
d3 = plen_dist # 110 ish walks