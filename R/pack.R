#' Pack prettified data.frame of tokens
#'
#' @inherit audubon::pack description return details sections seealso
#' @inheritParams audubon::pack
#' @importFrom audubon pack
#' @export
pack <- function(tbl, pull = "token", n = 1L, sep = "-", .collapse = " ") {
  pull <- ensym(pull)
  audubon::pack(tbl, pull, n = n, sep = sep, .collapse = .collapse)
}
