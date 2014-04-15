
##########
# Ex. 01
##########

# Load relevant packages
library(PerformanceAnalytics)
library(zoo)
library(tseries)

# Get monthly adjusted closing price data on VBLTX, FMAGX and SBUX from
# Yahoo! using the tseries function get.hist.quote(). Set sample to Jan 1998
# through Dec 2009.

# Get the adjusted closing prices from Yahoo!
VBLTX_prices = get.hist.quote(instrument = "vbltx", start = "1998-01-01",
                              end = "2009-12-31", quote = "AdjClose",
                              provider = "yahoo", origin = "1970-01-01",
                              compression = "m", retclass = "zoo")

FMAGX_prices = get.hist.quote(instrument = "fmagx", start = "1998-01-01",
                              end = "2009-12-31", quote = "AdjClose",
                              provider = "yahoo", origin = "1970-01-01",
                              compression = "m", retclass = "zoo")

SBUX_prices = get.hist.quote(instrument = "sbux", start = "1998-01-01",
                             end = "2009-12-31", quote = "AdjClose",
                             provider = "yahoo", origin = "1970-01-01",
                             compression = "m", retclass = "zoo")

# Change class of time index to yearmon which is appropriate for monthly data.
# index() and as.yearmon() are functions in the zoo package

index(VBLTX_prices) = as.yearmon(index(VBLTX_prices))
index(FMAGX_prices) = as.yearmon(index(FMAGX_prices))
index(SBUX_prices) = as.yearmon(index(SBUX_prices))

# Inspect your data
start(SBUX_prices)
end(SBUX_prices)


##########
# Ex. 02
##########

# Create merged price data
all_prices = merge(VBLTX_prices, FMAGX_prices, SBUX_prices)
colnames(all_prices) = c('VBLTX', 'FMAGX', 'SBUX')

# Calculate cc returns as difference in log prices
all_returns = diff(log(all_prices))
# Look at the return data
start(all_returns)
end(all_returns)
colnames(all_returns)
head(all_returns)


##########
# Ex. 03
##########

# Plot returns using the PerformanceAnalytics function chart.TimeSeries().
# This function creates a slightly nicer looking plot than plot.zoo()
chart.TimeSeries(all_returns, legend.loc = 'bottom', main = '')

# The previous charts are a bit hard to read. The PerformanceAnalytics
# function chart.Bar makes it easier to compare the returns of different
# assets on the same plot
chart.Bar(all_returns, legend.loc = 'bottom', main = '')


# Cumulative return plot - must use simple returns (!) and not cc returns
# for this Use PerformanceAnalytics function chart.CumReturns()
simple_returns = diff(all_prices) / lag(all_prices, k = -1)

# Generate a cumulative return plot with the chart.CumReturns function.
chart.CumReturns(simple_returns, legend.loc = 'topleft',
                 main = 'Future Value of $1 invested', wealth.index = TRUE)


##########
# Ex. 04
##########

# Creating a graphical summary for a return series.

# Create matrix with returns
return_matrix = coredata(all_returns)

# Generate 4 panel plots
par(mfrow = c(2, 2))
hist(return_matrix[, "VBLTX"], main = "VBLTX monthly returns", xlab = "VBLTX",
     probability = T, col = "slateblue1")
boxplot(return_matrix[, "VBLTX"], outchar = T, main = "Boxplot",
        col = "slateblue1")
plot(density(return_matrix[, "VBLTX"]), type = "l", main = "Smoothed density",
     xlab = "monthly return", ylab = "density estimate", col = "slateblue1")
qqnorm(return_matrix[, "VBLTX"], col = "slateblue1")
qqline(return_matrix[, "VBLTX"])
par(mfrow = c(1, 1))


##########
# Ex. 05
##########

# Show boxplot of three series on one plot
boxplot(return_matrix[, "VBLTX"], return_matrix[, "FMAGX"],
        return_matrix[, "SBUX"], names = colnames(return_matrix),
        col = "slateblue1")

# Do the same thing using the PerformanceAnalytics function chart.Boxplot
chart.Boxplot(return_matrix)


##########
# Ex. 06
##########

summary(return_matrix)

# Compute descriptive statistics by column using the base R function apply()
args(apply)
apply(return_matrix, 2, mean)
apply(return_matrix, 2, var)
apply(return_matrix, 2, sd)
apply(return_matrix, 2, skewness)
apply(return_matrix, 2, kurtosis)

# A nice PerformanceAnalytics function that computes all of the relevant
# descriptive statistics is table.Stats
table.Stats(all_returns)


##########
# Ex. 06
##########

# Annualized monthly estimates

# Annualized continuously compounded mean
12 * apply(return_matrix, 2, mean)

# Annualized simple mean
exp(12 * apply(return_matrix, 2, mean)) - 1

# Annualized standard deviation values
sqrt(12) * apply(return_matrix, 2, sd)


##########
# Ex. 07
##########

# Display all possible pair-wise scatter plots
pairs(return_matrix, pch = 16, col ='slateblue1')

# Compute 3 x 3 covariance and correlation matrices
var(return_matrix)
cor(return_matrix)


##########
# Extra
##########

EX = 2
EY = 1
VarX = 3
VarY = 2.5
CovXY = 0.9

# What is E[.4X + .6Y] ?
.4 * EX + .6 * EY

# What is Var[.4X + .6Y] ?
.4 ^ 2 * VarX + .6 ^ 2 * VarY + 2 * .4 * .6 * CovXY

# Suppose X and Y are returns on two assets, and w is your portfolio weight in
# asset X with (1−w) being the portfolio weight in asset Y. What value of w
# minimizes the variance of your portfolio?
w = (VarY - CovXY) / (VarX + VarY - 2 * CovXY)
w

# What is the variance of the portfolio with the weights you derived in the
# previous question?
w ^ 2 * VarX + (1 - w) ^ 2 * VarY + 2 * w * (1 - w) * CovXY

# What is the expected value of the portfolio with the weights you derived in
# the previous question?
w * EX + (1 - w) * EY


##########
# Extra
##########

# Being a general AR(1) model:
#   Y{t} = c + phi * Y{t−1} + e{t}
#   e{t} ∼ N(0, sigma{e} ^ 2)
# Consider the AR(1) model:
#   Y{t} = 10 + .6 * Y{t−1} + e{t}
#   e{t} ∼ N(0, 2 ^ 2)

# The process is covariance stationary?
-1 < 0.6 && 0.6 < 1

# What is the mean of this process?
#   EY = c + phi * EY + 0; EY = c / (1 - phi)
10 / (1 - 0.6)

# What is the variance of the process?
#   VarY = sigma{e} ^ 2 / (1 - phi ^ 2)
2 ^ 2 / (1 - 0.6 ^ 2)
