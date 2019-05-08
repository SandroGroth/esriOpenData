#' Output directory Setting
#'
#' \code{set_dir} sets a project and session wide output directory. If the directory does not exist yet, a
#' new one will be created.
#'
#' @param dir Character. The path, where downloaded datasets should be stored.
#'
#' @author Sandro Groth
#'
#' @examples
#' library(esriOpenData)
#' set_dir(/home/user/Documents/esriOpenData_Download)
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



#' AOI Setting
#'
#' \code{set_aoi} sets an aoi for the current session by passing a spatial Object.
#' Spatial objects are all Subclasses of Spatial. Warning: drawing own aois is currently
#' not supported.
#'
#' @param sp_obj A spatial object of class Spatial or Subclasses.
#'
#' @author Sandro Groth
#'
#' @examples
#' library(esriOpenData)
#' library(rgdal)
#'
#' ## Load a shapefile using rgdal
#' aoi_shp <- readOGR("path/to/shapefile.shp")
#'
#' ## set session wide aoi
#' set_aoi(shp)
#'
#' @importFrom sf as_Spatial
#' @importFrom mapedit drawFeatures
#' 
#' @keywords settings
#' @export

set_aoi <- function(aoi=FALSE) {
  if(!isFALSE(aoi)) {
    if(!class(aoi) %in% getOption("esriOpenData.sp_obj_classes")) {msg("aoi is not a spatial object.", "ERROR")}
  } else {
    msg("No spatial object specified. Drawing enabled.", "INFO")
    aoi <- mapedit::drawFeatures(crs=4326)$geometry
    aoi <- sf::as_Spatial(aoi)
    # TODO: Allow only rectangles
    # TODO: Implement Conversion from drawn to bbox
  }
  options(esriOpenData.aoi = aoi)
  options(esriOpenData.aoi_set = TRUE)
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
    esriOpenData.hub_base = "https://hub.arcgis.com",
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
