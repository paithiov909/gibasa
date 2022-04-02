#' An alternative of RMeCabC
#'
#' @param tbl A prettified data.frame of tokenized sentences.
#' @param pull A column name of `df`.
#' @param names A column name of `df`.
#' @return A list of named vectors.
#' @export
gbs_c <- function(tbl, pull = "token", names = "POS1") {
  tbl %>%
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
#' @export
gbs_as_tokens <- function(tbl, pull = "token", n = 1L, sep = "-", what = "fastestword", ...) {
  tbl %>%
    pack(pull = pull, n = n, sep = sep) %>%
    quanteda::corpus() %>%
    quanteda::tokens(what = what, ...)
}

#' Cast prettified output as quanteda dfm
#'
#' Create a sparse document-feature matrix.
#' This function is a shorthand of
#' \code{gibasa::gbs_as_tokens()} and then \code{quatenda::dfm()}.
#'
#' @inheritParams gbs_as_tokens
#' @returns A quanteda 'dfm' object.
#' @export
gbs_dfm <- function(tbl, pull = "token", n = 1L, sep = "-", what = "fastestword", ...) {
  tbl %>%
    gbs_as_tokens(pull = pull, n = n, sep = sep, what = what, ...) %>%
    quanteda::dfm()
}
