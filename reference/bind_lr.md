# Bind importance of bigrams

Calculates and binds the importance of bigrams and their synergistic
average.

## Usage

``` r
bind_lr(tbl, term = "token", lr_mode = c("n", "dn"), avg_rate = 1)
```

## Arguments

- tbl:

  A tidy text dataset.

- term:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing terms.

- lr_mode:

  Method for computing 'FL' and 'FR' values. `n` is equivalent to 'LN'
  and 'RN', and `dn` is equivalent to 'LDN' and 'RDN'.

- avg_rate:

  Weight of the 'LR' value.

## Value

A data.frame.

## Details

The 'LR' value is the synergistic average of bigram importance that
based on the words and their positions (left or right side).

## See also

[doi:10.5715/jnlp.10.27](https://doi.org/10.5715/jnlp.10.27)

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
bind_lr(df) |>
  head()
} # }
```
