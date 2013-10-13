best <- function(state, outcome) {

	# Read data from CSV file
	csv_data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

	# Check the validity of the arguments
	valid_outcomes <- c('heart attack', 'heart failure', 'pneumonia')
	valid_states <- unique(csv_data$State)
	if (!state %in% valid_states) stop("invalid state")
	if (!outcome %in% valid_outcomes) stop("invalid outcome")

	# Create a data frame with relations between outcomes and columns
	outcome_columns <- c(11, 17, 23)
	outcomes_df <- data.frame(valid_outcomes, outcome_columns)

	# Make sure data is treated as numeric
	for (i in outcomes_df$outcome_columns) {
		csv_data[, i] <- suppressWarnings(as.numeric(csv_data[, i]))
	}

	# Get minimum value
	min_value <- min(subset(csv_data, csv_data$State == state, select = subset(outcomes_df, valid_outcomes == outcome)$outcome_columns), na.rm = TRUE)

	# Get hospitals list corresponding to that minimum value
	best_list <- subset(csv_data, csv_data$State == state & csv_data[, subset(outcomes_df, valid_outcomes == outcome)$outcome_columns] == min_value, select = Hospital.Name)

	# Return best case
	sort(best_list$Hospital.Name)[1]
}
