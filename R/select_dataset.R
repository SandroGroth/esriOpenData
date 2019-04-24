#' Selects a dataset from a search_dataset response.
#'
#' @param dataset_df
#' @param id
#'
#' @keywords select_dataset
#' @export

select_dataset <- function(dataset_df, id) {
  if(!is.data.frame(dataset_df)) {msg("dataset_df has to be of type data.frame", "ERROR")}
  if(!is.numeric(id)) {msg("id has to be of type numeric.", "ERROR")}

  sel_row <- dataset_df[id, ]

  if(!"public" %in% colnames(sel_row)) {msg("dataset_df does not contain a col 'public'.", "ERROR")}
  if(!"url" %in% colnames(sel_row)) {msg("dataset_df does not contain a col 'url'.", "ERROR")}
  if(!isTRUE(sel_row$public)) {msg("Item is not publically available.", "ERROR")} # TODO: Add an signin option.

  return(sel_row)

}
