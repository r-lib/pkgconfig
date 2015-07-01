
## ----------------------------------------------------------------------

#' Query a configuration parameter key
#'
#' First the current session is searched, if the key is not found,
#' its default value is used, or the fallback value, if it does not
#' have a default.
#'
#' @param key The name of the parameter to query.
#' @param fallback Fallback if the parameter id not found anywhere.
#' @return The value of the parameter, or the fallback value if not found.
#'
#' @export

get_config <- function(key, fallback = NULL) {
  result <- get_from_session(key) %||%
    get_from_default(key)
  if (is.null(result)) fallback else result[[1]]
}

get_from_session <- function(key) {
  who <- whoami()
  session <- get("_session", asNamespace(utils::packageName()))
  if (exists(who, where = session)) {
    who_session <- get(who, envir = session)
    if (key %in% names(who_session)) { return(list(who_session[[key]])) }
  }
  NULL
}

get_from_default <- function(key) {
  ns <- pkg_ns()
  if (exists("_pkgconfig_defaults", where = ns)) {
    defaults <- get("_pkgconfig_defaults", envir = ns)
    if (key %in% names(defaults)) { return(list(defaults[[key]])) }
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

set_config <- function(...) {
  check_named_args(...)
  set_config_session(...)
}

check_named_args <- function(...) {
  nn <- names(list(...))
  if (is.null(nn) || any(nn == "")) {
    stop("Some parameters are not named")
  }
}

set_config_session <- function(...) {
  who <- whoami()
  session <- get("_session", asNamespace(utils::packageName()))
  if (exists(who, where = session)) {
    who_session <- get(who, envir = session)
  } else {
    who_session <- list()
  }
  l <- list(...)
  for (n in names(l)) { who_session[[n]] <- l[[n]] }
  assign(who, who_session, envir = session)
  invisible()
}
