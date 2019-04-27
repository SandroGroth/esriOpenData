#' Retrieves the actual data from a selected dataset.
#' TODO: Where clauses.
#'
#' @importFrom urltools param_set
#' @importFrom rgdal readOGR
#' @importFrom rgdal writeOGR
#'
#' @param sel_dataset
#' @param fields
#' @param sp_ref
#' @param export
#' @param format
#'
#' @keywords get_dataset
#' @export

get_dataset <- function(sel_dataset, fields=FALSE, sp_ref=4326, export=FALSE, format="shp") {
  if(!is.data.frame(sel_dataset)) {msg("sel_dataset has to be of type data.frame.", "ERROR")}
  if(!isFALSE(fields) & !is.vector(fields)) {msg("fields has to be FALSE or a vector.", "ERROR")}
  if(!is.numeric(sp_ref)) {msg("sp_ref has to be of type numeric.", "ERROR")}
  if(!is.logical(export)) {msg("export has to be of type logical.", "ERROR")}
  if(!"id" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'id'.", "ERROR")}
  if(!"url" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'url'.", "ERROR")}
  if(!"fields" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'fields'.", "ERROR")}
  if(!format %in% c("shp", "csv", "kml")) {msg("Supported formats are only: shp, csv, kml", "ERROR")}
  if(!sel_dataset$dataType == "Layer") {msg(paste0("selected datatype is currently not supported: ", sel_dataset$dataType), "ERROR")}

  rest_url <- sel_dataset$url
  id <- sel_dataset$id
  ds_fields <- sel_dataset$fields[[1]]$name
  slug <- sel_dataset$slug

  query_fields = "*"
  if(!isFALSE(fields)) {
    query_fields <- ""
    for(i in 1:length(fields)) {
      if(!fields[i] %in% ds_fields) {msg(paste0(fields[i], " is not a field in the specified dataset.", "ERROR"))}
      if(query_fields != "") {
        query_fields <- paste0(query_fields, ",", fields[i])
      } else {
        query_fields <- fields[i]
      }
    }
  }

  where_clause <- "1%3D1"
  rest_url <- paste0(URLencode(rest_url), "/query")
  rest_url <- urltools::param_set(rest_url, "outFields", URLencode(query_fields))
  rest_url <- urltools::param_set(rest_url, "where", URLencode(where_clause))
  rest_url <- urltools::param_set(rest_url, "outSR", sp_ref)
  rest_url <- urltools::param_set(rest_url, "f", "json")

  msg(paste0("Requesting URL: ", rest_url))

  response <- .call_get(rest_url)
  # TODO: check if reponse conains error

  tryCatch({response_spdf <- rgdal::readOGR(response, verbose = FALSE, layer = "ESRIJSON")},
            warning = function(w) {msg(w, "WARNING")},
            error = function(e) {msg(e, "ERROR")})

  if(isTRUE(export)) {
    out_dir <- ""
    if(isFALSE(getOption("esriOpendata.out_dir_set"))) {
      msg("No output directory set. Working directory will be selected.")
      out_dir <- getwd()
    } else {
      out_dir <- getOption("esriOpenData.out_dir")
    }
    dsn <- gsub(":", "", slug)
    dsn <- gsub("-", "_", dsn)
    if(format == "shp") {
      rgdal::writeOGR(response_spdf, paste0(out_dir, "/", dsn, ".shp"), 1, driver = "ESRI Shapefile")   # TODO: Handle stupid windows backslashes
    }
    if(format == "csv") {
      write.csv(response_spdf, paste0(out_dir, "/", dsn, ".csv"))
    }
  }

  return(response_spdf)
}
