#' Bind importance of bigrams
#'
#' Calculates and binds the importance of bigrams and their synergistic average.
#'
#' @details
#' The 'LR' value is the synergistic average of bigram importance
#' that based on the words and their positions (left or right side).
#'
#' @seealso \doi{10.5715/jnlp.10.27}
#'
#' @param tbl A tidy text dataset.
#' @param term <[`data-masked`][rlang::args_data_masking]>
#' Column containing terms.
#' @param lr_mode Method for computing 'FL' and 'FR' values.
#' `n` is equivalent to 'LN' and 'RN',
#' and `dn` is equivalent to 'LDN' and 'RDN'.
#' @param avg_rate Weight of the 'LR' value.
#' @returns A data.frame.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(5:8),
#'     text = ginga[5:8]
#'   )
#' )
#' bind_lr(df) |>
#'   head()
#' }
bind_lr <- function(tbl,
                    term = "token",
                    lr_mode = c("n", "dn"),
                    avg_rate = 1.0) {
  lr_mode <- rlang::arg_match(lr_mode)
  term <- as_name(enquo(term))

  tbl <-
    dplyr::ungroup(tbl) %>%
    dplyr::mutate(
      ltoken = .data[[term]],
      rtoken = dplyr::lead(.data$ltoken, default = NA_character_),
      .by = "doc_id"
    )
  fl <-
    switch(lr_mode,
      n = tbl %>%
        dplyr::summarize(n = dplyr::n(), .by = "ltoken") %>%
        dplyr::pull("n", "ltoken"),
      dn = tbl %>%
        dplyr::summarize(dn = length(unique(.data$rtoken)), .by = "ltoken") %>%
        dplyr::pull("dn", "ltoken")
    )
  fr <-
    switch(lr_mode,
      n = tbl %>%
        dplyr::summarize(n = dplyr::n(), .by = "rtoken") %>%
        dplyr::pull("n", "rtoken"),
      dn = tbl %>%
        dplyr::summarize(dn = length(unique(.data$ltoken)), .by = "rtoken") %>%
        dplyr::pull("dn", "rtoken")
    )

  dplyr::mutate(tbl,
    fl = as.integer(fl[.data$ltoken] + 1),
    fr = as.integer(fr[.data$rtoken] + 1),
    fl = dplyr::if_else(is.na(.data$fl), 1, .data$fl),
    fr = dplyr::if_else(is.na(.data$fr), 1, .data$fr),
    lr = (.data$fl * .data$fr)^(1 / (avg_rate * 2))
  )
}
