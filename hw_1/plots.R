# plots.R
library(ggplot2)

# Question 1 plots
eig_values = read.csv("eigenvalues.csv", stringsAsFactors = FALSE,
                      header = FALSE)

k_mat = c(rep("k0", 5), rep("k50", 5), rep("k200", 5))
eig_values$k_mat = k_mat
names(eig_values) = c("real", "imag", "k_mat")
eig_values

ggplot(eig_values[1:5,], aes(x = real, y = imag)) +
  geom_point(size = 2.5, colour = "deeppink2") + xlim(-1, 1) + ylim(-1, 1) + 
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) + theme_bw() +
  gg_circle(r = 1, xc = 0, yc = 0) + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())

ggplot(eig_values[5:10,], aes(x = real, y = imag)) +
  geom_point(size = 2.5, colour = "blue3") + xlim(-1, 1) + ylim(-1, 1) + 
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) + theme_bw() +
  gg_circle(r = 1, xc = 0, yc = 0) + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())

ggplot(eig_values[11:15,], aes(x = real, y = imag)) +
  geom_point(size = 2.5, colour = "green3") + xlim(-1, 1) + ylim(-1, 1) + 
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) + theme_bw() +
  gg_circle(r = 1, xc = 0, yc = 0) + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())



gg_circle <- function(r, xc, yc, color="black", fill=NA, ...) {
  x <- xc + r*cos(seq(0, pi, length.out=100))
  ymax <- yc + r*sin(seq(0, pi, length.out=100))
  ymin <- yc + r*sin(seq(0, -pi, length.out=100))
  annotate("ribbon", x=x, ymin=ymin, ymax=ymax, color=color, fill=fill, ...)
}


