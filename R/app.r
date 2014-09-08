
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

#' @importFrom rappdirs user_config_dir site_config_dir

config_route <- function() {
  who <- whoami()
  appname <- file.path("R-pkgconfig", who)
  local <- file.path(getwd(),  paste0(".", who, ".yml"))
  dirs <- c(user_config_dir(appname),
            site_config_dir(appname))
  structure(c(local,
              file.path(dirs, "default.yml")),
            .Names = c("project", "user", "site"))
}

pkg_ns <- function() {
  asNamespace(whoami())
}
