
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gibasa

<!-- badges: start -->

[![R-CMD-check](https://github.com/paithiov909/gibasa/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/gibasa/actions)
<!-- badges: end -->

Gibasa is a plain ‘Rcpp’ interface to ‘MeCab’, a CJK tokenizer and
morphological analysis tool.

## Installation

To install gibasa from source package requires the MeCab library (mecab,
libmecab-dev and mecab-ipadic-utf8) installed and available.

``` r
remotes::install_github("paithiov909/gibasa")
```

## Usage

### Tokenize and prettify output

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
```

### Integrate with ‘quanteda’

``` r
gibasa::gbs_as_tokens(res) ## cast as quanteda 'tokens' object
#> Tokens consisting of 2 documents.
#> 1 :
#> [1] "頭"     "が"     "赤い"   "魚"     "を"     "食べる" "猫"    
#> 
#> 2 :
#> [1] "望遠鏡" "で"     "泳ぐ"   "彼女"   "を"     "見"     "た"
gibasa::gbs_dfm(res) ## cast as quanteda 'dfm' object
#> Document-feature matrix of: 2 documents, 13 features (46.15% sparse) and 0 docvars.
#>     features
#> docs 頭 が 赤い 魚 を 食べる 猫 望遠鏡 で 泳ぐ
#>    1  1  1    1  1  1      1  1      0  0    0
#>    2  0  0    0  0  1      0  0      1  1    1
#> [ reached max_nfeat ... 3 more features ]
```

### Change dictionary

IPA, [UniDic](https://ccd.ninjal.ac.jp/unidic/),
[CC-CEDICT-MeCab](https://github.com/ueda-keisuke/CC-CEDICT-MeCab), and
[mecab-ko-dic](https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/)
schemes are supported.

``` r
## CC-CEDICT
gibasa::tokenize("它可以进行日语和汉语的语态分析", sys_dic = "/mecab/cc-cedict") %>%
    gibasa::prettify(into = gibasa::get_dict_features("cc-cedict"))
#>   doc_id sentence_id token_id            token POS1 POS2 POS3 POS4 pinyin_pron
#> 1      1           1        1               它 <NA> <NA> <NA> <NA>         ta1
#> 2      1           1        2             可以 <NA> <NA> <NA> <NA>     ke3 yi3
#> 3      1           1        3       <U+8FDB>行 <NA> <NA> <NA> <NA>  jin4 xing2
#> 4      1           1        4       日<U+8BED> <NA> <NA> <NA> <NA>     Ri4 yu3
#> 5      1           1        5               和 <NA> <NA> <NA> <NA>         he2
#> 6      1           1        6 <U+6C49><U+8BED> <NA> <NA> <NA> <NA>    Han4 yu3
#> 7      1           1        7               的 <NA> <NA> <NA> <NA>         di4
#> 8      1           1        8 <U+8BED><U+6001> <NA> <NA> <NA> <NA>    yu3 tai4
#> 9      1           1        9             分析 <NA> <NA> <NA> <NA>    fen1 xi1
#>   traditional_char_form simplified_char_form
#> 1                    它                   它
#> 2                  可以                 可以
#> 3                  進行           <U+8FDB>行
#> 4                  日語           日<U+8BED>
#> 5              <U+9FA2>                   和
#> 6                  漢語     <U+6C49><U+8BED>
#> 7                    的                   的
#> 8                  語態     <U+8BED><U+6001>
#> 9                  分析                 分析
#>                                                                              definition
#> 1                                                                                   it/
#> 2                                         can/may/possible/able to/not bad/pretty good/
#> 3 to advance/to conduct/underway/in progress/to do/to carry out/to carry on/to execute/
#> 4                                                                    Japanese language/
#> 5                                                    old variant of 和[he2]/harmonious/
#> 6                                                Chinese language/CL:門|<U+95E8>[men2]/
#> 7                                                                            aim/clear/
#> 8                                                                      voice (grammar)/
#> 9                                                    to analyze/analysis/CL:個|个[ge4]/

## mecan-ko-dic
gibasa::tokenize("하네다공항한정토트백", sys_dic = "/mecab/mecab-ko-dic") %>%
    gibasa::prettify(into = gibasa::get_dict_features("ko-dic"))
#>   doc_id sentence_id token_id                    token POS          meaning
#> 1      1           1        1 <U+D558><U+B124><U+B2E4> NNP <U+C778><U+BA85>
#> 2      1           1        2         <U+ACF5><U+D56D> NNG <U+C7A5><U+C18C>
#> 3      1           1        3         <U+D55C><U+C815> NNG             <NA>
#> 4      1           1        4 <U+D1A0><U+D2B8><U+BC31> NNG             <NA>
#>   presence                  reading     type first_pos last_pos
#> 1        F <U+D558><U+B124><U+B2E4>     <NA>      <NA>     <NA>
#> 2        T         <U+ACF5><U+D56D>     <NA>      <NA>     <NA>
#> 3        T         <U+D55C><U+C815>     <NA>      <NA>     <NA>
#> 4        T <U+D1A0><U+D2B8><U+BC31> Compound      <NA>     <NA>
#>                                             expression
#> 1                                                 <NA>
#> 2                                                 <NA>
#> 3                                                 <NA>
#> 4 <U+D1A0><U+D2B8>/NNP/<U+C778><U+BA85>+<U+BC31>/NNG/*
```

## License

GPL (\>=3).
