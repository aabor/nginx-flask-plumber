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
#* @param req request object
#* @param res response object
#* @post /text_message
function(req, res){
  loginfo('text message in POST request arrived', logger="rnews.text_message")
  payload<-req$postBody
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
#* Test connection to pnews service, use POST request
#* @post /test_connectivity
function(req, res){
  loginfo('started', logger="rnews.test_connectivity")
  resp<-post_text_data(data_type="df", url="http://pnews:5000")
  if (resp$status_code == 200)
    msg='finished successfully'
  else
    msg="error from rnews"
  loginfo(msg, logger="rnews.test_connectivity")
  msg
}
#* Update resource 
#* @param req request object
#* @param res response object
#* @serializer contentType list(type="application/json")
#* @get /update
#* @post /update
function(req, res){
  loginfo('update request arrived', logger="rnews.update")
  print('POST Request printed:')
  print(names(req))
  if (req$REQUEST_METHOD == "GET") {
    loginfo(str_glue('requested last update time for resource "{req$args$resource}"'), logger="rnews.update")
    return(last_update_time(req$args$resource))
  }
  if (req$REQUEST_METHOD == "POST") {
    payload<-req$postBody %>% fromJSON()
    print(payload$spec)
    print(payload$text)
    loginfo(str_glue('Update arrived for resource "{payload$spec}"'), logger="rnews.update")
    return(update_resource(payload$spec, payload$text))
  }
  loginfo('failed', logger="rnews.update")
}
#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

