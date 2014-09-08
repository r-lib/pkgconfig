
`_session` <- new.env()

.onLoad <- function(library, pkg) {
  unlockBinding("_session", asNamespace("pkgconfig"))
  invisible()
}

.onAttach <- function(library, pkg) {
  unlockBinding("_session", asNamespace("pkgconfig"))
  invisible()
}

clean_session <- function(pkg) {
  session <- get("_session")
  if (exists(pkg, where = session)) {
    rm(list = pkg, envir = session)
  }
}
