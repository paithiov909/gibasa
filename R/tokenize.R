#' Tokenize sentence for character vector
#'
#' @param sentence Character vector.
#' @param sys_dic Character scalar; path to the system dictionary for mecab.
#' Note that the system dictionary is expected to be compiled with UTF-8,
#' not Shift-JIS or other encodings.
#' @param user_dic Character scalar; path to the user dictionary for mecab.
#' @param split Logical. If true, the function internally split the sentence
#' into sub-sentences using \code{stringi::stri_split_boudaries(type = "sentence")}.
#' @param mode Character scalar to switch output format.
#' @return data.frame or named list.
#' @export
#' @examples
#' df <- gbs_tokenize("\u3053\u3093\u306b\u3061\u306f")
#' head(df)
gbs_tokenize <- function(sentence,
                         sys_dic = "",
                         user_dic = "",
                         split = FALSE,
                         mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  # keep names
  nm <- names(sentence)
  if (is.null(nm)) {
    nm <- seq_along(sentence)
  }
  sentence <- stringi::stri_enc_toutf8(sentence) %>%
    purrr::set_names(nm)

  sys_dic <- paste0(sys_dic, collapse = "")
  user_dic <- paste0(user_dic, collapse = "")

  result <-
    purrr::imap_dfr(sentence, function(vec, doc_id) {
      if (identical(split, TRUE)) {
        vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
          unlist()
      }
      dplyr::bind_cols(
        data.frame(doc_id = doc_id),
        posParallelRcpp(vec, sys_dic, user_dic)
      )
    }) %>%
    dplyr::mutate_if(is.character, ~ reset_encoding(.)) %>%
    dplyr::mutate_if(is.character, ~ dplyr::na_if(., "*")) %>%
    dplyr::mutate(
      doc_id = as.factor(.data$doc_id),
      sentence_id = as.factor(.data$sentence_id)
    )

  if (identical(mode, "wakati")) {
    result <- result %>%
      dplyr::group_by(.data$doc_id) %>%
      dplyr::group_map(~ .x$token) %>%
      purrr::set_names(nm)
  }
  return(result)
}

#' Tokenize sentence for data.frame
#'
#' @param tbl A data.frame.
#' @param text_field String or symbol; column name where to get texts.
#' @param docid_field String or symbol; column name where to get identifiers of texts.
#' @inheritParams gbs_tokenize
#' @return data.frame.
#' @export
#' @examples
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_len(length(audubon::polano[5:8])),
#'     text = audubon::polano[5:8]
#'   )
#' )
#' head(df)
tokenize <- function(tbl,
                     text_field = "text",
                     docid_field = "doc_id",
                     sys_dic = "",
                     user_dic = "",
                     split = FALSE) {
  text_field <- rlang::enquo(text_field)
  docid_field <- rlang::enquo(docid_field)

  sentence <-
    purrr::set_names(
      dplyr::pull(tbl, {{ text_field }}) %>% stringi::stri_enc_toutf8(),
      dplyr::pull(tbl, {{ docid_field }})
    )
  sys_dic <- paste0(sys_dic, collapse = "")
  user_dic <- paste0(user_dic, collapse = "")

  result <-
    purrr::imap_dfr(sentence, function(vec, doc_id) {
      if (identical(split, TRUE)) {
        vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
          unlist()
      }
      dplyr::bind_cols(
        data.frame(doc_id = doc_id),
        posParallelRcpp(vec, sys_dic, user_dic)
      )
    }) %>%
    dplyr::mutate_if(is.character, ~ reset_encoding(.)) %>%
    dplyr::mutate_if(is.character, ~ dplyr::na_if(., "*")) %>%
    dplyr::mutate(
      doc_id = as.factor(.data$doc_id),
      sentence_id = as.factor(.data$sentence_id)
    )

  tbl %>%
    dplyr::select(-!!text_field) %>%
    dplyr::mutate(dplyr::across(!!docid_field, ~ as.factor(.))) %>%
    dplyr::rename(doc_id = {{ docid_field }}) %>%
    dplyr::left_join(
      result,
      by = c("doc_id" = "doc_id")
    )
}

#' @noRd
reset_encoding <- function(chr) {
  unlist(lapply(chr, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(elem)
  }))
}
