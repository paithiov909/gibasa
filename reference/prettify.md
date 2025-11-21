# Prettify tokenized output

Turns a single character column into features while separating with
delimiter.

## Usage

``` r
prettify(
  tbl,
  col = "feature",
  into = get_dict_features("ipa"),
  col_select = seq_along(into),
  delim = ","
)
```

## Arguments

- tbl:

  A data.frame that has feature column to be prettified.

- col:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing features to be prettified.

- into:

  Character vector that is used as column names of features.

- col_select:

  Character or integer vector that will be kept in prettified features.

- delim:

  Character scalar used to separate fields within a feature.

## Value

A data.frame.

## Examples

``` r
prettify(
  data.frame(x = c("x,y", "y,z", "z,x")),
  col = "x",
  into = c("a", "b"),
  col_select = "b"
)
#>   b
#> 1 y
#> 2 z
#> 3 x

if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
prettify(df, col_select = 1:3)
prettify(df, col_select = c(1, 3, 6))
prettify(df, col_select = c("POS1", "Original"))
} # }
```
