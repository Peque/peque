complete <- function(directory, id = 1:332) {
	nobs <- id
	complete_df <- data.frame(id, nobs)
	for (i in 1:length(id)) {
		file_data <- read.table(file = paste0(directory, '/', formatC(complete_df$id[i], digits = 2, format = "d", flag = 0), ".csv"), header = TRUE, sep = ",")
		complete_df$nobs[i] <- sum(complete.cases(file_data))
	}
	complete_df
}
