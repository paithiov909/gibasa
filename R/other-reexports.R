#' Bind importance of bigrams
#'
#' @inherit audubon::bind_lr description return details
#' @inheritParams audubon::bind_lr
#' @importFrom audubon bind_lr
#' @seealso \doi{10.5715/jnlp.10.27}
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' )
#' bind_lr(df)
#' }
bind_lr <- function(tbl,
                    term = "token",
                    lr_mode = c("n", "dn"),
                    avg_rate = 1.0) {
  term <- enquo(term)
  audubon::bind_lr(
    tbl = tbl,
    term = {{ term }},
    lr_mode = lr_mode,
    avg_rate = avg_rate
  )
}

#' Collapse sequences of tokens by condition
#'
#' @inherit audubon::collapse_tokens description return details
#' @inheritParams audubon::collapse_tokens
#' @importFrom audubon collapse_tokens
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' ) |>
#'   prettify(col_select = "POS1")
#'
#' head(collapse_tokens(
#'   df,
#'   POS1 == "\u540d\u8a5e" & stringr::str_detect(token, "^[\\p{Han}]+$")
#' ))
#' }
collapse_tokens <- function(tbl,
                            condition,
                            .collapse = "") {
  condition <- enquo(condition)
  audubon::collapse_tokens(
    tbl = tbl,
    condition = {{ condition }},
    .collapse = .collapse
  )
}

#' Mute tokens by condition
#'
#' @inherit audubon::mute_tokens description return
#' @inheritParams audubon::mute_tokens
#' @importFrom audubon mute_tokens
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' ) |>
#'   prettify(col_select = "POS1")
#'
#' head(mute_tokens(df, POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e")))
#' }
mute_tokens <- function(tbl,
                        condition,
                        .as = NA_character_) {
  condition <- enquo(condition)
  audubon::mute_tokens(
    tbl = tbl,
    condition = {{ condition }},
    .as = .as
  )
}

#' Calculate lexical density
#'
#' @inherit audubon::lex_density description return
#' @inheritParams audubon::lex_density
#' @importFrom audubon lex_density
#' @export
#' @examples
#' \dontrun{
#' df <- tokenize(
#'   data.frame(
#'     doc_id = seq_along(audubon::polano[5:8]),
#'     text = audubon::polano[5:8]
#'   )
#' )
#' df |>
#'   prettify(col_select = "POS1") |>
#'   dplyr::group_by(doc_id) |>
#'   dplyr::summarise(
#'     noun_ratio = lex_density(POS1,
#'       "\u540d\u8a5e",
#'       c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"),
#'       negate = c(FALSE, TRUE)
#'     ),
#'     mvr = lex_density(
#'       POS1,
#'       c("\u5f62\u5bb9\u8a5e", "\u526f\u8a5e", "\u9023\u4f53\u8a5e"),
#'       "\u52d5\u8a5e"
#'     ),
#'     vnr = lex_density(POS1, "\u52d5\u8a5e", "\u540d\u8a5e")
#'   )
#' }
lex_density <- function(vec,
                        contents_words,
                        targets = NULL,
                        negate = c(FALSE, FALSE)) {
  audubon::lex_density(
    vec = vec,
    contents_words = contents_words,
    targets = targets,
    negate = negate
  )
}
