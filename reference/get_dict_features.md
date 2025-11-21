# Get dictionary features

Returns names of dictionary features. Currently supports "unidic17"
(2.1.2 src schema), "unidic26" (2.1.2 bin schema), "unidic29" (schema
used in 2.2.0, 2.3.0), "cc-cedict", "ko-dic" (mecab-ko-dic), "naist11",
"sudachi", and "ipa".

## Usage

``` r
get_dict_features(
  dict = c("ipa", "unidic17", "unidic26", "unidic29", "cc-cedict", "ko-dic", "naist11",
    "sudachi")
)
```

## Arguments

- dict:

  Character scalar; one of "ipa", "unidic17", "unidic26", "unidic29",
  "cc-cedict", "ko-dic", "naist11", or "sudachi".

## Value

A character vector.

## See also

See also
['CC-CEDICT-MeCab'](https://github.com/ueda-keisuke/CC-CEDICT-MeCab) and
['mecab-ko-dic'](https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/).

## Examples

``` r
get_dict_features("ipa")
#> [1] "POS1"        "POS2"        "POS3"        "POS4"        "X5StageUse1"
#> [6] "X5StageUse2" "Original"    "Yomi1"       "Yomi2"      
```
