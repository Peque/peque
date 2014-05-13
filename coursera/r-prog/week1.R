#
# WEEK 1
#

data_file <- './hw1_data.csv'
df <- read.table(data_file, header = FALSE, sep = ',', stringsAsFactors = FALSE)

# 4, 5, 6
class(4L)
class(c(4, "a", TRUE))
cbind(c(1, 3, 5), c(3, 2, 10))

# 8, 9
list(2, "a", "b", TRUE)[[2]]
1:4 + 2:3

# 10
x <- c(17, 14, 4, 5, 13, 12, 10)
x[x >= 11] <- 4

# 11, 12, 13, 14, 15, 16, 17
names(df)
head(df, 2)
nrow(df)
tail(df, 2)
df$Ozone[47]
sum(is.na(df$Ozone))
mean(df$Ozone, na.rm = TRUE)

# 18
ss <- subset(df, Ozone > 31 & Temp > 90, select = Solar.R)
mean(ss$Solar.R, na.rm = TRUE)

# 19
ss <- subset(df, Month == 6, select = Temp)
mean(ss$Temp, na.rm = TRUE)

# 20
ss <- subset(df, Month == 5, select = Ozone)
max(ss$Ozone, na.rm = TRUE)

#
# Programming assignment (swirl)
#
install.packages("swirl")
library('swirl')
swirl()

#
# Functions to remember: c, rep, paste, sample, seq, length, is.na, sum, mean,
#                        subset, head, tail, nrow, max, class, cbind, rbind,
#                        read.table, ncol, names, library, min, vector, append,
#                        paste0, help, identical, dim, attributes, str, matrix,
#                        identical, colnames...
#
# Be sure to understand well all of those functions!
#
