rankall <- function(outcome, num = 'best') {

	# Read data from CSV file
	df <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

	# Check the validity of the arguments
	valid_outcomes <- c('heart attack', 'heart failure', 'pneumonia')
	if (!outcome %in% valid_outcomes) stop("invalid outcome")

	# Associate column names and numbers
	outcome_columns <- c(11, 17, 23)
	names(outcome_columns) <- valid_outcomes

	# Column number according to the outcome parameter
	cn <- outcome_columns[outcome]

	# Make sure outcome data is treated as numeric
	df[, cn] <- suppressWarnings(as.numeric(df[, cn]))

	# Initial data frame columns
	state <- sort(unique(df$State))
	hospital <- rep(NA, length(state))

	# Parameter (num) preprocessing
	if (num == 'best') {
		n = 1
	} else {
		n <- num
	}

	# For each state, get the hospital we are looking for
	i <- 1
	for (s in state) {
		hlist <- subset(df, df$State == s, c(cn, Hospital.Name))
		hlist <- hlist[order(hlist[, 1], hlist[, 2], na.last = NA),]
		if (num == 'worst') {
			n <- nrow(hlist)
		}
		if (!n %in% 1:nrow(hlist)) {
			hospital[i] <- NA;
		} else {
			hospital[i] <- hlist[n, 2]
		}
		i <- i + 1
	}

	# Return the data frame
	return(data.frame(hospital, state))
}
