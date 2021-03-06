source("rnews/rnews_imports.R")
library(logging)
library(plumber)

removeHandler("writeToFile")
basicConfig()
getwd()
log_file<-str_c(basename(getwd()), ".log", sep='')
#unlink("sample.log")
addHandler(writeToFile, logger="", file=log_file)
loginfo("started", logger="rnews")
tryCatch({
  r <- plumb("rnews/plumber.R")  # Where 'plumber.R' is the location of the file shown above
  r$run(host = "0.0.0.0", port=5000)
}, error = function(e) {
  print(str_c("Error: ", e))
})
#Sys.sleep(10000)
# http://localhost:5000/echo?msg=hello
# APIs description:
# http://127.0.0.1:5000/__swagger__/
# GET("http://0.0.0.0:9000/")

# Test via proxy
# curl http://localhost:80/rnews/echo?msg=hello
# curl http://localhost:80/pnews/echo?msg=hello
