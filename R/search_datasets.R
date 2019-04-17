#' Search datasets
#'
#' @export

search_datasets <- function(category="", name="", source="", sector="", region="", aoi=FALSE) {
  url <- paste0(getOption("esriOpenData.api_base"), getOption("esriOpenData.api_dataset_endpoint"))

  url <- urltools::param_set(url, "q", category)
  url <- urltools::param_set(url, "page[size]", 1000)
  msg(url, "INFO")

  response <- esriOpenData.call_get(url)
  response_json <- jsonlite::fromJSON(response)
  return(response_json)
}
