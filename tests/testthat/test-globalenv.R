
context("Global env")

test_that("Global env does not bother packages", {

  skip("Need a better way to run this")
  
  cmd <- '

  library(pkgconfig)
  library(testthat)
  library(disposables)

  set_config(key3 = "value")

  pkgs <- disposables::make_packages(
    pkgA = {
      setter <- function() { set_config(key3 = "value2") }
      getter <- function() { utility::getter() }
    },
    utility = {
      getter <- function() { get_config("key3", "fallback") }
    }
  )

  pkgA::setter()

  expect_equal(get_config("key3"), "value")
  expect_equal(pkgA::getter(), "value2")
  '

  tmp <- tempfile()
  cat(cmd, file = tmp)
  R <- file.path(R.home(), "bin", "R")

  system(paste(R, "--no-save", "<", tmp))
  
})
