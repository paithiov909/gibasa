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
  if (!is.list(x) && length(x) <= 1) {
    if (is.null(x)) {
      return(TRUE)
    }
    dplyr::case_when(
      is.na(x) ~ TRUE,
      is.nan(x) ~ TRUE,
      is.character(x) && nchar(ifelse(trim, stringi::stri_trim(x), x)) == 0 ~ TRUE,
      TRUE ~ FALSE
    )
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, is_blank, trim = trim, ...)
  }
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
    return(dict)
  } else {
    rcAttr <- as.integer(rcAttr)
    lcAttr <- as.integer(lcAttr)
    size <- min(dict[["lsize"]], dict[["rsize"]])
    if (min(rcAttr, lcAttr) < 0 || rcAttr > size || lcAttr > size) {
      rlang::abort("rcAttr and/or lcAttr is invalid.")
    }
    transition_cost(rcAttr, lcAttr, sys_dic, user_dic)
  }
}
