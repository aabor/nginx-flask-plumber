library(tidyverse)
library("httr")
library(logging)
library(plumber)
removeHandler("writeToFile")
basicConfig()
#unlink("sample.log")
addHandler(writeToFile, logger="", file="sample.log")
loginfo("hello world", logger="company")
tryCatch({
  r <- plumb("plumber.R")  # Where 'plumber.R' is the location of the file shown above
  r$run(host = "0.0.0.0", port=8000)
}, error = function(e) {
  print(str_c("Error: ", e))
})
#Sys.sleep(10000)
# http://localhost:8000/echo?msg=hello
# APIs description:
# http://127.0.0.1:8000/__swagger__/
# GET("http://0.0.0.0:9000/")
