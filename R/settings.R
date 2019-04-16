#' settings
#'
#' @param dir
#'
#' @export

set_dir <- function(dir) {
  if (!is.character(dir)) {msg("Ouput directory has to be of type character.", "ERROR")}
  if (!dir.exists(dir)) {
    tryCatch({
      dir.create(dir, recursive = TRUE)
      }, warning = function(w) {
        msg(w, "WARNING")
      }, error = function(e) {
        msg(e, "ERROR")
      })
  } else {
    msg("Output directory does not exist, but will be created", "INFO")
  }

  out_dir <- path.expand(dir)

  options(esriOpenData.out_dir = dir)
  options(esriOpenData.out_dir_set = TRUE)

}

#' On package startup
#'
#' @keywords settings
#' @noRd
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.esriOpenData <- list(
    esriOpenData.api_base = "https://hub.arcgis.com/api/v2",
    esriOpenData.out_dir_set = FALSE,
    esriOpenData.out_dir = FALSE,
    esriOpenData.verbose = FALSE
  )
  to_set <- !names(op.esriOpenData) %in% names(op)
  if(any(to_set)) options(op.esriOpenData[to_set])
}
