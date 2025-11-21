# Tokenize sentences using 'MeCab'

Tokenize sentences using 'MeCab'

## Usage

``` r
gbs_tokenize(
  x,
  sys_dic = "",
  user_dic = "",
  split = FALSE,
  partial = FALSE,
  mode = c("parse", "wakati")
)
```

## Arguments

- x:

  A data.frame like object or a character vector to be tokenized.

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

- mode:

  Character scalar to switch output format.

## Value

A tibble or a named list of tokens.
