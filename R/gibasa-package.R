#' @keywords internal
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @importFrom rlang enquo enquos ensym sym .data .env := as_name
#' @importFrom dplyr %>%
#' @useDynLib gibasa, .registration = TRUE
"_PACKAGE"

#' @importFrom utils globalVariables
utils::globalVariables("where")

#' Whole text of 'Ginga Tetsudo no Yoru' written by Miyazawa Kenji
#' from Aozora Bunko
#'
#' @details
#' A dataset containing the text of Miyazawa Kenji's novel
#' "Ginga Tetsudo no Yoru" (English title: "Night on the Galactic Railroad")
#' which was published in 1934, the year after Kenji's death.
#' Copyright of this work has expired
#' since more than 70 years have passed after the author's death.
#'
#' The UTF-8 plain text is sourced from
#' \url{https://www.aozora.gr.jp/cards/000081/card43737.html}
#' and is cleaned of meta data.
#'
#' @source
#' \url{https://www.aozora.gr.jp/cards/000081/files/43737_ruby_19028.zip}
#' @examples
#' head(ginga)
"ginga"
