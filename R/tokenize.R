#' Tokenize sentence
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
#'
#' @export
tokenize <- function(sentence,
                     sys_dic = "",
                     user_dic = "",
                     split = FALSE,
                     mode = c("parse", "wakati")) {
  mode <- rlang::arg_match(mode, c("parse", "wakati"))

  # keep names
  nm <- names(sentence)
  if (identical(nm, NULL)) {
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

#' @noRd
reset_encoding <- function(chr) {
  unlist(lapply(chr, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(elem)
  }))
}

#' Alias of `tokenize`
#' @inherit tokenize
#' @export
gbs_tokenize <- tokenize
