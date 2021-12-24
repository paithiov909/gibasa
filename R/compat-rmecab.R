#' Gibasa functions family
#'
#' These functions are compact RMeCab alternatives
#' based on \href{https://quanteda.io/}{quanteda}.
#'
#' @seealso gbs_freq, gbs_c, gbs_as_tokens, gbs_dfm, gbs_collocate
#' @rdname gibasa
#' @name gbs
#' @keywords internal
NULL

#' An alternative of RMeCabFreq
#'
#' @param df A prettified data.frame of tokenized sentences.
#' @param ... Other arguments are passed to \code{dplyr::tally()}.
#' @param .name_repair Logical:
#' If true, then rename the column names as RMeCabFreq-compatible style.
#' @returns A data.frame.
#' @family gbs
#' @export
gbs_freq <- function(df, ..., .name_repair = TRUE) {
  df <- df %>%
    dplyr::group_by(.data$token, .data$POS1, .data$POS2) %>%
    dplyr::tally(...) %>%
    dplyr::ungroup()
  if (.name_repair) {
    df <-
      dplyr::rename(
        df,
        Term = .data$token,
        Info1 = .data$POS1,
        Info2 = .data$POS2,
        Freq = .data$n
      )
  }
  return(df)
}

#' An alternative of RMeCabC
#'
#' @param df A prettified data.frame of tokenized sentences.
#' @param pull A column name of `df`.
#' @param names A column name of `df`.
#' @return A list of named vectors.
#' @family gbs
#' @export
gbs_c <- function(df, pull = c("token", "Original"), names = "POS1") {
  pull <- rlang::arg_match(pull)
  re <- df %>%
    dplyr::group_by(.data$doc_id) %>%
    dplyr::group_map(function(.x, .y) {
      purrr::set_names(dplyr::pull(.x, {{ pull }}), dplyr::pull(.x, {{ names }}))
    })
  return(re)
}

#' Pack prettified output as quanteda tokens
#'
#' @inheritParams pack
#' @param what Character scalar; which tokenizer to use in \code{quanteda::tokens()}.
#' @param ... Other arguments are passed to \code{quanteda::tokens()}.
#' @return A quanteda 'token' class object.
#' @family gbs
#' @export
gbs_as_tokens <- function(df, pull = "token", n = 1L, sep = "-", what = "fastestword", ...) {
  df <-
    pack(df, pull = pull, n = n, sep = sep) %>%
    quanteda::corpus() %>%
    quanteda::tokens(what = what, ...)
  return(df)
}

#' An alternative of docDF family
#'
#' Create a sparse document-feature matrix.
#' This function is a shorthand of
#' \code{gibasa::gbs_as_tokens()} and then \code{quatenda::dfm()}.
#'
#' @inheritParams gbs_as_tokens
#' @returns A quanteda 'dfm' object.
#' @family gbs
#' @export
gbs_dfm <- function(df, pull = "token", n = 1L, sep = "-", what = "fastestword", ...) {
  res <-
    gbs_as_tokens(df, pull = pull, n = n, sep = sep, what = what, ...) %>%
    quanteda::dfm()
  return(res)
}
