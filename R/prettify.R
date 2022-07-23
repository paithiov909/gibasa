#' Prettify tokenized output
#'
#' @inherit audubon::prettify description return details
#' @inheritParams audubon::prettify
#' @importFrom audubon prettify
#' @export
#' @examples
#' df <- gbs_tokenize("\u3053\u3093\u306b\u3061\u306f")
#' prettify(df, col_select = 1:3)
#' prettify(df, col_select = c(1, 3, 6))
#' prettify(df, col_select = c("POS1", "Original"))
prettify <- function(df,
                     into = get_dict_features("ipa"),
                     col_select = seq_along(into)) {
  audubon::prettify(df, into, col_select)
}

#' Get dictionary's features
#'
#' @inherit audubon::get_dict_features description return details seealso
#' @inheritParams audubon::get_dict_features
#' @importFrom audubon get_dict_features
#' @export
get_dict_features <- audubon::get_dict_features
