library(purrr)
library(zoo)
#' Import json string as R data frame
#'
#' All columns must have its names, index column will be lost. When saving
#' python pandas data frame convert index to odinary column
#'
#' @param file_name path to json file
#'
#' @return data.frame
#' @export
#'
#' @examples
#' file_name<-"test.json"
#' tz="Europe/Kiev"
#' res<-read_json_data_frame(file_name) 
#' res %>% head
#' str(res)
read_json_data_frame<-function(file_name, tz="Europe/Kiev"){
  json<-read_json(file_name)
  nms<-names(json)
  df<-json %>% 
    reduce(cbind) %>% 
    as.data.frame() %>% 
    jsonlite::flatten(recursive = TRUE) %>% 
    unnest
  colnames(df)<-nms
  df %>% 
    mutate(dt=as.POSIXct(dt, tz=tz))
}
#' Write responce data frame in json format
#'
#' @param df 
#' @param file_name 
#'
#' @return
#' @export
#'
#' @examples
#' df<-read_json_data_frame("test.json") 
#' file_response<-"response.json"
#' give_response(df, file_response)
give_response<-function(df, file_name){
  res<-df %>% mutate(m=number*value)
  write_json(res, file_name, simplifyVector = T, auto_unbox=T, pretty=T)
}

# url1<-"http://localhost:5000"
# POST(url1, body = list(y = upload_file(file_response)))


