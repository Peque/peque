#
# WEEK 3
#

library(datasets)
data(iris)
data(mtcars)

# 1, 2, 3
mean(subset(iris, Species == 'virginica')$Sepal.Length, na.rm = TRUE)
apply(iris[, 1:4], 2, mean)
with(mtcars, tapply(mpg, cyl, mean))

# 4
avg_hp <- with(mtcars, tapply(hp, cyl, mean))
avg_hp
abs(avg_hp['8'] - avg_hp['4'])

#
# Programming assignment (best, rankhospital, rankall)
#

source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
