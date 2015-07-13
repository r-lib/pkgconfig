
if (Sys.getenv("NOT_CRAN") != "") {
  library(testthat)
  library(pkgconfig)
  test_check("pkgconfig")
}
