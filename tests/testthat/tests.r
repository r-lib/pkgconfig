
context("Session")

test_that("Session variables", {

  on.exit(try(disposables::dispose_packages(pkgs)))
  pkgs <- disposables::make_packages(
    pkgconfigtest = {
      f <- function() {
        set_config(foo = "bar")
        get_config("foo")
      }
      g <- function() { get_config("foo") }
      h <- function() { get_config("foobar") }
    }
  )

  expect_equal(f(), "bar")
  expect_equal(g(), "bar")
  expect_null(h())

})
