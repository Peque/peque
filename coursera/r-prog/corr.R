corr <- function(directory, threshold = 0) {
	cv <- vector('numeric')
	file_list <- list.files(directory)
	# For each file, append the correlation between sulfate and nitrate to
	# the cv vector (only when complete cases > threshold)
	for (f in file_list) {
		fpath <- paste0(directory, '/', f)
		fdata <- read.table(file = fpath, header = TRUE, sep = ',')
		ccases <- complete.cases(fdata)
		if (sum(ccases) > threshold) {
			fdata <- fdata[ccases, ]
			cv <- append(cv, cor(fdata$sulfate, fdata$nitrate))
		}
	}
	# Return the vector
	return(cv)
}
