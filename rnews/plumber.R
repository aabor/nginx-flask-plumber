#* Main page
#* curl -i http://localhost:80/rnews/
#* @get /
function(){
  loginfo("main page opened.", logger="rnews")
  'Service rnews (language R) is ready!\r\n'
}
#* Health check
#* curl -i http://localhost:80/rnews/health
#* @param msg The message to echo
#* @get /health
function(){
  loginfo("checked.", logger="rnews.health")
  'Healthy\r\n'
}
#* Echo back the input
#* curl -i http://localhost:80/rnews/echo?msg='hello'
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  loginfo(msg, logger="rnews.echo")
  toJSON(list(msg = str_glue('The message is: "{msg}"')), pretty = T)
}
#* Pause execution by input number of seconds
#* curl -i http://localhost:80/rnews/pause?duration=2
#* @param duration int pause length
#* @get /pause
function(duration=1){
  loginfo(str_glue("Pause {duration} seconds"), logger="rnews.pause")
  Sys.sleep(duration)
  toJSON(list(msg=str_glue('Pause of {duration} seconds finished')), pretty = T)
}
#* Accept text message that contains data in table format
#* @param duration int pause length
#* @post /text_message
function(req, res){
  loginfo('text message in POST request arrived', logger="rnews.text_message")
  payload<-req$postBody
  loginfo(payload, logger="rnews.text_message")
  data<-accept_text_data(payload)
  tb<-data
  if(class(data) %in% c('xts', 'zoo')){
    tb<-tk_tbl(data) %>% 
      mutate(dt=as.character(index, format="%Y-%m-%d %H:%M:%S")) %>% 
      select(-index)
    nms<-colnames(tb)
    nms<-c('dt', nms[-1])
    tb<-select(tb, nms)
  }
  msg<-format_csv(tb)
  loginfo(msg, logger="rnews.text_message")
  "message accepted"
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

