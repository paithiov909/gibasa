### partial port from juliasilge/tidytext ---
cast_sparse <- function(data, row, column, value, ...) {
  row_col <- as_name(enquo(row))
  column_col <- as_name(enquo(column))
  value_col <- enquo(value)
  if (rlang::quo_is_missing(value_col)) {
    value_col <- 1
  }
  data <- dplyr::ungroup(data)
  data <- dplyr::distinct(data, !!sym(row_col), !!sym(column_col), .keep_all = TRUE)
  row_names <- dplyr::pull(data, row_col)
  col_names <- dplyr::pull(data, column_col)
  if (is.numeric(value_col)) {
    values <- value_col
  } else {
    value_col <- as_name(value_col)
    values <- dplyr::pull(data, value_col)
  }

  # if it's a factor, preserve ordering
  if (is.factor(row_names)) {
    row_u <- levels(row_names)
    i <- as.integer(row_names)
  } else {
    row_u <- unique(row_names)
    i <- match(row_names, row_u)
  }

  if (is.factor(col_names)) {
    col_u <- levels(col_names)
    j <- as.integer(col_names)
  } else {
    col_u <- unique(col_names)
    j <- match(col_names, col_u)
  }

  ret <- Matrix::sparseMatrix(
    i = i, j = j, x = values,
    dimnames = list(row_u, col_u), ...
  )

  ret
}

#### END ---

booled_freq <- function(v) {
  as.numeric(v > 0)
}

count_nnzero <- function(sp) {
  if (requireNamespace("sparseMatrixStats", quietly = TRUE)) {
    nrow(sp) - sparseMatrixStats::colCounts(sp, value = 0)
  } else {
    sapply(seq_len(ncol(sp)), function(col) {
      Matrix::nnzero(sp[, col])
    })
  }
}
# inverse document frequency smooth
global_idf <- function(sp) {
  purrr::set_names(log2(nrow(sp) / count_nnzero(sp)) + 1, colnames(sp))
}

# global frequency idf
global_idf2 <- function(sp) {
  Matrix::colSums(sp, na.rm = TRUE) / count_nnzero(sp)
}

# probabilistic idf
global_idf3 <- function(sp) {
  df <- count_nnzero(sp)
  purrr::set_names(log2(nrow(sp - df) / df), colnames(sp))
}

# entropy
global_entropy <- function(sp) {
  pj <- Matrix::t(sp) / Matrix::colSums(sp, na.rm = TRUE)
  ndocs <- nrow(sp)
  1 + (Matrix::rowSums((pj * log(pj)), na.rm = TRUE) / log(ndocs))
}

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
  tf <- rlang::arg_match(tf)
  idf <- rlang::arg_match(idf)

  term <- as_name(ensym(term))
  document <- as_name(ensym(document))
  n_col <- as_name(ensym(n))

  tbl <- dplyr::ungroup(tbl)

  terms <- as.character(dplyr::pull(tbl, term))
  documents <- as.character(dplyr::pull(tbl, document))
  n <- dplyr::pull(tbl, n_col)

  doc_totals <- tapply(
    n, documents,
    function(x) {
      switch(tf,
        tf = sum(x),
        tf2 = log(x + 1),
        tf3 = booled_freq(x)
      )
    }
  )
  if (identical(tf, "tf")) {
    tbl <- dplyr::mutate(tbl, tf = .data$n / as.numeric(doc_totals[documents]))
  } else {
    tbl <- dplyr::mutate(tbl, tf = purrr::flatten_dbl(doc_totals))
  }

  if (isTRUE(rmecab_compat)) {
    sp <- cast_sparse(tbl, !!document, !!term, "tf")
  } else {
    sp <- cast_sparse(tbl, !!document, !!term, !!n_col)
  }

  if (isTRUE(norm)) {
    sp <- Matrix::t(Matrix::t(sp) * (1 / sqrt(Matrix::rowSums((sp * sp)))))
  }
  idf <- switch(idf,
    idf = global_idf(sp),
    idf2 = global_idf2(sp),
    idf3 = global_idf3(sp),
    idf4 = global_entropy(sp)
  )
  tbl <- dplyr::mutate(tbl,
    idf = as.numeric(idf[terms]),
    tf_idf = .data$tf * .data$idf
  )

  tbl
}
