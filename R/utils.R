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
                     into = c(
                       "POS1",
                       "POS2",
                       "POS3",
                       "POS4",
                       "X5StageUse1",
                       "X5StageUse2",
                       "Original",
                       "Yomi1",
                       "Yomi2"
                     )) {
  res <- df %>%
    tidyr::separate(
      col = "feature",
      into = into,
      sep = ",",
      fill = "right"
    ) %>%
    dplyr::mutate_if(is.character, ~ dplyr::na_if(., "*"))
  return(res)
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
