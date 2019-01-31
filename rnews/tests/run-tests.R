source("rnews/rnews_imports.R")
wd<-getwd() #working directory difers when running from RStudio or from Rscript
output_file<-file.path(wd, "rnews/tests/testthat/test-reports/rnews.xml")
file.exists(output_file) # TRUE
options(testthat.output_file = output_file)
dir.exists("rnews/tests/testthat") #TRUE
testthat::test_dir('rnews/tests/testthat', reporter = "junit")

