
## ----------------------------------------------------------------------

#' Query a configuration parameter
#'
#' This is the order in which the parameter is searched for: \enumerate{
#'   \item The configuration of the current session.
#'   \item The project configuration file in the current working
#'      directory.
#'   \item The user's configuration file.
#'   \item The site-wide configuration file.
#' }
#'
#' @param key The name of the parameter to query.
#' @return The value of the parameter
#'
#' @export

get_config <- function(key) {
  result <- get_from_session(key) %||%
    get_from_files(key) %||%
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

get_from_files <- function(key) {
  for (f in config_route()) {
    val <- get_from_file(key, file = f)
    if (!is.null(val)) return(val)
  }
  NULL
}

#' @importFrom yaml yaml.load_file

get_from_file <- function(key, file) {
  if (file.exists(file)) {
    config <- yaml.load_file(file)
    if (key %in% names(config)) { return(list(config[[key]])) }
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
#' @param .where Where to set the parameters, \sQuote{user} is the
#'   default and it means the user level configuration file.
#'   \sQuote{project} means the project configuration file,
#'   in the current directory. \sQuote{session} is not persistent,
#'   only sets the parameter in a current R session. Finally, \sQuote{site}
#'   means the site-level configuration file.
#' @return Nothing.
#'
#' @export

set_config <- function(..., .where = c("user", "project",
                              "session", "site") ) {
  .where <- match.arg(.where)
  check_named_args(...)
  if (.where == "user") {
    set_config_user(...)
  } else if (.where == "project") {
    set_config_project(...)
  } else if (.where == "session") {
    set_config_session(...)
  } else if (.where == "site") {
    set_config_site(...)
  }
}

check_named_args <- function(...) {
  nn <- names(list(...))
  if (is.null(nn) || any(nn == "")) {
    stop("Some parameters are not named")
  }
}

set_config_user <- function(...) {
  file <- config_route()[["user"]]
  set_config_in_file(file, list(...))
}

set_config_project <- function(...) {
  file <- config_route()[["project"]]
  set_config_in_file(file, list(...))
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

set_config_site <- function(...) {
  file <- config_route()[["site"]]
  set_config_in_file(file, list(...))
}

## TODO: locking

#' @importFrom yaml yaml.load_file as.yaml

set_config_in_file <- function(file, conf_list) {

  if (file.exists(file)) {
    config <- yaml.load_file(file)
  } else {
    config <- list()
  }

  config <- modifyList(config, conf_list, keep.null = TRUE)

  if (!file.exists(dirname(file))) {
    dir.create(dirname(file), recursive = TRUE, showWarnings = FALSE)
  }
  tmp <- tempfile()
  cat(as.yaml(config), file = tmp)
  file.rename(tmp, file)

  invisible()
}
