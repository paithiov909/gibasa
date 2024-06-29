#' Collapse sequences of tokens by condition
#'
#' Concatenates sequences of tokens in the tidy text dataset,
#' while grouping them by an expression.
#'
#' Note that this function drops all columns except but 'token'
#' and columns for grouping sequences. So, the returned data.frame
#' has only 'doc_id', 'sentence_id', 'token_id', and 'token' columns.
#'
#' @param tbl A tidy text dataset.
#' @param condition <[`data-masked`][rlang::args_data_masking]>
#' A logical expression.
#' @param .collapse String with which tokens are concatenated.
#' @returns A data.frame.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = "odakyu-sen",
#'     text = "\u5c0f\u7530\u6025\u7dda"
#'   )
#' ) |>
#'   prettify(col_select = "POS1")
#'
#' collapse_tokens(
#'   df,
#'   POS1 == "\u540d\u8a5e" & stringr::str_detect(token, "^[\\p{Han}]+$")
#' ) |>
#'   head()
#' }
collapse_tokens <- function(tbl,
                            condition,
                            .collapse = "") {
  condition <- enquo(condition)
  tbl %>%
    dplyr::group_by(.data$doc_id, .data$sentence_id) %>%
    dplyr::mutate(
      gbs_flag = dplyr::if_else(!!condition, 0L, .data$token_id),
      token_id = with(rle(.data$gbs_flag), rep(seq_along(values), lengths))
    ) %>%
    dplyr::group_by(.data$doc_id, .data$sentence_id, .data$token_id) %>%
    dplyr::reframe(
      token = .data$token %>%
        stringi::stri_remove_empty_na() %>%
        stringi::stri_c(collapse = .collapse)
    ) %>%
    dplyr::mutate(token = dplyr::na_if(.data$token, ""))
}
