best <- function(state, outcome) {

	# Read data from CSV file
	df <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

	# Check the validity of the arguments
	valid_outcomes <- c('heart attack', 'heart failure', 'pneumonia')
	valid_states <- unique(df$State)
	if (!state %in% valid_states) stop('invalid state')
	if (!outcome %in% valid_outcomes) stop('invalid outcome')

	# Associate column names and numbers
	outcome_columns <- c(11, 17, 23)
	names(outcome_columns) <- valid_outcomes

	# Column number according to the outcome parameter
	cn <- outcome_columns[outcome]

	# Make sure outcome data is treated as numeric
	df[, cn] <- suppressWarnings(as.numeric(df[, cn]))

	# Find lowest mortality rate
	low <- min(subset(df, State == state, cn), na.rm = TRUE)

	# Get hospitals list corresponding to that minimum value
	best_list <- subset(df, State == state & df[, cn] == low, Hospital.Name)

	# Return best case (sort in alphabetical order if there is a tie)
	return(sort(best_list$Hospital.Name)[1])

}
