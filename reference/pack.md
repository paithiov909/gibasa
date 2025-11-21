# Pack a data.frame of tokens

Packs a data.frame of tokens into a new data.frame of corpus, which is
compatible with the Text Interchange Formats.

## Usage

``` r
pack(tbl, pull = "token", n = 1L, sep = "-", .collapse = " ")
```

## Arguments

- tbl:

  A data.frame of tokens.

- pull:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column to be packed into text or ngrams body. Default value is
  `token`.

- n:

  Integer internally passed to ngrams tokenizer function created of
  [`gibasa::ngram_tokenizer()`](https://paithiov909.github.io/gibasa/reference/ngram_tokenizer.md)

- sep:

  Character scalar internally used as the concatenator of ngrams.

- .collapse:

  This argument is passed to
  [`stringi::stri_c()`](https://rdrr.io/pkg/stringi/man/stri_join.html).

## Value

A tibble.

## Text Interchange Formats (TIF)

The Text Interchange Formats (TIF) is a set of standards that allows R
text analysis packages to target defined inputs and outputs for corpora,
tokens, and document-term matrices.

## Valid data.frame of tokens

The data.frame of tokens here is a data.frame object compatible with the
TIF.

A TIF valid data.frame of tokens is expected to have one unique key
column (named `doc_id`) of each text and several feature columns of each
tokens. The feature columns must contain at least `token` itself.

## See also

<https://github.com/ropenscilabs/tif>

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
pack(df)
} # }
```
