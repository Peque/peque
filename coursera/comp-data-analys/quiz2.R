
library(datasets)

# Get 'iris' dataset
data(iris)
str(iris)

# Mean of 'Sepal.Length' for the species virginica
x <- subset(iris, Species == "virginica")$Sepal.Length
mean(x[!is.na(x)])

# Return a vector of the means of the variables
# 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'
apply(iris[, 1:4], 2, mean)

# Get 'mtcars' dataset
data(mtcars)
str(mtcars)

# Calculate the average miles per gallon (mpg) by number of cylinders
# in the car (cyl)
tapply(mtcars$mpg, mtcars$cyl, mean)

# Absolute difference between the average horsepower of 4-cylinder cars
# and the average horsepower of 8-cylinder cars
x <- tapply(mtcars$hp, mtcars$cyl, mean)
x['8'] - x['4']

# We can see how 'lapply' always returns a list while 'sapply' attempts
# to simplify the result.
str(lapply(mtcars$hp, mean))
str(sapply(mtcars$hp, mean))
