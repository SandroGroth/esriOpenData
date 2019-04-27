#' settings
#'
#' @param dir
#'
#' @export

set_dir <- function(dir) {
  if (!is.character(dir)) {msg("Ouput directory has to be of type character.", "ERROR")}
  if (!dir.exists(dir)) {
    tryCatch({
      msg("Output directory does not exist, but will be created", "INFO")
      dir.create(dir, recursive = TRUE)
      }, warning = function(w) {
        msg(w, "WARNING")
      }, error = function(e) {
        msg(e, "ERROR")
      })
  }

  out_dir <- path.expand(dir)

  options(esriOpenData.out_dir = dir)
  options(esriOpenData.out_dir_set = TRUE)

}

#' Sets an aoi for the current session.
#'
#' @param sp_obj
#'
#' @keywords settings
#' @export

set_aoi <- function(sp_obj=FALSE) {
  if(!isFALSE(sp_obj)) {
    if(!class(sp_obj) %in% getOption("esriOpenData.sp_obj_classes")) {msg("sp_obj is not a spatial object.", "ERROR")}
    options(esriOpenData.aoi = sp_obj)
    options(esriOpenData.aoi_set = TRUE)
  } else {
    msg("No spatial object specified. Drawing enabled.")
    drawn <- mapedit::editMap(leaflet::leaflet() %>% leaflet::addTiles(), sf = FALSE)
    # TODO: Allow only rectangles
    # TODO: Implement Conversion from drawn to bbox
  }
}

#' Checks if an AOI is set for this session.
#'
#' @return TRUE if Aoi is set, FALSE if not.
#'
#' @keywords settings
#' @noRd

.is_aoi_set <- function() {
  if(isTRUE(getOption("esriOpenData.aoi_set"))) {
    if(!isFALSE(getOption("esriOpenData.aoi"))) {
      return(TRUE)
    } else {
      msg("Aoi setting indicated TRUE, but no AOI was found.", "ERROR")
    }
  } else {
    return(FALSE)
  }
}

#' On package startup
#'
#' @keywords settings
#' @noRd
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.esriOpenData <- list(
    esriOpenData.api_base = "https://hub.arcgis.com/api/v2",
    esriOpenData.api_dataset_endpoint = "/datasets",
    esriOpenData.out_dir_set = FALSE,
    esriOpenData.out_dir = FALSE,
    esriOpenData.aoi_set = FALSE,
    esriOpenData.aoi = FALSE,
    esriOpenData.verbose = FALSE,
    esriOpenData.data_categories = c(
      "Safe", "Crime", "Disaster", "Emergency",
      "Sustainable", "Climate", "Energy", "Infrastructure",
      "Liveable", "Culture", "Housing", "Transportation",
      "Prosperous", "Demographics", "Economy", "Education",
      "Healthy", "Disease", "Agriculture", "Health-Care",
      "Well-Run", "Boundaries", "Financial", "Planning & Landuse"
    ),
    esriOpenData.sp_obj_classes = c(
      "Spatial", "SpatialGrid", "SpatialGridDataFrame",
      "SpatialLines", "SpatialLinesDataFrame", "SpatialMulitPoints",
      "SpatialMultiPointsDataFrame", "SpatialPixels", "SpatialPixelsDataFrame",
      "SpatialPoints", "SpatialPointsDataFrame", "SpatialPolygons",
      "SpatialPolygonsDataFrame"
    )
  )
  to_set <- !names(op.esriOpenData) %in% names(op)
  if(any(to_set)) options(op.esriOpenData[to_set])
}
