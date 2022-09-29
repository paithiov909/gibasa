#' Calculate lexical density
#'
#' @param vec A character vector.
#' @param contents_words A character vector containing values
#' to be counted as contents words.
#' @param targets A character vector with which
#' the denominator of lexical density is filtered before computing values.
#' @param negate A logical vector of which length is 2.
#' If supplied `TRUE`, then respectively negates the predicate functions
#' for counting contents words or targets.
#' @return numeric vector.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
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
#'     mvr = lex_density(POS1,
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
  num_of_contents <-
    length(purrr::keep(vec, ~
      ifelse(isTRUE(negate[1]), !.x %in% contents_words, .x %in% contents_words)))
  if (!missing(targets)) {
    vec <- purrr::keep(vec, ~
      ifelse(isTRUE(negate[2]), !.x %in% targets, .x %in% targets))
  }
  num_of_totals <- length(vec)

  # FIXME: this result may produce NaN (for instance, when 0 / 0).
  num_of_contents / num_of_totals
}
