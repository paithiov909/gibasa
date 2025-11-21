# Mute tokens by condition

Replaces tokens in the tidy text dataset with a string scalar only if
they are matched to an expression.

## Usage

``` r
mute_tokens(tbl, condition, .as = NA_character_)
```

## Arguments

- tbl:

  A tidy text dataset.

- condition:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  A logical expression.

- .as:

  String with which tokens are replaced when they are matched to
  condition. The default value is `NA_character_`.

## Value

A data.frame.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
) |>
  prettify(col_select = "POS1")

mute_tokens(df, POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e")) |>
  head()
} # }
```
