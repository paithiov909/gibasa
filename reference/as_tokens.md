# Create a list of tokens

Create a list of tokens

## Usage

``` r
as_tokens(
  tbl,
  token_field = "token",
  pos_field = get_dict_features()[1],
  nm = NULL
)
```

## Arguments

- tbl:

  A tibble of tokens out of
  [`tokenize()`](https://paithiov909.github.io/gibasa/reference/tokenize.md).

- token_field:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing tokens.

- pos_field:

  Column containing features that will be kept as the names of tokens.
  If you don't need them, give a `NULL` for this argument.

- nm:

  Names of returned list. If left with `NULL`, "doc_id" field of `tbl`
  is used instead.

## Value

A named list of tokens.

## Examples

``` r
if (FALSE) { # \dontrun{
tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
) |>
  prettify(col_select = "POS1") |>
  as_tokens()
} # }
```
