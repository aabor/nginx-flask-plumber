library(tidyverse)
library(readr)
library(jsonlite)
library("httr")
#library(logging)
library(testthat)

context("rnews Testing Succeeded!")
test_that("Multipilation works ", {
  res <- 5 * 2
  expect_equal(res, 10)
})

#library(plumber)
context("Main page exist")
test_that("Main page exist ", {
  resp<-GET("http://localhost", path = "rnews")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% str_squish()
  expect_equal(ctt, "Service rnews (language R) is ready!")
})
context("Health check")
test_that("Healthy ", {
  resp<-GET("http://localhost", path = "rnews/health")
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% str_squish()
  expect_equal(ctt, 'Healthy')
})
context("Echo response exists")
test_that("Echo response exists", {
  msg<-"rnews echo test"
  resp<-GET("http://localhost", path = "rnews/echo", query = list(msg = msg))
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% fromJSON()
  expect_equal(ctt$msg, 'The message is: \"rnews echo test\"')
})
context("Pause functions")
test_that("Pause functions ", {
  duration<-2
  resp<-GET("http://localhost", path = "rnews/pause", query = list(duration = duration))
  expect_equal(resp$status_code, 200)
  ctt<-content(resp) %>% unlist %>% fromJSON()
  expect_equal(ctt$msg, 'Pause of 2 seconds finished')
})
