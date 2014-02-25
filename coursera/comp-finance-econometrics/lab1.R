
##########
# Ex. 01
##########

# Assign the url to the csv file.
data_file = 'lab1_sbuxPrices.csv'

# Load the data frame using read.csv
sbux_df = read.csv(data_file, header = TRUE, stringsAsFactors = FALSE)
# sbux_df should be a data frame object. Data frames are rectangular data
# objects typically with observations in rows and variables in columns.


##########
# Ex. 02
##########

# The str function compactly displays the structure of an R object.
str(sbux_df)

# The head and tail functions shows you the first and the last part of an
# R object respectively.
head(sbux_df)
tail(sbux_df)

# The class function shows you the class of an R object.
class(sbux_df$Date)


##########
# Ex. 03
##########

# Assign to the variable closing_prices all the adjusted closing prices
# while preserving the dimension information.
closing_prices = sbux_df[, 'Adj.Close', drop = FALSE]

# Extract the first five closing prices.
first5_closing_prices = sbux_df$Adj.Close[1:5]


##########
# Ex. 04
##########

# Find indices associated with the dates 3/1/1994 and 3/1/1995.
index_1 = which(sbux_df$Date == '3/1/1994')
index_2 = which(sbux_df$Date == '3/1/1995')

# Extract prices between 3/1/1994 and 3/1/1995.
some_prices = sbux_df$Adj.Close[index_1:index_2]


##########
# Ex. 05
##########

# Create a new data frame containing the price data with the dates as
# the row names.
sbux_prices_df = sbux_df[, 'Adj.Close', drop = FALSE]
rownames(sbux_prices_df) = sbux_df$Date
head(sbux_prices_df)

# With Dates as rownames, you can subset directly on the dates.
# Find indices associated with the dates 3/1/1994 and 3/1/1995.
price_1 = sbux_prices_df['3/1/1994', ]
price_2 = sbux_prices_df['3/1/1995', ]


##########
# Ex. 06
##########

# Plot the price data: blue line (width 2) and add labels and title to
# the plot.
plot(sbux_df$Adj.Close, type = 'l', col = 'blue', lwd = 2,
     ylab = 'Adjusted close', main = 'Monthly closing price of SBUX')
# Add a legend too
legend(x = 'topleft', legend = 'SBUX', lty = 1, lwd = 2, col = 'blue')


##########
# Ex. 07
##########

# Denote n the number of time periods.
n = nrow(sbux_prices_df)

# Calculate simple returns.
sbux_ret = (sbux_prices_df[2:n, 1] - sbux_prices_df[1:(n-1), 1]) /
           sbux_prices_df[1:(n-1), 1]
sbux_ret2 = sbux_prices_df[-1, ] / sbux_prices_df[-n, ] - 1
# Difference between both approaches (the first one is the expected in
# the exercise).
head(sbux_ret - sbux_ret2)

# Notice that sbux_ret is not a data frame object.
class(sbux_ret)


##########
# Ex. 08
##########

# Now add dates as names to the vector and print the first elements to
# ckeck.
names(sbux_ret) = sbux_df$Date[-1]
head(sbux_ret)


##########
# Ex. 09
##########

# Compute continuously compounded 1-month returns.
sbux_ccret = log(sbux_prices_df[-1, ]) - log(sbux_prices_df[-n, ])
sbux_ccret2 = log(sbux_prices_df[-1, ] / sbux_prices_df[-n, ])
# Difference between both approaches (the first one is the expected in
# the exercise).
head(sbux_ccret - sbux_ccret2)

# Assign names to the continuously compounded 1-month returns.
names(sbux_ccret) = sbux_df$Date[-1]
head(sbux_ccret)


##########
# Ex. 10
##########

# Compare the simple and cc returns.
head(cbind(sbux_ret, sbux_ccret))


##########
# Ex. 11
##########

# Plot the returns on the same graph.
plot(sbux_ret, type = 'l', col = 'blue', lwd = 2, ylab = 'Return',
     main = 'Monthly Returns on SBUX')
# Add horizontal line at zero.
abline(h = 0)
# Add a legend.
legend(x = 'bottomright', legend = c('Simple', 'CC'), lty = 1, lwd = 2,
       col = c('blue', 'red'))
# Add the continuously compounded returns.
lines(sbux_ccret, col = 'red', lwd = 2)


##########
# Ex. 12
##########

# Compute gross returns.
sbux_gret = sbux_ret + 1

# Compute future values of a dollar invested.
sbux_fv = cumprod(sbux_gret)

# Plot the evolution of the $1 invested in SBUX as a function of time.
plot(sbux_fv, type = "l", col = "blue", lwd = 2, ylab = "Dollars",
     main = "FV of $1 invested in SBUX")


##########
# Extra
##########

# Consider the following (actual) monthly adjusted closing price data
# for Starbucks stock over the period December 2004 through December 2005.
few_df = read.csv('lab1_sbuxPrices2.csv', header = TRUE, sep = '\t',
                  stringsAsFactors = FALSE)
sbux = few_df$Adj.Close
names(sbux) = few_df$Date
sbux

# What is the simple monthly return between the end of December 2004 and
# the end of January 2005?
sbux['January, 2005'] / sbux['December, 2004'] - 1

# If you invested $10,000 in Starbucks at the end of December 2004, how
# much would the investment be worth at the end of January 2005?
10000 * sbux['January, 2005'] / sbux['December, 2004']

# If you invested $10,000 in Starbucks at the end of December 2004, how
# much would the investment be worth at the end of December 2005?
10000 * sbux['December, 2005'] / sbux['December, 2004']

# What is the continuously compounded monthly return between December
# 2004 and January 2005?
log(sbux['January, 2005'] / sbux['December, 2004'])

# Assume that all 12 months have the same return as the simple monthly
# return between the end of December 2004 and the end of January 2005.
# What would be the annual return with monthly compounding in that case?
sret = sbux['January, 2005'] / sbux['December, 2004'] - 1
(1 + sret) ^ 12 - 1

# Assuming that all 12 months have the same return as the compounded
# monthly return between the end of December 2004 and the end of January
# 2005, what is the continuously compounded annual return?
# We can use the formula rt=ln(1+RT), being RT the annual return with
# monthly compounding
armc = (1 + sret) ^ 12 - 1
log(1 + armc)
# Or multiply the monthly return we calculated by 12 (continuously
# compounded returns are additive)
cret = log(sbux['January, 2005'] / sbux['December, 2004'])
cret * 12

# Compute the actual simple annual return between December 2004 and
# December 2005.
sbux['December, 2005'] / sbux['December, 2004'] - 1

# Compute the actual annual continuously compounded return between
# December 2004 and December 2005.
log(sbux['December, 2005'] / sbux['December, 2004'])
