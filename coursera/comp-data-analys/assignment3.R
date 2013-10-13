setwd('./ProgAssignment3-data')


#
# PART 1
#

outcome <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

# Because we originally read the data in as character (by specifying
# colClasses = 'character') we need to coerce the column to be numeric.
# You may get a warning about NAs being introduced but that is okay.
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11],
     main = 'Heart Attack 30-day Death Rate',
     xlab = '30-day Death Rate')


#
# PART 2
#

outcome <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

# Hospital 30-Day Death (Mortality) Rates from Heart Attack
outcome[, 11] <- as.numeric(outcome[, 11])
# Hospital 30-Day Death (Mortality) Rates from Heart Failure
outcome[, 17] <- as.numeric(outcome[, 17])
# Hospital 30-Day Death (Mortality) Rates from Pneumonia
outcome[, 23] <- as.numeric(outcome[, 23])

title_label <- c('Heart Attack','Heart Failure', 'Pneumonia')
col_number <- c(11, 17, 23)
x_label = '30-day Death Rate'
x_range = range(c(outcome[, 11], outcome[, 17], outcome[, 23]), na.rm = TRUE)

# Plot data
par(mfrow = c(3, 1))
for (i in 1:length(col_number)) {
	hist(outcome[, col_number[i]],
		 main = bquote(.(title_label[i])~group("(", bolditalic(bar(X)) == .(mean(outcome[, col_number[i]], na.rm = TRUE)),")")),
		 xlab = x_label,
		 xlim = x_range,
		 prob = TRUE)
	lines(density(outcome[, col_number[i]], na.rm = TRUE), lty = 'dotted')
	abline(v =  median(outcome[, col_number[i]], na.rm = TRUE), col = 'red')
}


#
# PART 3
#

# List of states that contain more than 20 hospitals (or 20 hospitals)
x <- simplify2array(names(subset(table(outcome$State), table(outcome$State) > 20)))

# New data set (excluding states with less than 20 hospitals)
outcome2 <- subset(outcome, outcome$State %in% x)

# Get the 30-day death medians, sorted (lowest to highest)
medians <- sort(tapply(outcome2[, 11], outcome2$State, median, na.rm = TRUE))

# Change axis labels orientation and size
par(las = 2, cex.axis = 0.8, mfrow = c(1, 1))

# Print the graphics, sort the boxes using factor() function
boxplot(outcome2[, 11] ~ factor(outcome2$State, levels = names(medians)),
        main = 'Heart Attack 30-day Death Rate by State',
        ylab = '30-day Death Rate')

# TODO: Alter the x-axis tick labels so that they include the number of
# hospitals in that state in parentheses. For example, the label for the
# state of Connecticut would be CT (32). You will need the axis function
# and when you call the boxplot function you will want to set the option
# xaxt to be “n”.
