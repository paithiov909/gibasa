# Collapse sequences of tokens by condition

Concatenates sequences of tokens in the tidy text dataset, while
grouping them by an expression.

## Usage

``` r
collapse_tokens(tbl, condition, .collapse = "")
```

## Arguments

- tbl:

  A tidy text dataset.

- condition:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  A logical expression.

- .collapse:

  String with which tokens are concatenated.

## Value

A data.frame.

## Details

Note that this function drops all columns except but 'token' and columns
for grouping sequences. So, the returned data.frame has only 'doc_id',
'sentence_id', 'token_id', and 'token' columns.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = "odakyu-sen",
    text = "\u5c0f\u7530\u6025\u7dda"
  )
) |>
  prettify(col_select = "POS1")

collapse_tokens(
  df,
  POS1 == "\u540d\u8a5e" & stringr::str_detect(token, "^[\\p{Han}]+$")
) |>
  head()
} # }
```
