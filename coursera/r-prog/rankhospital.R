rankhospital <- function(state, outcome, num = 'best') {

	# Read data from CSV file
	df <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

	# Check the validity of the arguments
	valid_outcomes <- c('heart attack', 'heart failure', 'pneumonia')
	valid_states <- unique(df$State)
	if (!state %in% valid_states) stop("invalid state")
	if (!outcome %in% valid_outcomes) stop("invalid outcome")

	# Associate column names and numbers
	outcome_columns <- c(11, 17, 23)
	names(outcome_columns) <- valid_outcomes

	# Column number according to the outcome parameter
	cn <- outcome_columns[outcome]

	# Make sure outcome data is treated as numeric
	df[, cn] <- suppressWarnings(as.numeric(df[, cn]))

	# Create a hospital list
	hlist <- subset(df, State == state, c(cn, Hospital.Name))

	# Sort list by rate (ascending), then by name (ascending)
	hlist <- hlist[order(hlist[, 1], hlist[, 2], na.last = NA), ]

	# Get best or worst case
	if (num == 'best')
		num = 1
	else if (num == 'worst')
		num = nrow(hlist)

	# Return NA when num is not valid
	if (!num %in% 1:nrow(hlist))
		return(NA)
	else
		return(hlist[num, 2])

}
