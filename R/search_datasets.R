#' Search datasets
#'
#' @export

search_datasets <- function(query="", source="", sector="", region="", aoi=FALSE) {
  if(!is.character(query)) {msg("Query has to be of type character.", "ERROR")}

  url <- paste0(getOption("esriOpenData.api_base"), getOption("esriOpenData.api_dataset_endpoint"))

  if(query != "") {url <- urltools::param_set(url, "q", query)}
  if(source != "") {url <- urltools::param_set(url, "source", source)}
  if(sector != "") {url <- urltools::param_set(url, "sector", sector)}
  if(region != "") {url <- urltools::param_set(url, "region", region)}
  url <- urltools::param_set(url, "page[size]", 1000)
  url <- urltools::param_set(url, "collection", "datasets")
  msg(paste0("Requesting URL: ", url, "INFO"))

  response <- esriOpenData.call_get(url)
  response_json <- jsonlite::fromJSON(response)
  return(response_json)
}
