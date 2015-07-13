
## This is the environment that stores all parameters

config <- new.env()

## ----------------------------------------------------------------------

#' Query a configuration parameter key
#'
#' Query a configuration parameter key, and return the value
#' set in the calling package(s).
#'
#' @details
#' This function is meant to be called from the package whose
#' behavior depends on it. It searches for the given configuration
#' key, and if it exists, it checks which package(s) it was called
#' from and returns the configuration setting for that package.
#'
#' If the key is not set in any calling package, but it is set in
#' the global environment (i.e. at the R prompt), then it returns that
#' setting.
#'
#' If the key is not set anywhere, then it returns \code{NULL}.
#'
#' @param key The name of the parameter to query.
#' @param fallback Fallback if the parameter id not found anywhere.
#' @return The value of the parameter, or the fallback value if not found.
#'
#' @export

get_config <- function(key, fallback = NULL) {
  result <- get_from_session(key)
  if (is.null(result)) fallback else result[[1]]
}

get_from_session <- function(key) {
  value <- config[[key]]
  if (is.null(value)) return(list(NULL))

  pkgs <- sys.frames()
  pkgs <- lapply(pkgs, parent.env)
  pkgs <- Filter(pkgs, f = isNamespace)
  pkgs <- vapply(pkgs, environmentName, "")
  pkgs <- unique(pkgs)

  for (p in rev(pkgs)) {
    if (p %in% names(value)) return(value[[p]])
  }

  if ("R_GlobalEnv" %in% names(value)) {
    return(value[["R_GlobalEnv"]])
  }

  NULL
}

## ----------------------------------------------------------------------

#' Set a configuration parameter
#'
#' Set a configuration parameter, for the package we are calling from.
#' If called from the R prompt and not from a package, then it sets
#' the parameter for global environment.
#'
#' @param ... Parameters to set, they should be all named.
#' @return Nothing.
#'
#' @export
#' @importFrom utils packageName

set_config <- function(...) {
  check_named_args(...)
  who <- packageName(env = parent.frame()) %||% "R_GlobalEnv"
  set_config_session(who = who, ...)
}

check_named_args <- function(...) {
  nn <- names(list(...))
  if (is.null(nn) || any(nn == "")) {
    stop("Some parameters are not named")
  }
}

set_config_session <- function(who, ...) {
  l <- list(...)
  for (n in names(l)) {
    key <- config[[n]] %||% list()
    key[[who]] <- l[[n]]
    config[[n]] <- key
  }
}
