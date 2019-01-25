library('testthat')
options(testthat.output_file = "test-reports/test-multiplication.xml")
testthat::test_dir('rnews/tests/testthat/')
