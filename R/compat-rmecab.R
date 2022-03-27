#' Gibasa functions family
#'
#' These functions are compact RMeCab alternatives
#' based on \href{https://quanteda.io/}{quanteda}.
#'
#' @seealso gbs_c, gbs_as_tokens, gbs_dfm
#' @rdname gibasa
#' @name gbs
#' @keywords internal
NULL

#' An alternative of RMeCabC
#'
#' @param df A prettified data.frame of tokenized sentences.
#' @param pull A column name of `df`.
#' @param names A column name of `df`.
#' @return A list of named vectors.
#' @family gbs
#' @export
gbs_c <- function(df, pull = "token", names = "POS1") {
  df %>%
    dplyr::group_by(.data$doc_id) %>%
    dplyr::group_map(function(.x, .y) {
      purrr::set_names(dplyr::pull(.x, {{ pull }}), dplyr::pull(.x, {{ names }}))
    })
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
  df %>%
    pack(pull = pull, n = n, sep = sep) %>%
    quanteda::corpus() %>%
    quanteda::tokens(what = what, ...)
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
  df %>%
    gbs_as_tokens(pull = pull, n = n, sep = sep, what = what, ...) %>%
    quanteda::dfm()
}
