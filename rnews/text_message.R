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
last_update_time<-function(resource="news", symbol=""){
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
update_resource<-function(spec="news", symbol="", text=""){
  if(spec=='news'){
    return('updated')
  }
  if(spec %in% c('df', 'sr')){
    loginfo(str_glue("\r\n{text}"), logger="rnews.update_resource")
    return('test for update service passed')
  }
  if(symbol !=""){
    loginfo(str_glue("got update, printing:"), logger="rnews.update_resource")
    text<-str_replace_all(text, 'nl', '\n')
    loginfo(str_glue("\n{text}"), logger="rnews.update_resource")
    print(read_csv(text, col_names = F))
    return('test for update service passed')
  }
  return('failed')
}
text<-'2019-02-01 14:40:00,24981,24981,24961,24963,96newline2019-02-01 14:45:00,24962,24972,24962,24967,108newline2019-02-01 14:50:00,24966,24966,24952,24961,125newline2019-02-01 14:55:00,24960,24960,24950,24952,113newline2019-02-01 15:00:00,24953,24958,24948,24958,136newline2019-02-01 15:05:00,24959,24971,24957,24962,123newline2019-02-01 15:10:00,24963,24964,24948,24952,117newline2019-02-01 15:15:00,24953,24959,24942,24955,101newline2019-02-01 15:20:00,24956,24961,24948,24959,119newline2019-02-01 15:25:00,24958,24965,24947,24955,191newline2019-02-01 15:30:00,24958,25029,24958,25022,542newline2019-02-01 15:35:00,25021,25055,25018,25048,314newline2019-02-01 15:40:00,25048,25054,25036,25042,193newline2019-02-01 15:45:00,25041,25044,25024,25035,216newline2019-02-01 15:50:00,25033,25046,25024,25031,211newline2019-02-01 15:55:00,25032,25047,25031,25044,142newline2019-02-01 16:00:00,25045,25046,25034,25044,137newline2019-02-01 16:05:00,25045,25052,25033,25050,147newline2019-02-01 16:10:00,25049,25057,25045,25051,114newline2019-02-01 16:15:00,25050,25053,25019,25020,168newline2019-02-01 16:20:00,25020,25030,25014,25017,150newline2019-02-01 16:25:00,25018,25038,25018,25030,128newline'
text<-str_replace_all(text, 'newline', '\n')
text
