# Read data from CSV file
data <- read.table(file = "hw1_data.csv", header = TRUE, sep = ",")

# Getting column names of the dataset
names(data)

# Extracting the first 2 rows of the data frame
head(data, 2)

# Number of observations in the data frame
nrow(data)

# Extracting the first 2 rows of the data frame
tail(data, 2)

# Getting the value of Ozone in the 47th row
data[47, "Ozone"]

# Counting missing values in the Ozone column
length(data[is.na(data[,"Ozone"]), "Ozone"])

# Mean of the Ozone column (excluding missing values)
mean(data[!is.na(data[,"Ozone"]), "Ozone"])

# Extract the subset of rows of the data frame where Ozone values are
# above 31 and Temp values are above 90. What is the mean of Solar.R in
# this subset?
x <- subset(data, Ozone > 31 & Temp > 90)[,"Solar.R"]
mean(x[!is.na(x)])

# Calculating the mean of "Temp" when "Month" is equal to 6
x <- subset(data, Month == 6)[,"Temp"]
mean(x[!is.na(x)])

# Getting the maximum ozone value in the month of May
x <- subset(data, Month == 5)[,"Ozone"]
max(x[!is.na(x)])
