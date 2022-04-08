#' Prettify tokenized output
#'
#' @param df Dataframe that comes out of \code{tokenize()}.
#' @param into Character vector that is used as column names of
#' features.
#' @param col_select Character or integer vector that will be kept
#' in prettified result. If `NULL` provided, keeps all features.
#'
#' @return data.frame.
#' @export
#' @examples
#' df <- gbs_tokenize("\u3053\u3093\u306b\u3061\u306f")
#' prettify(df, col_select = 1:3)
#' prettify(df, col_select = c(1, 3, 6))
#' prettify(df, col_select = c("POS1", "Original"))
prettify <- function(df,
                     into = get_dict_features("ipa"),
                     col_select = seq_along(into)) {
  if (is.numeric(col_select) && max(col_select) <= length(into)) {
    col_select <- which(seq_along(into) %in% col_select, arr.ind = TRUE)
  } else {
    col_select <- which(into %in% col_select, arr.ind = TRUE)
  }
  ## TODO: test case
  if (rlang::is_empty(col_select)) {
    rlang::abort("Invalid columns have been selected.")
  }
  suppressWarnings({
    ## ignore warnings when there are missing columns.
    features <-
      c(
        stringi::stri_c(into, collapse = ","),
        dplyr::pull(df, "feature")
      ) %>%
      stringi::stri_c(collapse = "\n") %>%
      I() %>%
      readr::read_csv(
        col_types = stringi::stri_c(rep("c", length(into)), collapse = ""),
        col_select = tidyselect::all_of(col_select),
        na = c("*"),
        progress = FALSE,
        show_col_types = FALSE
      )
  })
  dplyr::bind_cols(
    dplyr::select(df, !.data$feature),
    dplyr::rename_with(features, ~ purrr::set_names(into, into)[col_select])
  )
}

#' Get features of dictionary
#'
#' Returns features of dictionary.
#' Currently supports "unidic17" (2.1.2 src schema), "unidic26" (2.1.2 bin schema),
#' "unidic29" (schema used in 2.2.0, 2.3.0), "cc-cedict", "ko-dic" (mecab-ko-dic),
#' and "ipa".
#'
#' @seealso See also
#' \href{https://ccd.ninjal.ac.jp/unidic/}{UniDic},
#' \href{https://github.com/ueda-keisuke/CC-CEDICT-MeCab}{CC-CEDICT-MeCab},
#' and \href{https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/}{mecab-ko-dic}.
#' @param dict Character scalar; one of "ipa", "unidic17", "unidic26", "unidic29",
#' "cc-cedict", or "ko-dic".
#' @return A character vector.
#' @export
get_dict_features <- function(dict = c(
                                "ipa",
                                "unidic17",
                                "unidic26",
                                "unidic29",
                                "cc-cedict",
                                "ko-dic"
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
    dict == "cc-cedict" ~ list(c(
      "POS1", "POS2", "POS3", "POS4",
      "pinyin_pron", "traditional_char_form", "simplified_char_form",
      "definition"
    )),
    dict == "ko-dic" ~ list(c(
      "POS", "meaning", "presence", "reading", "type", "first_pos", "last_pos", "expression"
    )),
    TRUE ~ list(c("POS1", "POS2", "POS3", "POS4", "X5StageUse1", "X5StageUse2", "Original", "Yomi1", "Yomi2"))
  )
  unlist(feat)
}

#' Pack prettified data.frame of tokens
#'
#' @inherit audubon::pack description return details sections seealso
#' @inheritParams audubon::pack
#' @importFrom audubon pack
#' @export
pack <- audubon::pack
