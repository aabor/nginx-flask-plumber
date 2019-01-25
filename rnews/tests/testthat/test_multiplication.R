#install.packages("testthat")
library(testthat)

context("Testing Succeeded!")
test_that("Multipilation works ", {
  res <- 5 * 2
  expect_equal(res, 10)
})

context("Test Failed!")
test_that("Multipilation works ", {
  res <- 5 * 2
  expect_equal(res, 12)
})
