getmonitor <- function(id, directory, summarize = FALSE) {
  data <- read.table(file = paste0(directory, '/', formatC(id, digits = 2, format = "d", flag = 0), ".csv"), header = TRUE, sep = ",")
  if (summarize) print(summary(data))
  data
}
