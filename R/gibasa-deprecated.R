#' Tokenize sentences using 'MeCab'
#'
#' @inherit tokenize return
#' @inheritParams tokenize
#' @export
gbs_tokenize <- function(x,
                         sys_dic = "",
                         user_dic = "",
                         split = FALSE,
                         partial = FALSE,
                         mode = c("parse", "wakati")) {
  .Deprecated("tokenize", package = "gibasa")
  tokenize(
    x,
    text_field = "text",
    docid_field = "doc_id",
    sys_dic = sys_dic,
    user_dic = user_dic,
    split = split,
    partial = partial,
    mode = mode
  )
}
