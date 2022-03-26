#' Prettify tokenized output
#'
#' @param df Dataframe that comes out of \code{tokenize()}.
#' @param into Character vector that is used as column names of
#' features.
#'
#' @return data.frame.
#'
#' @export
prettify <- function(df,
                     into = get_dict_features("ipa")) {
  df %>%
    dplyr::mutate(
      feature = .data$feature %>%
        stringi::stri_replace_all_regex("\\\"", "") %>%
        stringi::stri_replace_all_regex("(\\d+),", "$1 ")
    ) %>%
    tidyr::separate(
      col = "feature",
      into = into,
      sep = ",",
      fill = "right"
    ) %>%
    dplyr::mutate_if(is.character, ~ dplyr::na_if(., "*"))
}

#' Get features of dictionary
#'
#' Returns features of dictionary.
#' Currently supports "unidic17" (2.1.2 src schema), "unidic26" (2.1.2 bin schema),
#' "unidic29" (schema used in 2.2.0, 2.3.0), and "ipa".
#'
#' @param dict String; one of "ipa", "unidic17", "unidic26" or "unidic29".
#' @return A character vector.
#' @export
get_dict_features <- function(dict = c(
                                "ipa",
                                "unidic17",
                                "unidic26",
                                "unidic29"
                              )) {
  dict <- rlang::arg_match(dict)
  feat <- dplyr::case_when(
    dict == "unidic17" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType", "cForm", "lForm",
      "lemma", "orth", "pron",
      "orthBase", "pronBase", "goshu", "iType", "iForm", "fType", "fForm"
    )),
    dict == "unidic26" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType", "cForm", "lForm", "lemma", "orth", "pron",
      "orthBase", "pronBase", "goshu", "iType", "iForm", "fType", "fForm",
      "kana", "kanaBase", "form", "formBase", "iConType", "fConType", "aType",
      "aConType", "aModeType"
    )),
    dict == "unidic29" ~ list(c(
      "POS1", "POS2", "POS3", "POS4", "cType",
      "cForm", "lForm", "lemma", "orth", "pron", "orthBase", "pronBase", "goshu", "iType", "iForm", "fType",
      "fForm", "iConType", "fConType", "type", "kana", "kanaBase", "form", "formBase", "aType", "aConType",
      "aModType", "lid", "lemma_id"
    )),
    TRUE ~ list(c("POS1", "POS2", "POS3", "POS4", "X5StageUse1", "X5StageUse2", "Original", "Yomi1", "Yomi2"))
  )
  unlist(feat)
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @importFrom dplyr %>%
#' @export
#' @usage lhs \%>\% rhs
NULL

#' Pack prettified data.frame of tokens
#'
#' @inherit audubon::pack description return details sections seealso
#' @inheritParams audubon::pack
#' @export
pack <- function(df, n = 1L, pull = "token", sep = "-", .collapse = " ") {
  audubon::pack(df, n, pull = pull, sep = sep, .collapse = .collapse)
}
