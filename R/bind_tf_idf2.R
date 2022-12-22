#' Bind the term frequency and inverse document frequency
#'
#' @inherit audubon::bind_tf_idf2 description return details
#' @inheritParams audubon::bind_tf_idf2
#' @importFrom audubon bind_tf_idf2
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' ) |>
#'   dplyr::group_by(doc_id) |>
#'   dplyr::count(token) |>
#'   dplyr::ungroup()
#' bind_tf_idf2(df)
#' }
bind_tf_idf2 <- audubon::bind_tf_idf2
