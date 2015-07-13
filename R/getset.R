
## This is the environment that stores all parameters

config <- new.env()

## ----------------------------------------------------------------------

#' Query a configuration parameter key
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

  NULL
}

## ----------------------------------------------------------------------

#' Set a configuration parameter
#'
#' @param ... Parameters to set, they should be all named.
#' @return Nothing.
#'
#' @export
#' @importFrom utils packageName

set_config <- function(...) {
  check_named_args(...)
  set_config_session(who = packageName(env = parent.frame()), ...)
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
