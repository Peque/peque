corr <- function(directory, threshold = 0) {
	file_list <- list.files(directory)
	corr_vector <- vector('numeric')
	for (f in file_list) {
		file_data <- read.table(file = paste0(directory, '/', f), header = TRUE, sep = ",")
		if (sum(complete.cases(file_data)) > threshold) {
			file_data <- file_data[complete.cases(file_data), ]
			corr_vector <- append(corr_vector, cor(file_data$sulfate, file_data$nitrate))
		}
	}
	corr_vector
}
