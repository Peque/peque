setwd("./")

source("http://spark-public.s3.amazonaws.com/compdata/scripts/getmonitor-test.R")
getmonitor.testscript()

source("http://spark-public.s3.amazonaws.com/compdata/scripts/complete-test.R")
complete.testscript()

source("http://spark-public.s3.amazonaws.com/compdata/scripts/corr-test.R")
corr.testscript()
