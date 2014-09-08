
context("Session")

test_that("Session variables", {

  lib_dir <- tempfile()

  on.exit(try(unlink(lib_dir, recursive = TRUE), silent = TRUE), add = TRUE)
  on.exit(unloadNamespace("pkgconfigtest"), add = TRUE)
  on.exit(try(clean_session("pkgconfigtest")), add = TRUE)

  ## Make sure that we get the latest versions of them
  try(unloadNamespace("pkgconfigtest"), silent = TRUE)
  clean_session("pkgconfigtest")

  load_tmp_pkgs(lib_dir = lib_dir,
    pkgconfigtest = {

      f <- function() {
        set_config(foo = "bar", .where = "session")
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

context("Project")

test_that("Project config file", {

  lib_dir <- tempfile()

  on.exit(try(unlink(lib_dir, recursive = TRUE), silent = TRUE), add = TRUE)
  on.exit(unloadNamespace("pkgconfigtest"), add = TRUE)
  on.exit(try(clean_session("pkgconfigtest")), add = TRUE)
  on.exit(try(unlink(".pkgconfigtest.yml")), add = TRUE)

  ## Make sure that we get the latest versions of them
  try(unloadNamespace("pkgconfigtest"), silent = TRUE)
  clean_session("pkgconfigtest")

  load_tmp_pkgs(lib_dir = lib_dir,
    pkgconfigtest = {

      f <- function() {
        set_config(foo = list(a = 5, b = 6, c = 1:10), .where = "project")
      }

      g <- function() {
        get_config("foo")
      }

    }
  )

  f()
  expect_equal(g(), list(a = 5, b = 6, c = 1:10))

})

context("User")

test_that("User config file", {

  lib_dir <- tempfile()

  on.exit(try(unlink(lib_dir, recursive = TRUE), silent = TRUE), add = TRUE)
  on.exit(unloadNamespace("pkgconfigtest"), add = TRUE)
  on.exit(try(clean_session("pkgconfigtest")), add = TRUE)
  on.exit(try(unlink(file.path(rappdirs::user_config_dir(),
    "R-pkgconfig/pkgconfigtest"), recursive = TRUE)), add = TRUE)

  ## Make sure that we get the latest versions of them
  try(unloadNamespace("pkgconfigtest"), silent = TRUE)
  clean_session("pkgconfigtest")

  load_tmp_pkgs(lib_dir = lib_dir,
    pkgconfigtest = {

      f <- function() {
        set_config(foo = list(a = 5, b = 6, c = 1:10), .where = "user")
      }

      g <- function() {
        get_config("foo")
      }

    }
  )

  f()
  expect_equal(g(), list(a = 5, b = 6, c = 1:10))

})

context("Site")

test_that("Site config file", {

  lib_dir <- tempfile()

  on.exit(try(unlink(lib_dir, recursive = TRUE), silent = TRUE), add = TRUE)
  on.exit(unloadNamespace("pkgconfigtest"), add = TRUE)
  on.exit(try(clean_session("pkgconfigtest")), add = TRUE)
  on.exit(try(unlink(file.path(rappdirs::user_config_dir(),
    "R-pkgconfig/pkgconfigtest"), recursive = TRUE)), add = TRUE)

  ## Make sure that we get the latest versions of them
  try(unloadNamespace("pkgconfigtest"), silent = TRUE)
  clean_session("pkgconfigtest")

  load_tmp_pkgs(lib_dir = lib_dir,
    pkgconfigtest = {

      f <- function() {
        set_config(foo = list(a = 5, b = 6, c = 1:10), .where = "site")
      }

      g <- function() {
        get_config("foo")
      }

    }
  )

  if (is.writeable(file.path(rappdirs::user_config_dir(),
      "R-pkgconfig/pkgconfigtest"))) {
    f()
    expect_equal(g(), list(a = 5, b = 6, c = 1:10))
  }

})
