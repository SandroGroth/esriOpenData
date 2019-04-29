#' Search datasets
#'
#' \code{seearch_datasets} searches Esri's Open Data Hub using its REST API by applying
#' the specified filters. If an aoi is set by exacuting set_aoi(), results can be also
#' limited to a certain bounding box area.
#'
#' @param query Character, specifying the search query.
#' @param source Character, specifying the name of data sources.
#' @param sector Character, specifying the sector in which the search will be aplied.
#' @param region Character, region code, e.g. 'US'.
#' @param aoi Logical, wheter the search should be limited to the specified aoi or not.
#'
#' @return Dataframe, containing information about all matching datasets.
#'
#' @examples
#' library(esriOpenData)
#' datasets <- search_datasets("Census 2011", "statista", "Demography", "GER", aoi = T)
#'
#' @author Sandro Groth
#'
#' @importFrom urltools param_set
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr "%>%"
#'
#' @keywords search_datasets
#' @export

search_datasets <- function(query="", source="", sector="", region="", aoi=FALSE) {
  if(!is.character(query)) {msg("Query has to be of type character.", "ERROR")}
  if(!is.character(source)) (msg("Source has to be of type character.", "ERROR"))
  if(!is.character(sector)) {msg("Sector has to be of type character.", "ERROR")}
  if(!is.character(region)) {msg("Region has to be of type character,", "ERROR")}

  url <- paste0(getOption("esriOpenData.api_base"), getOption("esriOpenData.api_dataset_endpoint"))

  if(query != "") {url <- urltools::param_set(url, "q", query)}
  if(source != "") {url <- urltools::param_set(url, "source", source)}
  if(sector != "") {url <- urltools::param_set(url, "sector", sector)}
  if(region != "") {url <- urltools::param_set(url, "region", region)}

  if(isTRUE(aoi)) {
    if(!.is_aoi_set()) {msg("No aoi set. Please set an aoi using set_aoi.", "ERROR")}
    bb_str <- .bbox2str(.bbox(getOption("esriOpenData.aoi")))
    url <- urltools::param_set(url, "bbox", bb_str)
  }

  url <- urltools::param_set(url, "page[size]", 1000)

  msg(paste0("Requesting URL: ", url, "INFO"))
  response <- .call_get(url)
  response_df <- jsonlite::fromJSON(response)

  data <- response_df$data
  attributes <- data$attributes
  id <- data[ ,c("id")]
  response_df <- cbind(id, attributes)

  # exclude datasets that are not of type Layer
  response_df <- response_df[response_df$dataType == "Layer", ]

  return(response_df)
}
