
`_session` <- new.env()

.onLoad <- function(library, pkg) {
  unlockBinding("_session", asNamespace("pkgconfig"))
  invisible()
}

.onAttach <- function(library, pkg) {
  unlockBinding("_session", asNamespace("pkgconfig"))
  invisible()
}
