agecount <- function(age = NULL) {

	# Check validity of the parameter
	if (is(age, 'NULL') || !is(age, 'numeric') || age < 0) stop("invalid age")

	# Read "homicides.txt" data file
	homicides <- readLines("homicides.txt")

	## Extract ages of victims; ignore records where no age is given
	r <- regexpr(paste0('[^0-9]', age, ' *years *old'), homicides, ignore.case = TRUE)

	# Return integer containing count of homicides for that cause
	length(regmatches(homicides, r))
}
