#' Tokenize sentence for character vector
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
    sys_dic = sys_dic,
    user_dic = user_dic,
    split = split,
    partial = partial,
    mode = mode
  )
}
