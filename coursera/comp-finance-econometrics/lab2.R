
##########
# Ex. 01
##########

# X ~ N(0.05, (0.10)^2)
mu_x = 0.05
sigma_x = 0.1

# Pr(X > 0.10)
1 - pnorm(0.1, mu_x, sigma_x)

# Pr(X < -0.10)
pnorm(-0.1, mu_x, sigma_x)

# Pr(-0.05 < X < 0.15)
pnorm(0.15, mu_x, sigma_x) - pnorm(-0.05, mu_x, sigma_x)


##########
# Ex. 02
##########

# 1%, 5%, 95% and 99% quantile, with just one command
qnorm(c(0.01, 0.05, 0.95, 0.99), mu_x, sigma_x)


##########
# Ex. 03
##########

# Y ~ N(0.025, (0.05)^2)
mu_y = 0.025
sigma_y = 0.05

# Normally distributed monthly returns
x_vals = seq(-0.25, 0.35, length.out = 100)
MSFT = dnorm(x_vals, mu_x, sigma_x)
SBUX = dnorm(x_vals, mu_y, sigma_y)


##########
# Ex. 04
##########

# Normal curve for MSFT
plot(x_vals, MSFT, type = 'l', col = 'blue', ylab = 'Normal curves',
     ylim = c(0, 8))
# Add normal curve for SBUX in red color
lines(x_vals, SBUX, col = 'red')
# Add plot legend
legend('topleft', legend = c('Microsoft', 'Starbucks'),
       col = c('blue', 'red'), lty = 1)


##########
# Ex. 05
##########

# R ~ N(0.04, (0.09)^2)
mu_R = 0.04
sigma_R = 0.09
# Initial wealth W0 = $100,000
W0 = 100000
# 1% value-at-risk of simple monthly returns (loss in investment value
# that may occur over the next month with 1% probability)
qnorm(0.01, mu_R, sigma_R) * W0
# 5% value-at-risk of simple monthly returns
qnorm(0.05, mu_R, sigma_R) * W0


##########
# Ex. 06
##########

# Let the r denote the continuously compounded monthly return
mu_r = 0.04
sigma_r = 0.09
# Initial wealth W0 = $100,000
W0 = 100000
# 1% value-at-risk of continuously compounded monthly returns (loss in
# investment value that may occur over the next month with 1% probability)
(exp(qnorm(0.01, mu_r, sigma_r)) -1) * W0
# 5% value-at-risk of continuously compounded monthly returns
(exp(qnorm(0.05, mu_r, sigma_r)) -1) * W0


##########
# Ex. 07
##########

# Vectors of prices
PA = c(38.23, 41.29)
PC = c(41.11, 41.74)

# Simple monthly returns
RA = (PA[2] - PA[1]) / PA[1]
RC = (PC[2] - PC[1]) / PC[1]


##########
# Ex. 08
##########

# Continuously compounded returns
rA = log(1 + RA)
rC = log(1 + RC)


##########
# Ex. 09
##########

# Cash dividend per share
DA = 0.1
# Simple total return
RA_total = (PA[2] + DA - PA[1]) / PA[1]
# Dividend yield: RA_total = simple_return + dividend_yield
DY = DA/PA[1]


##########
# Ex. 10
##########

# Suppose the monthly returns on Amazon are equal to RA every month for
# one year.

# Simple annual return
RA_annual = (RA + 1) ^ 12 - 1
# Continuously compounded annual return
rA_annual = log(1 + RA_annual)


##########
# Ex. 11
##########

# Portfolio shares
xA = 8000 / 10000
xC = 2000 / 10000

# Simple monthly return
xA * RA + xC * RC
