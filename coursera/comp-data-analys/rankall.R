rankall <- function(outcome, num = 'best') {

	getname <- function(v, num) {
		if (num == 'best') {
			num = 1
		} else if (num == 'worst') {
			num = length(v)
		}
		v[num]
	}

	# Read data from CSV file
	csv_data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')

	# Check the validity of the arguments
	valid_outcomes <- c('heart attack', 'heart failure', 'pneumonia')
	if (!outcome %in% valid_outcomes) stop("invalid outcome")

	# Create a data frame with relations between outcomes and columns
	outcome_columns <- c(11, 17, 23)
	outcomes_df <- data.frame(valid_outcomes, outcome_columns)

	# Make sure data is treated as numeric
	for (i in outcomes_df$outcome_columns) {
		csv_data[, i] <- suppressWarnings(as.numeric(csv_data[, i]))
	}

	# Initial data frame columns
	state <- sort(unique(csv_data$State))
	hospital <- rep(NA, length(state))

	target_column <- subset(outcomes_df, valid_outcomes == outcome)$outcome_columns

	# Parameter (num) preprocessing
	if (num == 'best') {
		n = 1
	} else {
		n <- num
	}

	# For each state, get the hospital we are looking for
	i <- 1
	for (s in state) {
		hospital_list <- subset(csv_data, csv_data$State == s, select = c(target_column, Hospital.Name))
		hospital_list <- hospital_list[order(hospital_list[, 1], hospital_list[, 2], na.last = NA),]
		if (num == 'worst') {
			n <- nrow(hospital_list)
		}
		if (!n %in% 1:nrow(hospital_list)) {
			hospital[i] <- NA;
		} else {
			hospital[i] <- hospital_list[n, 2]
		}
		i <- i + 1
	}

	# Return the data frame
	data.frame(hospital, state)
}
