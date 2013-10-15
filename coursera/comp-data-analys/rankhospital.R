rankhospital <- function(state, outcome, num = 'best') {

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

	# Get hospital list
	target_column <- subset(outcomes_df, valid_outcomes == outcome)$outcome_columns
	hospital_list <- subset(csv_data, csv_data$State == state, select = c(target_column, Hospital.Name))

	# Sort list by rate (ascending), then by name (ascending)
	hospital_list <- hospital_list[order(hospital_list[, 1], hospital_list[, 2], na.last = NA),]

	# Convert best and worst cases to the corresponding num
	if (num == 'best') {
		num = 1
	} else if (num == 'worst') {
		num = nrow(hospital_list)
	}

	# Return NA when num is not valid
	if (!num %in% 1:nrow(hospital_list)) {
		NA;
	} else {
		hospital_list[num, 2]
	}
}
