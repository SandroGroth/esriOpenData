#' Get dataset fields
#'
#' \code{fields} returns the field names of a selected dataset.
#'
#' @param sel_dataset Dataframe, containing a selected dataset from select_dataset().
#'
#' @return Vector, containing all field names.
#'
#' @examples
#' datasets <- search_datasets("Zensus 2011", aoi = T)
#' selected <- select_dataset(datasets, 1)
#' fields(selected)
#'
#' @author Sandro Groth
#'
#' @keywords fields
#' @export

fields <- function(sel_dataset){
  if(!is.data.frame(sel_dataset)) {msg("sel_dataset has to be of type data.frame.", "ERROR")}
  if(!"id" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'id'.", "ERROR")}
  if(!"url" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'url'.", "ERROR")}
  if(!"fields" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'fields'.", "ERROR")}
  if(!sel_dataset$dataType == "Layer") {msg(paste0("selected datatype has no fields: ", sel_dataset$dataType))}

  ds_fields <- sel_dataset$fields[[1]]$name

  return(ds_fields)
}
