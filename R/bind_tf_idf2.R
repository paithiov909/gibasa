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
bind_tf_idf2 <- function(tbl,
                         term = "token",
                         document = "doc_id",
                         n = "n",
                         tf = c("tf", "tf2", "tf3"),
                         idf = c("idf", "idf2", "idf3", "idf4"),
                         norm = FALSE,
                         rmecab_compat = TRUE) {
  term <- enquo(term)
  document <- enquo(document)
  n_col <- enquo(n)

  audubon::bind_tf_idf2(
    tbl = tbl,
    term = {{ term }},
    document = {{ document }},
    n = {{ n_col }},
    tf = tf,
    idf = idf,
    norm = norm,
    rmecab_compat = rmecab_compat
  )
}
