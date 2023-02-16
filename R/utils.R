#' Create a list of tokens
#'
#' @param tbl A tibble of tokens out of \code{tokenize()}.
#' @param token_field Column name that contains tokens.
#' @param pos_field Feature name that will be kept as the names
#' of tokens. If you don't need them, give a `NULL` for this argument.
#' @param nm Names of returned list.
#' If left with `NULL`, "doc_id" field of `tbl` is used instead.
#' @return A named list of tokens.
#' @export
#' @examples
#' \dontrun{
#' tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' ) |>
#'   prettify(col_select = "POS1") |>
#'   as_tokens()
#' }
as_tokens <- function(tbl,
                      token_field = "token",
                      pos_field = get_dict_features()[1],
                      nm = NULL) {
  token_field <- enquo(token_field)
  col_names <- rlang::as_name("doc_id")

  if (is.null(nm)) {
    if (is.factor(tbl[[col_names]])) {
      nm <- levels(tbl[[col_names]])
    } else {
      nm <- unique(tbl[[col_names]])
    }
  }

  if (is.null(pos_field)) {
    tbl %>%
      dplyr::group_by(.data[[col_names]]) %>%
      dplyr::group_map(function(df, grp) {
        dplyr::pull(df, !!token_field)
      }) %>%
      purrr::set_names(nm)
  } else {
    tbl %>%
      dplyr::group_by(.data[[col_names]]) %>%
      dplyr::group_map(function(df, grp) {
        dplyr::pull(df, !!token_field, pos_field)
      }) %>%
      purrr::set_names(nm)
  }
}

#' Check if scalars are blank
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for \code{base::sapply()}.
#' @return Logical.
#' @export
#' @examples
#' is_blank(list(c(a = "", b = NA_character_), NULL))
is_blank <- function(x, trim = TRUE, ...) {
  if (!is.list(x)) {
    if (is.null(x)) {
      return(TRUE)
    }
    if (is.character(x) && trim) x <- stringi::stri_trim(x)
    is.blank(x)
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, is_blank, trim = trim, ...)
  }
}

is.blank <- function(x) {
  UseMethod("is.blank", x)
}

is.blank.default <- function(x) {
  is.na(x) | is.nan(x)
}

is.blank.character <- function(x) {
  is.na(x) | stringi::stri_isempty(x)
}

#' Get transition cost between pos attributes
#'
#' @inherit transition_cost
#' @inheritParams transition_cost
#' @keywords internal
#' @export
get_transition_cost <- function(rcAttr,
                                lcAttr,
                                sys_dic = "",
                                user_dic = "") {
  dict <- dictionary_info(sys_dic, user_dic)
  if (rlang::is_empty(dict)) {
    rlang::abort(class = "gbs_missing_dict")
  }
  rcAttr <- as.integer(rcAttr)
  lcAttr <- as.integer(lcAttr)
  size <- min(dict[["lsize"]], dict[["rsize"]])
  if (min(rcAttr, lcAttr) < 0 || rcAttr > size || lcAttr > size) {
    rlang::abort("rcAttr and/or lcAttr is invalid.")
  }
  transition_cost(rcAttr, lcAttr, sys_dic, user_dic)
}
