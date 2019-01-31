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
#' post_text_data(data_type)
post_text_data<-function(data_type="sr"){
  payload<-create_POST_payload(data_type)
  url<-"http://pnews:5000"
  url_path<-file.path(url, "text_message")
  resp <- POST(url_path, body = payload, content_type_json())
  if(resp$status_code == 200){
    loginfo("payload {payload} POSTed to {url_path}", logger="post_text_data")
  }
  return(resp$status_code)
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
  ret<-string2df(l$text)
  if(l$spec=="sr"){
    ret %>% 
      mutate(dt=index) %>%
      select(-index) %>% 
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
#' Convert string with csv encoded data to data.frame
#'
#' @param csv 
#'
#' @return
#' @export
#'
#' @examples
#' payload<-create_POST_payload("df") %>% fromJSON
#' csv<-payload$text
#' string2df(csv)
string2df<-function(csv){
  read_csv(csv)
}
