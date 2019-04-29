#' Select a dataset
#'
#' \code{select_dataset} selects one specific dataset from the search result retrieved by
#' search_datasets().
#'
#' @param dataset_df Dataframe, output of search_datasets().
#' @param id row id of desired dataset, e.g. 1 represent first dataset of search results.
#'
#' @return Dataframe, containing only the selected dataset information.
#'
#' @examples
#' datasets <- search_datasets("Climate", aoi = T)
#' selected <- select_dataset(datasets, 12)
#'
#' @author Sandro Groth
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
