suppressMessages(library(tidyverse))
suppressMessages(library('testthat'))
suppressMessages(library(readr))
suppressMessages(library(stringi))
suppressMessages(library(xts))
# aggregating data to a higher level interval (thicken) and imputing records
# where observations were absent (pad)
suppressMessages(library(padr))
# A Tool Kit for Working with Time Series in R
suppressMessages(library(timetk))
# Bringing financial analysis to the 'tidyverse'. The 'tidyquant' package
# provides a convenient wrapper to various 'xts', 'zoo', 'quantmod', 'TTR' and
# 'PerformanceAnalytics' package functions and returns the objects in the tidy
# 'tibble' format. The main advantage is being able to use quantitative
# functions with the 'tidyverse' functions including 'purrr', 'dplyr', 'tidyr',
# 'ggplot2', 'lubridate', etc.
suppressMessages(library(tidyquant))
suppressMessages(library(jsonlite))
# Tools for working with HTTP organised by HTTP verbs (GET(), POST(), etc)
suppressMessages(library("httr"))
source("rnews/text_message.R")

resources_initialization<-list()
