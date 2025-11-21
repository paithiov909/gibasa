# Tokenizer for debug use

Tokenizes a character vector and returns all possible results out of the
tokenization process. The returned data.frame contains additional
attributes for debug usage.

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
