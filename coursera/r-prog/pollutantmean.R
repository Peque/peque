pollutantmean <- function(directory, pollutant, id = 1:332) {
	pv <- vector('numeric')
	# For each file, append all the pollutant values to the pv vector
	for (i in 1:length(id)) {
		fname <- formatC(id[i], 2, NULL, 'd', 0)
		fpath <- paste0(directory, '/', fname, '.csv')
		fdata <- read.table(file = fpath, header = TRUE, sep = ',')
		pv <- append(pv, fdata[, pollutant])
	}
	# Return the mean of all values in the pv vector
	return(mean(pv, na.rm = TRUE))
}
