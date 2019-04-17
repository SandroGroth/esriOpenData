#' Call the JSONAPI using a GET request
#'
#' @param url
#' @param parameters
#'
#' @return dataframe
#'
#' @keywords internal
#' @noRd

esriOpenData.call_get <- function(url) {
  if (!is.character(url)) {msg("url has to be of type character", "ERROR")}

  response <- httr::GET(url)
  msg(paste0("Response status: ", response$status_code))

  if(response$status_code != 200) {msg(paste0("Failed to process request. Status code: ", response$status_code))}

  res_content <- httr::content(response, as = "text", encoding = "UTF-8")

  return(res_content)
}
