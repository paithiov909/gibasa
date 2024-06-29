cast_sparse <- function(data, row, column, value, ...) {
  row_col <- as_name(enquo(row))
  column_col <- as_name(enquo(column))
  value_col <- enquo(value)
  if (rlang::quo_is_missing(value_col)) {
    value_col <- 1
  }

  data <- dplyr::ungroup(data) %>%
    dplyr::distinct(!!sym(row_col), !!sym(column_col), .keep_all = TRUE)

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


count_nnzero <- function(sp) {
  Matrix::colSums((sp > 0) * 1, na.rm = TRUE)
}

booled_freq <- function(v) {
  as.numeric(v > 0)
}

global_df <- function(sp) {
  purrr::set_names(count_nnzero(sp) / nrow(sp), colnames(sp))
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
  purrr::set_names(log2((nrow(sp) - df) / df), colnames(sp))
}

# entropy
global_entropy <- function(sp) {
  pj <- Matrix::t(sp) / Matrix::colSums(sp, na.rm = TRUE)
  ndocs <- nrow(sp)
  1 + (Matrix::rowSums((pj * log(pj)), na.rm = TRUE) / log(ndocs))
}

#' Bind term frequency and inverse document frequency
#'
#' Calculates and binds the term frequency, inverse document frequency,
#' and TF-IDF of the dataset.
#' This function experimentally supports 4 types of term frequencies
#' and 5 types of inverse document frequencies.
#'
#' @details
#' Types of term frequency can be switched with `tf` argument:
#' * `tf` is term frequency (not raw count of terms).
#' * `tf2` is logarithmic term frequency of which base is `exp(1)`.
#' * `tf3` is binary-weighted term frequency.
#' * `itf` is inverse term frequency. Use with `idf="df"`.
#'
#' Types of inverse document frequencies can be switched with `idf` argument:
#' * `idf` is inverse document frequency of which base is 2, with smoothed.
#' 'smoothed' here means just adding 1 to raw values after logarithmizing.
#' * `idf2` is global frequency IDF.
#' * `idf3` is probabilistic IDF of which base is 2.
#' * `idf4` is global entropy, not IDF in actual.
#' * `df` is document frequency. Use with `tf="itf"`.
#'
#' @param tbl A tidy text dataset.
#' @param term <[`data-masked`][rlang::args_data_masking]>
#' Column containing terms.
#' @param document <[`data-masked`][rlang::args_data_masking]>
#' Column containing document IDs.
#' @param n <[`data-masked`][rlang::args_data_masking]>
#' Column containing document-term counts.
#' @param tf Method for computing term frequency.
#' @param idf Method for computing inverse document frequency.
#' @param norm Logical; If passed as `TRUE`, TF-IDF values are normalized
#' being divided with L2 norms.
#' @param rmecab_compat Logical; If passed as `TRUE`, computes values while
#' taking care of compatibility with 'RMeCab'.
#' Note that 'RMeCab' always computes IDF values using term frequency
#' rather than raw term counts, and thus TF-IDF values may be
#' doubly affected by term frequency.
#' @returns A data.frame.
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(5:8),
#'     text = ginga[5:8]
#'   )
#' ) |>
#'   dplyr::group_by(doc_id) |>
#'   dplyr::count(token) |>
#'   dplyr::ungroup()
#' bind_tf_idf2(df) |>
#'   head()
#' }
bind_tf_idf2 <- function(tbl,
                         term = "token",
                         document = "doc_id",
                         n = "n",
                         tf = c("tf", "tf2", "tf3", "itf"),
                         idf = c("idf", "idf2", "idf3", "idf4", "df"),
                         norm = FALSE,
                         rmecab_compat = TRUE) {
  tf <- rlang::arg_match(tf)
  idf <- rlang::arg_match(idf)

  term <- enquo(term)
  document <- enquo(document)
  n_col <- enquo(n)

  tbl <- dplyr::ungroup(tbl)

  terms <- as.character(dplyr::pull(tbl, {{ term }}))
  documents <- as.character(dplyr::pull(tbl, {{ document }}))
  n <- dplyr::pull(tbl, {{ n_col }})

  doc_totals <- tapply(
    n, documents,
    function(x) {
      switch(tf,
        tf = sum(x),
        tf2 = log(x + 1),
        tf3 = booled_freq(x),
        itf = sum(x)
      )
    }
  )

  if (identical(tf, "tf")) {
    tbl <- dplyr::mutate(tbl, tf = .data$n / as.numeric(doc_totals[documents]))
  } else if (identical(tf, "itf")) {
    tbl <-
      dplyr::mutate(tbl, tf = log(as.numeric(doc_totals[documents]) / .data$n))
  } else {
    tbl <- dplyr::mutate(tbl, tf = purrr::flatten_dbl(doc_totals))
  }

  if (isTRUE(rmecab_compat)) {
    sp <- cast_sparse(tbl, !!document, !!term, "tf")
  } else {
    sp <- cast_sparse(tbl, !!document, !!term, !!n_col)
  }

  idf <- switch(idf,
    idf = global_idf(sp),
    idf2 = global_idf2(sp),
    idf3 = global_idf3(sp),
    idf4 = global_entropy(sp),
    df = global_df(sp)
  )
  tbl <- dplyr::mutate(tbl,
    idf = as.numeric(idf[terms]),
    tf_idf = .data$tf * .data$idf
  )

  if (!isTRUE(norm)) {
    return(tbl)
  }
  dplyr::mutate(tbl,
    tf_idf = .data$tf_idf / norm(.data$tf_idf, type = "2"),
    .by = as_name(document)
  )
}
