#' Call the JSONAPI using a GET request
#'
#' @param url
#' @param parameters
#'
#' @return dataframe
#'
#' @keywords internal
#' @noRd

.call_get <- function(url) {
  if (!is.character(url)) {msg("url has to be of type character", "ERROR")}

  response <- httr::GET(url)
  msg(paste0("Response status: ", response$status_code))

  if(response$status_code != 200) {msg(paste0("Failed to process request. Status code: ", response$status_code))}

  res_content <- httr::content(response, as = "text", encoding = "UTF-8")

  return(res_content)
}

#' Calculates a bouding box on a given spatial object.
#'
#'@param sp_obj
#'@param feature
#'
#'@return bbox matrix
#'
#'@keywords internal
#'@noRd

.bbox <- function(sp_obj, feature=FALSE) {
  # TODO: CHeck if sp_obj is a spatial object
  if(!class(sp_obj) %in% getOption("esriOpenData.sp_obj_classes")) {msg("sp_obj not recognized as a spatial object.", "ERROR")}

  box <- sp::bbox(sp_obj)

  return(box)
}

#' Converts a bbox matrix to an ESRI bbox URL parameter.
#'
#' @param box
#'
#' @return bbox url parameter string.
#' @noRd
.bbox2str <- function(box) {
  if(!is.matrix(box)) {msg("box has to be of type matrix.")}
  if(nrow(box) != 2 | ncol(box) != 2) {msg("spacified matrix is not a bounding box.")}

  return(paste0(box[1,1], ",", box[2,1], ",", box[1,2], ",", box[2,2]))

}
