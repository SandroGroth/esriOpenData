#' Returns the field names of a selected dataset.
#'
#' @param sel_dataset
#'
#' @keywords fields
#' @export

fields <- function(sel_dataset){
  if(!is.data.frame(sel_dataset)) {msg("sel_dataset has to be of type data.frame.", "ERROR")}
  if(!"id" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'id'.", "ERROR")}
  if(!"url" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'url'.", "ERROR")}
  if(!"fields" %in% colnames(sel_dataset)) {msg("sel_dataset has no column 'fields'.", "ERROR")}

  ds_fields <- sel_dataset$fields[[1]]$name

  return(ds_fields)
}
