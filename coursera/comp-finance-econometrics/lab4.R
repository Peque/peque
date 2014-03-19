
##########
# Ex. 01
##########

set.seed(123)

# Y_{t} = 0.05 + e_{t} + 0.5 * e_{t-1}
# e_t iid N(0, 0.1 ^ 2)

# Simulate 250 observations from the MA(1) model
ma1_sim = arima.sim(list(ma = 0.5), 250, mean = 0, sd = 0.1) + 0.05


##########
# Ex. 02
##########

# Make a line plot of the observations and add a horizontal line at zero
plot(ma1_sim, type = 'l', main = 'MA(1) Process: mu=0.05, theta=0.5',
     xlab = 'time', ylab = 'y(t)')
abline(h = 0)


##########
# Ex. 03
##########

# Generate the theoretical ACF with upto lag 10
acf_ma1_model = ARMAacf(ma = 0.5, lag.max = 10)

# Split plotting window in three rows
par(mfrow=c(3,1))
# First plot: The simulated observations
plot(ma1_sim, type = 'l', main = 'MA(1) Process: mu=0.05, theta=0.5',
     xlab = 'time', ylab = 'y(t)')
abline(h = 0)
# Second plot: Theoretical ACF:
plot(1:10, acf_ma1_model[2:11], type='h', col='blue',  ylab='ACF',
     main='theoretical ACF')
# Third plot: Sample ACF:
tmp = acf(ma1_sim, lag.max = 10, main = 'Sample AFC')

# Reset graphical window to only one graph
par(mfrow=c(1,1))


##########
# Ex. 04
##########

# Y_{t} - 0.05 =  0.5 * (Y_{t-1} - 0.05) + e_{t}
# e_t iid N(0, 0.1 ^ 2)

# Simulate 250 observations from the AR(1) model
ar1_sim = arima.sim(list(ar = 0.5), 250, mean = 0, sd = 0.1) + 0.05

# Generate the theoretical ACF with upto lag 10
acf_ar1_model = ARMAacf(ar = 0.5, lag.max = 10)

# Split plotting window in three rows
par(mfrow=c(3,1))
# First plot: The simulated observations
plot(ar1_sim, type = 'l', main = 'AR(1) Process: mu=0.05, phi=0.5',
     xlab = 'time', ylab = 'y(t)')
abline(h = 0)
# Second plot: Theoretical ACF:
plot(1:10, acf_ar1_model[2:11], type='h', col='blue',  ylab='ACF',
     main='theoretical ACF')
# Third plot: Sample ACF:
tmp = acf(ar1_sim, lag.max = 10, main = 'Sample AFC')

# Reset graphical window to only one graph
par(mfrow=c(1,1))


##########
# Extra
##########

A = matrix(c(1, 2, 6, 4, 4, 1, 7, 8, 3), nrow = 3)
B = matrix(c(4, 5, 2, 4, 9, 2, 0, 1, 5), nrow = 3)
x = matrix(c(1, 2, 3))
y = matrix(c(5, 2, 7))

t(A)              # Compute the transpose of A
A + B             # Compute A + B
A - B             # Compute A - B
2 * A             # Compute 2 * A
A %*% x           # Compute A * x
t(y) %*% A %*% x  # Compute y' * A * x

# Solve the system of equations A * z = b
A = matrix(c(1, 2, 1, 4), nrow = 2)
b = matrix(c(1, 2))
z = solve(A) %*% b


##########
# Extra
##########

# Consider creating a portfolio of three assets denoted A, B and C.
# Assume the following information:

# Mean return vector
mu = matrix(c(0.01, 0.04, 0.02))
# Covariance matrix of the return vector
S = matrix(c(0.1, 0.3, 0.1, 0.3, 0.15, -0.2, 0.1, -0.2, 0.08), nrow = 3)

# Compute the expected return for an equally weighted portfolio
# Portfolio weights
x = matrix(c(1 / 3, 1 / 3, 1 / 3))
# Expected return
t(x) %*% mu

# Variance for that portfolio
t(x) %*% S %*% x
