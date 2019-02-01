#' Create data frame with random data
#'
#' @return
#' @export
#'
#' @examples
#' create_test_df()
create_test_df<-function(full_time=T){
  if(full_time){
    tibble(dt=Sys.time()-1:10, hash= stri_rand_strings(10, 4, '[A-Z]'), x=rnorm(10), y=rnorm(10)) %>% 
      return()
  }else{
    tibble(dt=Sys.Date()-1:10, hash= stri_rand_strings(10, 4, '[A-Z]'), x=rnorm(10), y=rnorm(10)) %>% 
      return()
  }
}
#' Create random time series
#'
#' @return
#' @export
#'
#' @examples
#' create_test_xts()
create_test_xts<-function(full_time=T){
  if(full_time){
    xts(tibble(x=rnorm(10), y=rnorm(10)), order.by=Sys.time()-1:10) %>% 
      return()
  }else{
    xts(tibble(x=rnorm(10), y=rnorm(10)), order.by=Sys.Date()-1:10) %>% 
      return()
  }
}
#' Create payload for POST request
#'
#' @param data_type 
#'
#' @return
#' @export
#'
#' @examples
#' data_type="df"
#' create_POST_payload(data_type)
#' data_type="sr"
#' create_POST_payload(data_type)
create_POST_payload<-function(data_type="sr"){
  tb<-NULL
  if(data_type == "sr"){
    tb<-create_test_xts(full_time=T) %>% 
      tk_tbl(index_rename = "dt", timetk_idx = FALSE) 
    nms<-colnames(tb)
    nms<-c('dt', nms[-1])
    colnames(tb)<-nms
  }
  else{
    tb<-create_test_df()
  }
  df<-tb %>% mutate(dt=as.character(dt, format="%Y-%m-%d %H:%M:%S"))
  format_csv(df, col_names=T) %>% 
  list(spec=data_type, text= .) %>% 
    toJSON(simplifyVector = T, auto_unbox=T, pretty=T)
}
#' POST text file in JSON format
#'
#' @param data_type 
#'
#' @return
#' @export
#'
#' @examples
#' data_type="sr"
#' data_type="df"
#' url="http://rnews:5000"
#' post_text_data(data_type, url)
post_text_data<-function(data_type="sr", url="http://pnews:5000"){
  payload<-create_POST_payload(data_type)
  url_path<-file.path(url, "text_message")
  POST(url_path, body = payload, content_type_json())
}
#' Convert json payload to data.frame or xts
#'
#' @param payload 
#'
#' @return
#' @export
#'
#' @examples
#' payload<-create_POST_payload("df")
#' payload<-create_POST_payload("sr")
#' accept_text_data(payload)
accept_text_data<-function(payload){
  l<-fromJSON(payload)
  ret<-read_csv(l$text)
  if(l$spec=="sr"){
    ret %>% 
      df2xts() -> ret
  }
  return(ret)
}
#' Convert data.frame to xts
#'
#' @param df 
#'
#' @return
#' @export
#'
#' @examples
#' payload<-create_POST_payload("df") %>% fromJSON
#' text<-payload$text
#' df<-string2df(text)
#' str(df)
#' df %>% head
#' df2xts(df)
df2xts<-function(df){
  date<-df %>% pull(dt)
  if(str_length(date[1])==10){
    df<-df %>% mutate(dt=as.Date(dt, format="%Y-%m-%d"))
  }
  if(str_length(date[1])==19){
    df<-df %>% mutate(dt=as.POSIXct(dt, format="%Y-%m-%d %H:%M:%S"))
  }
  tk_xts(df, select = -dt, date_var = dt)
}
#' Returns last update time of resource
#'
#' @param resource string name of the resource
#'
#' @return time in string representation
#' @export
#'
#' @examples
#' last_update_time() %>% class
last_update_time<-function(resource="news"){
  if(resource=="news"){
    return (Sys.time() %>% format.POSIXct(format="%Y-%m-%d %H:%M:%S"))
  }
  return('failed')
}
#' Update resource using data provided in task
#'
#' @param task JSON data
#'
#' @return
#' @export
#'
#' @examples
update_resource<-function(spec, text){
  if(spec=='news'){
    return('updated')
  }
  if(spec %in% c('df', 'sr')){
    loginfo(str_glue("\r\n{text}"), logger="rnews.update_resource")
    return('test for update service passed')
  }
  return('failed')
}

