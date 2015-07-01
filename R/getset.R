
## ----------------------------------------------------------------------

#' Query a configuration parameter
#'
#' This is the order in which the parameter is searched for: \enumerate{
#'   \item The configuration of the current session.
#'   \item The project configuration file in the current working
#'      directory. For project \sQuote{foo} this is called
#'      \code{.foo.yml}.
#'   \item The user's configuration file. The place of this is determined
#'      using \code{user_config_dir()} from the \code{rappdirs} package.
#'   \item The site-wide configuration file. The place of this is
#'      determined using \code{site_config_dir()} from the \code{rappdirs}
#'      package.
#'   \item The default configuration that is stored in the
#'      \code{_pkgconfig_defaults} variable within the package.
#'      (It is not necessary to export this variable from the package.)
#' }
#'
#' @param key The name of the parameter to query.
#' @return The value of the parameter
#'
#' @export

get_config <- function(key) {
  result <- get_from_session(key) %||%
    get_from_default(key)
  result[[1]]
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
