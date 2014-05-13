complete <- function(directory, id = 1:332) {
	nobs <- vector('integer')
	# For each file, update the nobs vector with the sum of complete cases
	for (i in 1:length(id)) {
		fname <- formatC(id[i], 2, NULL, 'd', 0)
		fpath <- paste0(directory, '/', fname, '.csv')
		fdata <- read.table(file = fpath, header = TRUE, sep = ',')
		nobs[i] <- sum(complete.cases(fdata))
	}
	# Return the data frame
	return(data.frame(id, nobs))
}
