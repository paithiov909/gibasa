# Tokenize sentences using 'MeCab'

Tokenize sentences using 'MeCab'

## Usage

``` r
tokenize(
  x,
  text_field = "text",
  docid_field = "doc_id",
  sys_dic = "",
  user_dic = "",
  split = FALSE,
  partial = FALSE,
  grain_size = 1L,
  mode = c("parse", "wakati")
)
```

## Arguments

- x:

  A data.frame like object or a character vector to be tokenized.

- text_field:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  String or symbol; column containing texts to be tokenized.

- docid_field:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  String or symbol; column containing document IDs.

- sys_dic:

  Character scalar; path to the system dictionary for 'MeCab'. Note that
  the system dictionary is expected to be compiled with UTF-8, not
  Shift-JIS or other encodings.

- user_dic:

  Character scalar; path to the user dictionary for 'MeCab'.

- split:

  Logical. When passed as `TRUE`, the function internally splits the
  sentences into sub-sentences using
  `stringi::stri_split_boundaries(type = "sentence")`.

- partial:

  Logical. When passed as `TRUE`, activates partial parsing mode. To
  activate this feature, remember that all spaces at the start and end
  of the input chunks are already squashed. In particular, trailing
  spaces of chunks sometimes cause errors when parsing.

- grain_size:

  Integer value larger than 1. This argument is internally passed to
  `RcppParallel::parallelFor` function. Setting a larger chunk size
  could improve the performance in some cases.

- mode:

  Character scalar to switch output format.

## Value

A tibble or a named list of tokens.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
head(df)
} # }
```
