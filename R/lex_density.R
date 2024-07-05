#' Calculate lexical density
#'
#' The lexical density is the proportion of content words (lexical items)
#' in documents. This function is a simple helper for calculating
#' the lexical density of given datasets.
#'
#' @param vec A character vector.
#' @param contents_words A character vector containing values
#' to be counted as contents words.
#' @param targets A character vector with which
#' the denominator of lexical density is filtered before computing values.
#' @param negate A logical vector of which length is 2.
#' If passed as `TRUE`, then respectively negates the predicate functions
#' for counting contents words or targets.
#' @returns A numeric vector.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(5:8),
#'     text = ginga[5:8]
#'   )
#' )
#' df |>
#'   prettify(col_select = "POS1") |>
#'   dplyr::group_by(doc_id) |>
#'   dplyr::summarise(
#'     noun_ratio = lex_density(POS1,
#'       "\u540d\u8a5e",
#'       c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"),
#'       negate = c(FALSE, TRUE)
#'     ),
#'     mvr = lex_density(
#'       POS1,
#'       c("\u5f62\u5bb9\u8a5e", "\u526f\u8a5e", "\u9023\u4f53\u8a5e"),
#'       "\u52d5\u8a5e"
#'     ),
#'     vnr = lex_density(POS1, "\u52d5\u8a5e", "\u540d\u8a5e")
#'   )
#' }
lex_density <- function(vec,
                        contents_words,
                        targets = NULL,
                        negate = c(FALSE, FALSE)) {
  if (!rlang::has_length(negate, 2L)) {
    rlang::abort("The negate must have just 2 elements.")
  }

  if (isTRUE(negate[1])) {
    num_of_contents <- length(subset(vec, !vec %in% contents_words))
  } else {
    num_of_contents <- length(subset(vec, vec %in% contents_words))
  }
  if (!is.null(targets)) {
    if (isTRUE(negate[2])) {
      vec <- subset(vec, !vec %in% targets)
    } else {
      vec <- subset(vec, vec %in% targets)
    }
  }
  num_of_totals <- length(vec)

  num_of_contents / num_of_totals
}
