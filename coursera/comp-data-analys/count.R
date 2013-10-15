count <- function(cause = NULL) {

	# Check validity of the parameter
	valid_causes = c('asphyxiation', 'blunt force', 'other', 'shooting', 'stabbing', 'unknown')
	if (is(cause, 'NULL') || !cause %in% valid_causes) stop("invalid cause")

	# Read "homicides.txt" data file
	homicides <- readLines("homicides.txt")

	# Extract causes of death
	r <- regexpr(paste0('<dd>cause: *', cause, ' *</dd>'), homicides, ignore.case = TRUE)

	# Return integer containing count of homicides for that cause
	length(regmatches(homicides, r))

}
