#' Mute tokens by condition
#'
#' Replaces tokens in the tidy text dataset with a string scalar
#' only if they are matched to an expression.
#'
#' @param tbl A tidy text dataset.
#' @param condition <[`data-masked`][rlang::args_data_masking]>
#' A logical expression.
#' @param .as String with which tokens are replaced
#' when they are matched to condition.
#' The default value is `NA_character`.
#' @returns A data.frame.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(5:8),
#'     text = ginga[5:8]
#'   )
#' ) |>
#'   prettify(col_select = "POS1")
#'
#' mute_tokens(df, POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e")) |>
#'   head()
#' }
mute_tokens <- function(tbl,
                        condition,
                        .as = NA_character_) {
  condition <- enquo(condition)
  dplyr::mutate(tbl, token = dplyr::if_else(!!condition, .as, .data$token))
}
