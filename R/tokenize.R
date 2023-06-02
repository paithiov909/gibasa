#' Tokenize sentences using 'MeCab'
#'
#' @param x A data.frame like object or a character vector to be tokenized.
#' @param text_field <[`data-masked`][rlang::args_data_masking]>
#' String or symbol; column name where to get texts to be tokenized.
#' @param docid_field <[`data-masked`][rlang::args_data_masking]>
#' String or symbol; column name where to get identifiers of texts.
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
#' @param grain_size Integer value larger than 1.
#' This argument is internally passed to `RcppParallel::parallelFor` function.
#' Setting a larger chunk size could improve the performance in some cases.
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
                     grain_size = 1L,
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
                             grain_size = 1L,
                             mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  x <- dplyr::as_tibble(x)

  text_field <- enquo(text_field)
  docid_field <- enquo(docid_field)

  result <- tagger_impl(
    dplyr::pull(x, {{ text_field }}),
    dplyr::pull(x, {{ docid_field }}),
    sys_dic, user_dic, split, partial, grain_size
  )

  # if it's a factor, preserve ordering
  col_names <- as_name(docid_field)
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
                               text_field = "text",
                               docid_field = "doc_id",
                               sys_dic = "",
                               user_dic = "",
                               split = FALSE,
                               partial = FALSE,
                               grain_size = 1L,
                               mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  nm <- names(x)
  if (is.null(nm)) {
    nm <- seq_along(x)
  }

  tbl <- tagger_impl(x, nm, sys_dic, user_dic, split, partial, grain_size)

  if (!identical(mode, "wakati")) {
    return(tbl)
  }
  as_tokens(tbl, pos_field = NULL, nm = nm)
}

#' @noRd
tagger_impl <- function(sentences,
                        docnames,
                        sys_dic,
                        user_dic,
                        split,
                        partial,
                        grain_size) {
  # check if dictionaries are available.
  if (rlang::is_empty(dictionary_info(sys_dic, user_dic))) {
    rlang::abort("Can't find dictionaries.", class = "gbs_missing_dict")
  }

  grain_size <- ifelse(grain_size > 0L, as.integer(grain_size), 1L)

  if (isTRUE(split)) {
    res <-
      lapply(seq_along(sentences), function(i) {
        vec <- stringi::stri_split_boundaries(sentences[i], type = "sentence") %>%
          unlist()
        dplyr::bind_cols(
          data.frame(doc_id = docnames[i]),
          posParallelRcpp(vec, sys_dic, user_dic, partial, grain_size)
        )
      }) %>%
      purrr::list_rbind()
  } else {
    res <-
      posParallelRcpp(sentences, sys_dic, user_dic, partial, grain_size) %>%
      dplyr::left_join(
        data.frame(
          sentence_id = seq_along(sentences),
          doc_id = docnames
        ),
        by = "sentence_id"
      ) %>%
      dplyr::relocate("doc_id", dplyr::everything())
  }
  res %>%
    dplyr::mutate(doc_id = factor(.data$doc_id, unique(.data$doc_id))) %>%
    dplyr::as_tibble()
}
