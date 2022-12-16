#' @noRd
#' @importFrom rlang enquo enquos ensym sym .data := as_name as_label
#' @importFrom dplyr %>%
NULL

#' Collapse sequences of tokens by condition
#'
#' @inherit audubon::collapse_tokens description return details
#' @inheritParams audubon::collapse_tokens
#' @importFrom audubon collapse_tokens
#' @export
collapse_tokens <- audubon::collapse_tokens

#' Mute tokens by condition
#'
#' @inherit audubon::mute_tokens description return
#' @inheritParams audubon::mute_tokens
#' @importFrom audubon mute_tokens
#' @export
mute_tokens <- audubon::mute_tokens

#' Calculate lexical density
#'
#' @inherit audubon::lex_density description return
#' @inheritParams audubon::lex_density
#' @importFrom audubon lex_density
#' @export
lex_density <- audubon::lex_density
