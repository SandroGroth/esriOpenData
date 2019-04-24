#' Search datasets
#' @importFrom magrittr "%>%"
#'
#' @param query
#' @param source
#' @param sector
#' @param region
#' @param aoi
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
  ids <- data[ ,c("id")]
  response_df <- cbind(ids, attributes)

  return(response_df)
}
