#' Pack a data.frame of tokens
#'
#' Packs a data.frame of tokens into a new data.frame of corpus,
#' which is compatible with the Text Interchange Formats.
#'
#' @section Text Interchange Formats (TIF):
#'
#' The Text Interchange Formats (TIF) is a set of standards
#' that allows R text analysis packages to target defined inputs and outputs
#' for corpora, tokens, and document-term matrices.
#'
#' @section Valid data.frame of tokens:
#'
#' The data.frame of tokens here is a data.frame object
#' compatible with the TIF.
#'
#' A TIF valid data.frame of tokens is expected to have
#' one unique key column (named `doc_id`)
#' of each text and several feature columns of each tokens.
#' The feature columns must contain at least `token` itself.
#'
#' @seealso \url{https://github.com/ropenscilabs/tif}
#'
#' @param tbl A data.frame of tokens.
#' @param pull <[`data-masked`][rlang::args_data_masking]>
#' Column to be packed into text or ngrams body. Default value is `token`.
#' @param n Integer internally passed to ngrams tokenizer function
#' created of \code{gibasa::ngram_tokenizer()}
#' @param sep Character scalar internally used as the concatenator of ngrams.
#' @param .collapse This argument is passed to \code{stringi::stri_c()}.
#' @returns A tibble.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(5:8),
#'     text = ginga[5:8]
#'   )
#' )
#' pack(df)
#' }
pack <- function(tbl, pull = "token", n = 1L, sep = "-", .collapse = " ") {
  pull <- enquo(pull)
  if (n < 2L) {
    tbl %>%
      dplyr::reframe(
        text = .data[[pull]] %>%
          stringi::stri_remove_empty_na() %>%
          stringi::stri_c(collapse = .collapse),
        .by = "doc_id"
      ) %>%
      dplyr::as_tibble()
  } else {
    make_ngram <- ngram_tokenizer(n)
    tbl %>%
      dplyr::reframe(
        text = .data[[pull]] %>%
          stringi::stri_remove_empty_na() %>%
          make_ngram(sep = sep) %>%
          stringi::stri_c(collapse = .collapse),
        .by = "doc_id"
      ) %>%
      dplyr::as_tibble()
  }
}

#' Ngrams tokenizer
#'
#' Makes an ngram tokenizer function.
#'
#' @param n Integer.
#' @returns ngram tokenizer function
#' @export
#' @examples
#' bigram <- ngram_tokenizer(2)
#' bigram(letters, sep = "-")
ngram_tokenizer <- function(n = 1L) {
  stopifnot(is.numeric(n), is.finite(n), n > 0)
  function(tokens, sep = " ") {
    stopifnot(is.character(tokens))
    len <- length(tokens)
    if (all(is.na(tokens)) || len < n) {
      character(0)
    } else {
      sapply(seq_len(max(1, len - n + 1)), function(i) {
        stringi::stri_join(tokens[i:min(len, i + n - 1)], collapse = sep)
      })
    }
  }
}
