#' Pack prettified data.frame of tokens
#'
#' @inherit audubon::pack description return details sections seealso
#' @inheritParams audubon::pack
#' @importFrom audubon pack
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' )
#' pack(df)
#' }
pack <- function(tbl, pull = "token", n = 1L, sep = "-", .collapse = " ") {
  pull <- ensym(pull)
  audubon::pack(tbl, pull, n = n, sep = sep, .collapse = .collapse)
}
