#' Search datasets
#'
#' @export

search_datasets <- function(category=c(), name="", source="", sector="", region="", aoi=FALSE) {
  url <- paste0(getOption("esriOpenData.api_base"), getOption("esriOpenData.api_dataset_endpoint"))
  parameters = list()
  if(length(category) != 0) {rlist::list.append(parameters, q = category)}
  response <- esriOpenData.call_get(url, parameters)
  response_json <- jsonlite::fromJSON(response)
  return(response_json)
}
