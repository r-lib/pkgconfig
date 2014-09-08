library(testthat)
library(pkgconfig)

if (Sys.getenv("NOT_CRAN") != "") {
  test_check("pkgconfig")
}
