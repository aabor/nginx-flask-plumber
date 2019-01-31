url<-"http://rnews:5000"
context("Main page exist")
test_that("Main page exist", {
  resp<-GET(url)
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% str_squish()
  expect_equal(ctt, "Service rnews (language R) is ready!")
})
context("Health check")
test_that("Health check", {
  resp<-GET(url, path = "health")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% str_squish()
  expect_equal(ctt, 'Healthy')
})
context("Echo response exists")
test_that("Echo response exists", {
  msg<-"rnews echo test"
  resp<-GET(url, path = "echo", query = list(msg = msg))
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% fromJSON()
  expect_equal(ctt$msg, 'The message is: \"rnews echo test\"')
})
context("Pause functions")
test_that("Pause functions", {
  duration<-2
  resp<-GET(url, path = "pause", query = list(duration = duration))
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% fromJSON()
  expect_equal(ctt$msg, 'Pause of 2 seconds finished')
})
context("POST data.frame to rnews")
test_that("POST data.frame to rnews", {
  resp<-post_text_data(data_type="df", url="http://rnews:5000")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'message accepted')
})
context("POST xts to rnews")
test_that("POST xts to rnews", {
  resp<-post_text_data(data_type="sr", url="http://rnews:5000")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'message accepted')
})
context("POST data.frame to pnews")
test_that("POST data.frame to pnews", {
  resp<-post_text_data(data_type="df", url="http://pnews:5000")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'message accepted')
})
context("POST xts to pnews")
test_that("POST xts to pnews", {
  resp<-post_text_data(data_type="sr", url="http://pnews:5000")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'message accepted')
})
context("Test connectivity from pnews to rnews")
test_that("Test connectivity from pnews to rnews", {
  resp <- POST(file.path("http://pnews:5000", "test_connectivity"), body = "")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist
  expect_equal(ctt, 'finished successfully')
})
