
## Find the package we were called from, to find the app name
## Right now the package can only be used from within another
## package

whoami <- function() {
  res <- sys.frames()
  res <- sapply(res, parent.env)
  res <- Filter(res, f = isNamespace)
  res <- sapply(res, environmentName)
  res <- Filter(res, f = function(x) x != packageName())
  res <- tail(res, 1)
  if (!length(res)) { stop("pkgconfig should be used from a package") }
  res
}

pkg_ns <- function() {
  asNamespace(whoami())
}
