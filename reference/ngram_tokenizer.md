# Ngrams tokenizer

Makes an ngram tokenizer function.

## Usage

``` r
ngram_tokenizer(n = 1L)
```

## Arguments

- n:

  Integer.

## Value

ngram tokenizer function

## Examples

``` r
bigram <- ngram_tokenizer(2)
bigram(letters, sep = "-")
#>  [1] "a-b" "b-c" "c-d" "d-e" "e-f" "f-g" "g-h" "h-i" "i-j" "j-k" "k-l" "l-m"
#> [13] "m-n" "n-o" "o-p" "p-q" "q-r" "r-s" "s-t" "t-u" "u-v" "v-w" "w-x" "x-y"
#> [25] "y-z"
```
