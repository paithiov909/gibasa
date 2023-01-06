#' Check if scalars are blank
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for \code{base::sapply()}.
#'
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
