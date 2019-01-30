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
  text<-req$postBody
  loginfo(str_glue("recieved\r\n{text}"), logger="rnews.text_message")
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

