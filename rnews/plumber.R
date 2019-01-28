#* Main page
#* curl -i http://localhost:80/rnews/
#* @get /
function(){
  'Service rnews (language R) is ready!\r\n'
}
#* Health check
#* curl -i http://localhost:80/rnews/health
#* @param msg The message to echo
#* @get /health
function(){
  'Healthy\r\n'
}
#* Echo back the input
#* curl -i http://localhost:80/rnews/echo?msg='hello'
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  toJSON(list(msg = str_glue('The message is: "{msg}"')), pretty = T)
}
#* Pause execution by input number of seconds
#* curl -i http://localhost:80/rnews/pause?duration=2
#* @param duration int pause length
#* @get /pause
function(duration=1){
  Sys.sleep(duration)
  toJSON(list(msg=str_glue('Pause of {duration} seconds finished')), pretty = T)
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b){
  as.numeric(a) + as.numeric(b)
}