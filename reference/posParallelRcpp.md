# Call tagger inside 'RcppParallel::parallelFor' and return a data.frame.

This function is an internal function called by
[`tokenize()`](https://paithiov909.github.io/gibasa/reference/tokenize.md).
For common usage, use
[`tokenize()`](https://paithiov909.github.io/gibasa/reference/tokenize.md)
instead.

## Arguments

- text:

  A character vector to be tokenized.

- sys_dic:

  Character scalar; path to the system dictionary for 'MeCab'.

- user_dic:

  Character scalar; path to the user dictionary for 'MeCab'.

- partial:

  Logical; If `TRUE`, activates partial parsing mode.

- grain_size:

  Integer value larger than 1.

## Value

A data.frame.
