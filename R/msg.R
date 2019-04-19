#' logging
#'
#' @param message
#' @param level
#' @param tag
#'
#' @keywords logging
#' @noRd

msg <- function(message, level="INFO", tag="") {
  if (level == "ERROR") {
    stop(paste0(tag, " ", message), call. = FALSE, immediate. = TRUE)
    quit("no")
  }
  if (level == "WARNING") {
    warning(paste0(tag, " ", message))
  }
  if (level == "INFO") {
    message(paste0(tag, " ", message))
  }
}
