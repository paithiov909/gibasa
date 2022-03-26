
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gibasa

Gibasa is a cleaner ‘Rcpp’ interface to ‘MeCab’.

## Installation

To install gibasa from source package requires the MeCab library (mecab,
libmecab-dev and mecab-ipadic-utf8) installed and available.

``` r
remotes::install_github("paithiov909/gibasa")
```

## Usage

``` r
res <- gibasa::tokenize(
  c("頭が赤い魚を食べる猫",
    "望遠鏡で泳ぐ彼女を見た")
)

head(res)
#>   doc_id sentence_id token_id  token
#> 1      1           1        1     頭
#> 2      1           1        2     が
#> 3      1           1        3   赤い
#> 4      1           1        4     魚
#> 5      1           1        5     を
#> 6      1           1        6 食べる
#>                                                      feature
#> 1                         名詞,一般,*,*,*,*,頭,アタマ,アタマ
#> 2                            助詞,格助詞,一般,*,*,*,が,ガ,ガ
#> 3 形容詞,自立,*,*,形容詞・アウオ段,基本形,赤い,アカイ,アカイ
#> 4                         名詞,一般,*,*,*,*,魚,サカナ,サカナ
#> 5                            助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
#> 6             動詞,自立,*,*,一段,基本形,食べる,タベル,タベル
head(gibasa::prettify(res))
#>   doc_id sentence_id token_id  token   POS1   POS2 POS3 POS4      X5StageUse1
#> 1      1           1        1     頭   名詞   一般 <NA> <NA>             <NA>
#> 2      1           1        2     が   助詞 格助詞 一般 <NA>             <NA>
#> 3      1           1        3   赤い 形容詞   自立 <NA> <NA> 形容詞・アウオ段
#> 4      1           1        4     魚   名詞   一般 <NA> <NA>             <NA>
#> 5      1           1        5     を   助詞 格助詞 一般 <NA>             <NA>
#> 6      1           1        6 食べる   動詞   自立 <NA> <NA>             一段
#>   X5StageUse2 Original  Yomi1  Yomi2
#> 1        <NA>       頭 アタマ アタマ
#> 2        <NA>       が     ガ     ガ
#> 3      基本形     赤い アカイ アカイ
#> 4        <NA>       魚 サカナ サカナ
#> 5        <NA>       を     ヲ     ヲ
#> 6      基本形   食べる タベル タベル

gibasa::pack(res)
#>   doc_id                         text
#> 1      1   頭 が 赤い 魚 を 食べる 猫
#> 2      2 望遠鏡 で 泳ぐ 彼女 を 見 た

res %>%
  gibasa::prettify() %>% 
  gibasa::gbs_c()
#> [[1]]
#>     名詞     助詞   形容詞     名詞     助詞     動詞     名詞 
#>     "頭"     "が"   "赤い"     "魚"     "を" "食べる"     "猫" 
#> 
#> [[2]]
#>     名詞     助詞     動詞     名詞     助詞     動詞   助動詞 
#> "望遠鏡"     "で"   "泳ぐ"   "彼女"     "を"     "見"     "た"

res %>%
  gibasa::prettify() %>% 
  gibasa::gbs_freq()
#> # A tibble: 13 x 4
#>    Term   Info1  Info2   Freq
#>    <chr>  <chr>  <chr>  <int>
#>  1 が     助詞   格助詞     1
#>  2 た     助動詞 <NA>       1
#>  3 で     助詞   格助詞     1
#>  4 を     助詞   格助詞     2
#>  5 泳ぐ   動詞   自立       1
#>  6 魚     名詞   一般       1
#>  7 見     動詞   自立       1
#>  8 食べる 動詞   自立       1
#>  9 赤い   形容詞 自立       1
#> 10 頭     名詞   一般       1
#> 11 猫     名詞   一般       1
#> 12 彼女   名詞   代名詞     1
#> 13 望遠鏡 名詞   一般       1

gibasa::gbs_as_tokens(res)
#> Tokens consisting of 2 documents.
#> 1 :
#> [1] "頭"     "が"     "赤い"   "魚"     "を"     "食べる" "猫"    
#> 
#> 2 :
#> [1] "望遠鏡" "で"     "泳ぐ"   "彼女"   "を"     "見"     "た"
gibasa::gbs_dfm(res)
#> Document-feature matrix of: 2 documents, 13 features (46.15% sparse) and 0 docvars.
#>     features
#> docs 頭 が 赤い 魚 を 食べる 猫 望遠鏡 で 泳ぐ
#>    1  1  1    1  1  1      1  1      0  0    0
#>    2  0  0    0  0  1      0  0      1  1    1
#> [ reached max_nfeat ... 3 more features ]
```

## License

GPL (>=3).
