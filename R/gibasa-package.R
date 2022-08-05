#' @keywords internal
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @importFrom rlang enquo enquos ensym sym .data := as_name as_label
#' @importFrom dplyr %>%
#' @useDynLib gibasa, .registration = TRUE
"_PACKAGE"

#' @importFrom utils globalVariables
utils::globalVariables("where")
