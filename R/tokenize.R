#' Tokenize sentences using 'MeCab'
#'
#' @param x A data.frame like object or a character vector to be tokenized.
#' @param text_field String or symbol; column name where to get texts to be tokenized.
#' @param docid_field String or symbol; column name where to get identifiers of texts.
#' @param sys_dic Character scalar; path to the system dictionary for mecab.
#' Note that the system dictionary is expected to be compiled with UTF-8,
#' not Shift-JIS or other encodings.
#' @param user_dic Character scalar; path to the user dictionary for mecab.
#' @param split Logical. When passed as `TRUE`, the function internally splits the sentences
#' into sub-sentences using \code{stringi::stri_split_boudaries(type = "sentence")}.
#' @param partial Logical. When passed as `TRUE`, activates partial parsing mode.
#' To activate this feature, remember that all spaces at the start and end of
#' the input chunks are already squashed. In particular, trailing spaces
#' of chunks sometimes cause fatal errors.
#' @param mode Character scalar to switch output format.
#' @return A tibble or a named list of tokens.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' )
#' head(df)
#' }
tokenize <- function(x,
                     text_field = "text",
                     docid_field = "doc_id",
                     sys_dic = "",
                     user_dic = "",
                     split = FALSE,
                     partial = FALSE,
                     mode = c("parse", "wakati")) {
  UseMethod("tokenize")
}

#' @export
tokenize.default <- function(x,
                             text_field = "text",
                             docid_field = "doc_id",
                             sys_dic = "",
                             user_dic = "",
                             split = FALSE,
                             partial = FALSE,
                             mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  x <- dplyr::as_tibble(x)

  text_field <- enquo(text_field)
  docid_field <- enquo(docid_field)

  sentence <-
    purrr::set_names(
      dplyr::pull(x, {{ text_field }}) %>% stringi::stri_enc_toutf8(),
      dplyr::pull(x, {{ docid_field }})
    )

  result <- tagger_impl(sentence, sys_dic, user_dic, split, partial)

  # if it's a factor, preserve ordering
  col_names <- rlang::as_name(docid_field)
  if (is.factor(x[[col_names]])) {
    col_u <- levels(x[[col_names]])
  } else {
    col_u <- unique(x[[col_names]])
  }

  tbl <- x %>%
    dplyr::select(-!!text_field) %>%
    dplyr::mutate(dplyr::across(!!docid_field, ~ factor(., col_u))) %>%
    dplyr::rename(doc_id = {{ docid_field }}) %>%
    dplyr::left_join(
      result,
      by = c("doc_id" = "doc_id")
    )

  if (!identical(mode, "wakati")) {
    return(tbl)
  }
  as_tokens(tbl, pos_field = NULL, nm = col_u)
}

#' @export
tokenize.character <- function(x,
                               sys_dic = "",
                               user_dic = "",
                               split = FALSE,
                               partial = FALSE,
                               mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  nm <- names(x)
  if (is.null(nm)) {
    nm <- seq_along(x)
  }
  sentence <- stringi::stri_enc_toutf8(x) %>%
    purrr::set_names(nm)

  tbl <- tagger_impl(sentence, sys_dic, user_dic, split, partial)

  if (!identical(mode, "wakati")) {
    return(tbl)
  }
  as_tokens(tbl, pos_field = NULL, nm = nm)
}

#' @noRd
tagger_impl <- function(sentence, sys_dic, user_dic, split, partial) {
  # check if dictionaries are available.
  sys_dic <- paste0(sys_dic, collapse = "")
  user_dic <- paste0(user_dic, collapse = "")
  if (rlang::is_empty(dictionary_info(sys_dic, user_dic))) {
    rlang::abort(class = "gbs_missing_dict")
  }

  if (isTRUE(split)) {
    res <-
      purrr::imap_dfr(sentence, function(vec, doc_id) {
        vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
          unlist()
        dplyr::bind_cols(
          data.frame(doc_id = doc_id),
          posParallelRcpp(vec, sys_dic, user_dic, partial)
        )
      })
  } else {
    res <-
      posParallelRcpp(sentence, sys_dic, user_dic, partial) %>%
      dplyr::left_join(
        data.frame(
          sentence_id = seq_along(sentence),
          doc_id = names(sentence)
        ),
        by = "sentence_id"
      ) %>%
      dplyr::relocate("doc_id", dplyr::everything())
  }
  res %>%
    dplyr::mutate(dplyr::across(where(is.character), ~ reset_encoding(.))) %>%
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id))) %>%
    dplyr::as_tibble()
}

#' @noRd
reset_encoding <- function(chr) {
  unlist(lapply(chr, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(elem)
  }))
}
