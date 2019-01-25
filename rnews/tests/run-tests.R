library('testthat')
options(testthat.output_file = "test-reports/rnews.xml")
testthat::test_dir('rnews/tests/testthat/')
