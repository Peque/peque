
##########
# Ex. 01
##########

# Standard deviations and correlation
sig_x = 0.10
sig_y = 0.05
# Correlation (Measures direction and strength of linear relationship
# between 2 rv’s)
rho_xy = 0.9

# Covariance between X and Y (Measures direction but not strength of
# linear relationship between 2 rv’s)
sig_xy = rho_xy * sig_x * sig_y

# Covariance matrix
Sigma_xy = matrix(c(sig_x ^ 2, sig_xy, sig_xy, sig_y ^ 2), 2, 2)


##########
# Ex. 02
##########

# Load the mvtnorm package
library("mvtnorm")
# The covariance matrix (Sigma_xy) is still in your workspace

# Means
mu_x = 0.05
mu_y = 0.025

# Simulate 100 observations
set.seed(123)  # for reproducibility
xy_vals = rmvnorm(100, c(mu_x, mu_y), Sigma_xy)
head(xy_vals)


##########
# Ex. 03
##########

# Create scatterplot
plot(xy_vals[, 1], xy_vals[, 2], pch = 16, cex = 2, col = 'blue',
     main = 'Bivariate normal: rho=0.9', xlab = 'x', ylab = 'y')


##########
# Ex. 04
##########

# Add lines to indicate the theoretical central location of the point cloud
abline(h = mu_y, v = mu_x)


##########
# Ex. 05
##########

# Compute the joint probability Pr(X<0,Y<0).
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Ex. 06
##########

# Example of negatively correlated variables (rho_xy = -0.9)
rho_xy = -0.9
sig_xy = rho_xy * sig_x * sig_y
Sigma_xy = matrix(c(sig_x^2, sig_xy, sig_xy, sig_y^2), nrow = 2, ncol = 2)
set.seed(123)  # for reproducibility
xy_vals = rmvnorm(100, mean = c(mu_x, mu_y), sigma = Sigma_xy)
plot(xy_vals[, 1], xy_vals[, 2], pch = 16, cex = 2, col = "blue",
     main = "Bivariate normal: rho=-0.9", xlab = "x", ylab = "y")
abline(h = mu_y, v = mu_x)
segments(x0 = 0, y0 = -1e+10, x1 = 0, y1 = 0, col = "red")
segments(x0 = -1e+10, y0 = 0, x1 = 0, y1 = 0, col = "red")
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Ex. 07
##########

# Example of uncorrelated random variables (rho_xy = 0)
rho_xy = 0
sig_xy = rho_xy * sig_x * sig_y
Sigma_xy = matrix(c(sig_x^2, sig_xy, sig_xy, sig_y^2), nrow = 2, ncol = 2)
set.seed(123)  # for reproducibility
xy_vals = rmvnorm(100, mean = c(mu_x, mu_y), sigma = Sigma_xy)
plot(xy_vals[, 1], xy_vals[, 2], pch = 16, cex = 2, col = "blue",
     main = "Bivariate normal: rho=0", xlab = "x", ylab = "y")
abline(h = mu_y, v = mu_x)
segments(x0 = 0, y0 = -1e+10, x1 = 0, y1 = 0, col = "red")
segments(x0 = -1e+10, y0 = 0, x1 = 0, y1 = 0, col = "red")
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Ex. 08
##########

# Compute the joint probability Pr(X<0,Y<0) when correlation is 0.9
rho_xy = 0.9
sig_xy = rho_xy * sig_x * sig_y
Sigma_xy = matrix(c(sig_x ^ 2, sig_xy, sig_xy, sig_y ^ 2), 2, 2)
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Ex. 09
##########

# Compute the joint probability Pr(X<0,Y<0) when correlation is zero
rho_xy = 0
sig_xy = rho_xy * sig_x * sig_y
Sigma_xy = matrix(c(sig_x ^ 2, sig_xy, sig_xy, sig_y ^ 2), 2, 2)
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Ex. 10
##########

# Compute the joint probability Pr(X<0,Y<0) when correlation is -0.9
rho_xy = -0.9
sig_xy = rho_xy * sig_x * sig_y
Sigma_xy = matrix(c(sig_x ^ 2, sig_xy, sig_xy, sig_y ^ 2), 2, 2)
pmvnorm(c(-Inf, -Inf), c(0, 0), c(mu_x, mu_y), sigma = Sigma_xy)


##########
# Extra
##########

# Consider the following joint distribution of X and Y
# (X in rownames, Y in colnames)
jd_xy = matrix(c(0.1, 0.1, 0, 0.2, 0, 0.1, 0, 0.2, 0.3), 3, 3)
rownames(jd_xy) = c(1, 2, 3)
colnames(jd_xy) = c(1, 2, 3)

# Compute E[X]
P_x = rowSums(jd_xy)
X_vals = as.numeric(rownames(jd_xy))
mu_x = sum(P_x * X_vals)

# Compute E[Y]
P_y = colSums(jd_xy)
Y_vals = as.numeric(colnames(jd_xy))
mu_y = sum(P_y * Y_vals)

# Compute the variance of X
var_x = sum((X_vals - mu_x) ^ 2 * P_x)

# Compute the variance of Y
var_y = sum((Y_vals - mu_y) ^ 2 * P_y)

# Compute the standard deviation of X
stdev_x = sqrt(var_x)

# Compute the standard deviation of Y
stdev_y = sqrt(var_y)

# Compute the covariance of X and Y
cov_xy = sum((X_vals - mu_x) %*% t(Y_vals - mu_y) * jd_xy)

# Compute de correlation of X and Y
corr_xy = cov_xy / (stdev_x * stdev_y)


##########
# Extra
##########

# Let r denote the continuously compounded monthly return on Microsoft
# stock and let W0 denote initial wealth to be invested over the month.
# Assume that r∼ iid N(0.04,(0.09)2) and that W0 = $100,000. Determine
# the 1% and 5% value-at-risk (VaR) over the year on the investment.
# Hint: to answer this question, you must determine the normal distribution
# that applies to the annual (12 month) continuously compounded return.

# 0.01 quantile of normal distribution for r (annualized)
qr = qnorm(0.01, 12 * 0.04, sqrt(12) * 0.09)
# Quantile conversion (r into R)
qR = exp(qr) - 1
# Value at Risk
VaR = qR * 100000
