
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gibasa

<!-- badges: start -->

[![gibasa status
badge](https://paithiov909.r-universe.dev/badges/gibasa)](https://paithiov909.r-universe.dev)
![GitHub](https://img.shields.io/github/license/paithiov909/gibasa)
[![R-CMD-check](https://github.com/paithiov909/gibasa/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/gibasa/actions)
[![codecov](https://codecov.io/gh/paithiov909/gibasa/branch/main/graph/badge.svg)](https://app.codecov.io/gh/paithiov909/gibasa)
[![CRAN logs
badge](https://cranlogs.r-pkg.org/badges/gibasa)](https://cran.r-project.org/package=gibasa)
<!-- badges: end -->

## Overview

Gibasa is a plain ‘Rcpp’ wrapper of ‘MeCab’, a morphological analyzer
for CJK text.

Part-of-speech tagging with morphological analyzers is useful for
processing CJK text data. This is because most words in CJK text are not
separated by whitespaces and `tokenizers::tokenize_words` may split them
into wrong tokens.

The main goal of gibasa package is to provide an alternative to
`tidytext::unnest_tokens` for CJK text data. For this goal, gibasa
provides three main functions: `gibasa::tokenize`, `gibasa::prettify`,
and `gibasa::pack`.

<figure>
<img src="man/figures/tidytext_fig5_1_mod.drawio.png"
alt="flowchart of a text analysis that combines gibasa and other packages" />
<figcaption aria-hidden="true">flowchart of a text analysis that
combines gibasa and other packages</figcaption>
</figure>

- `gibasa::tokenize` takes a TIF-compliant data.frame of corpus,
  returning tokens as format that known as ‘tidy text data’, so that
  users can replace `tidytext::unnest_tokens` with it for tokenizing CJK
  text.
- `gibasa::prettify` turns tagged features into columns.
- `gibasa::pack` takes a ‘tidy text data’, typically returning
  space-separated corpus.

## Installation

You can install binary package via
[CRAN](https://cran.r-project.org/package=gibasa) or
[r-universe](https://paithiov909.r-universe.dev/gibasa).

``` r
# Install gibasa from r-universe repository
install.packages("gibasa", repos = c("https://paithiov909.r-universe.dev", "https://cloud.r-project.org"))

# Or build from source package
Sys.setenv(MECAB_DEFAULT_RC = "/fullpath/to/your/mecabrc") # if necessary
remotes::install_github("paithiov909/gibasa")
```

To use gibasa package requires the
[MeCab](https://taku910.github.io/mecab/) library and its dictionary
installed and available.

In case using Linux or OSX, you can install them with their package
managers, or build and install from the source by yourself.

In case using Windows, use installer [built for
32bit](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7WElGUGt6ejlpVXc)
or [built for
64bit](https://github.com/ikegami-yukino/mecab/releases/tag/v0.996.2).
Note that gibasa requires a UTF-8 dictionary, not a Shift-JIS one.

As of v0.9.4 above, gibasa looks at the file specified by the
environment variable `MECABRC` or the file located at `~/.mecabrc`. If
the MeCab dictionary is in a different location than the default, create
a mecabrc file and specify where the dictionary is located.

## Usage

### Tokenize sentences

``` r
res <- gibasa::tokenize(
  data.frame(
    doc_id = seq_along(gibasa::ginga[5:8]),
    text = gibasa::ginga[5:8]
  )
)
res
#> # A tibble: 187 × 5
#>    doc_id sentence_id token_id token        feature                             
#>    <fct>        <int>    <int> <chr>        <chr>                               
#>  1 1                1        1 　           記号,空白,*,*,*,*,　,　,　          
#>  2 1                1        2 カムパネルラ 名詞,一般,*,*,*,*,*                 
#>  3 1                1        3 が           助詞,格助詞,一般,*,*,*,が,ガ,ガ     
#>  4 1                1        4 手           名詞,一般,*,*,*,*,手,テ,テ          
#>  5 1                1        5 を           助詞,格助詞,一般,*,*,*,を,ヲ,ヲ     
#>  6 1                1        6 あげ         動詞,自立,*,*,一段,連用形,あげる,ア…
#>  7 1                1        7 まし         助動詞,*,*,*,特殊・マス,連用形,ます…
#>  8 1                1        8 た           助動詞,*,*,*,特殊・タ,基本形,た,タ,…
#>  9 1                1        9 。           記号,句点,*,*,*,*,。,。,。          
#> 10 1                1       10 それ         名詞,代名詞,一般,*,*,*,それ,ソレ,ソ…
#> # ℹ 177 more rows
```

### Prettify output

``` r
gibasa::prettify(res)
#> # A tibble: 187 × 13
#>    doc_id sentence_id token_id token        POS1   POS2  POS3  POS4  X5StageUse1
#>    <fct>        <int>    <int> <chr>        <chr>  <chr> <chr> <chr> <chr>      
#>  1 1                1        1 　           記号   空白  <NA>  <NA>  <NA>       
#>  2 1                1        2 カムパネルラ 名詞   一般  <NA>  <NA>  <NA>       
#>  3 1                1        3 が           助詞   格助… 一般  <NA>  <NA>       
#>  4 1                1        4 手           名詞   一般  <NA>  <NA>  <NA>       
#>  5 1                1        5 を           助詞   格助… 一般  <NA>  <NA>       
#>  6 1                1        6 あげ         動詞   自立  <NA>  <NA>  一段       
#>  7 1                1        7 まし         助動詞 <NA>  <NA>  <NA>  特殊・マス 
#>  8 1                1        8 た           助動詞 <NA>  <NA>  <NA>  特殊・タ   
#>  9 1                1        9 。           記号   句点  <NA>  <NA>  <NA>       
#> 10 1                1       10 それ         名詞   代名… 一般  <NA>  <NA>       
#> # ℹ 177 more rows
#> # ℹ 4 more variables: X5StageUse2 <chr>, Original <chr>, Yomi1 <chr>,
#> #   Yomi2 <chr>
gibasa::prettify(res, col_select = 1:3)
#> # A tibble: 187 × 7
#>    doc_id sentence_id token_id token        POS1   POS2   POS3 
#>    <fct>        <int>    <int> <chr>        <chr>  <chr>  <chr>
#>  1 1                1        1 　           記号   空白   <NA> 
#>  2 1                1        2 カムパネルラ 名詞   一般   <NA> 
#>  3 1                1        3 が           助詞   格助詞 一般 
#>  4 1                1        4 手           名詞   一般   <NA> 
#>  5 1                1        5 を           助詞   格助詞 一般 
#>  6 1                1        6 あげ         動詞   自立   <NA> 
#>  7 1                1        7 まし         助動詞 <NA>   <NA> 
#>  8 1                1        8 た           助動詞 <NA>   <NA> 
#>  9 1                1        9 。           記号   句点   <NA> 
#> 10 1                1       10 それ         名詞   代名詞 一般 
#> # ℹ 177 more rows
gibasa::prettify(res, col_select = c(1, 3, 5))
#> # A tibble: 187 × 7
#>    doc_id sentence_id token_id token        POS1   POS3  X5StageUse1
#>    <fct>        <int>    <int> <chr>        <chr>  <chr> <chr>      
#>  1 1                1        1 　           記号   <NA>  <NA>       
#>  2 1                1        2 カムパネルラ 名詞   <NA>  <NA>       
#>  3 1                1        3 が           助詞   一般  <NA>       
#>  4 1                1        4 手           名詞   <NA>  <NA>       
#>  5 1                1        5 を           助詞   一般  <NA>       
#>  6 1                1        6 あげ         動詞   <NA>  一段       
#>  7 1                1        7 まし         助動詞 <NA>  特殊・マス 
#>  8 1                1        8 た           助動詞 <NA>  特殊・タ   
#>  9 1                1        9 。           記号   <NA>  <NA>       
#> 10 1                1       10 それ         名詞   一般  <NA>       
#> # ℹ 177 more rows
gibasa::prettify(res, col_select = c("POS1", "Original"))
#> # A tibble: 187 × 6
#>    doc_id sentence_id token_id token        POS1   Original
#>    <fct>        <int>    <int> <chr>        <chr>  <chr>   
#>  1 1                1        1 　           記号   　      
#>  2 1                1        2 カムパネルラ 名詞   <NA>    
#>  3 1                1        3 が           助詞   が      
#>  4 1                1        4 手           名詞   手      
#>  5 1                1        5 を           助詞   を      
#>  6 1                1        6 あげ         動詞   あげる  
#>  7 1                1        7 まし         助動詞 ます    
#>  8 1                1        8 た           助動詞 た      
#>  9 1                1        9 。           記号   。      
#> 10 1                1       10 それ         名詞   それ    
#> # ℹ 177 more rows
```

### Pack output

``` r
res <- gibasa::prettify(res)
gibasa::pack(res)
#> # A tibble: 4 × 2
#>   doc_id text                                                                   
#>   <fct>  <chr>                                                                  
#> 1 1      　 カムパネルラ が 手 を あげ まし た 。 それ から 四 、 五 人 手 を … 
#> 2 2      　 ところが 先生 は 早く も それ を 見つけ た の でし た 。            
#> 3 3      「 ジョバンニ さん 。 あなた は わかっ て いる の でしょ う 」         
#> 4 4      　 ジョバンニ は 勢い よく 立ちあがり まし た が 、 立っ て みる と も…

dplyr::mutate(
  res,
  token = dplyr::if_else(is.na(Original), token, Original),
  token = paste(token, POS1, sep = "/")
) |>
  gibasa::pack() |>
  head(1L)
#> # A tibble: 1 × 2
#>   doc_id text                                                                  
#>   <fct>  <chr>                                                                 
#> 1 1      　/記号 カムパネルラ/名詞 が/助詞 手/名詞 を/助詞 あげる/動詞 ます/助…
```

### Change dictionary

IPA, UniDic,
[CC-CEDICT-MeCab](https://github.com/ueda-keisuke/CC-CEDICT-MeCab), and
[mecab-ko-dic](https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/)
schemes are supported.

``` r
## UniDic 2.1.2
gibasa::tokenize("あのイーハトーヴォのすきとおった風", sys_dic = "/Downloads/unidic-lite") |>
  gibasa::prettify(into = gibasa::get_dict_features("unidic26"))
#> # A tibble: 6 × 30
#>   doc_id sentenc…¹ token…² token POS1  POS2  POS3  POS4  cType cForm lForm lemma
#>   <fct>      <int>   <int> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
#> 1 1              1       1 あの  感動… フィ… <NA>  <NA>  <NA>  <NA>  アノ  あの 
#> 2 1              1       2 イー… 名詞  普通… 一般  <NA>  <NA>  <NA>  <NA>  <NA> 
#> 3 1              1       3 の    助詞  格助… <NA>  <NA>  <NA>  <NA>  ノ    の   
#> 4 1              1       4 すき… 動詞  一般  <NA>  <NA>  五段… 連用… スキ… 透き…
#> 5 1              1       5 た    助動… <NA>  <NA>  <NA>  助動… 連体… タ    た   
#> 6 1              1       6 風    名詞  普通… 一般  <NA>  <NA>  <NA>  カゼ  風   
#> # … with 18 more variables: orth <chr>, pron <chr>, orthBase <chr>,
#> #   pronBase <chr>, goshu <chr>, iType <chr>, iForm <chr>, fType <chr>,
#> #   fForm <chr>, kana <chr>, kanaBase <chr>, form <chr>, formBase <chr>,
#> #   iConType <chr>, fConType <chr>, aType <chr>, aConType <chr>,
#> #   aModeType <chr>, and abbreviated variable names ¹​sentence_id, ²​token_id


## CC-CEDICT
gibasa::tokenize("它可以进行日语和汉语的语态分析", sys_dic = "/Downloads/cc-cedict") |> 
  gibasa::prettify(into = gibasa::get_dict_features("cc-cedict"))
#> # A tibble: 9 × 12
#>   doc_id sentenc…¹ token…² token POS1  POS2  POS3  POS4  pinyi…³ tradi…⁴ simpl…⁵
#>   <fct>      <int>   <int> <chr> <chr> <chr> <chr> <chr> <chr>   <chr>   <chr>  
#> 1 1              1       1 它    <NA>  <NA>  <NA>  <NA>  ta1     它      它     
#> 2 1              1       2 可以  <NA>  <NA>  <NA>  <NA>  ke3 yi3 可以    可以   
#> 3 1              1       3 进行  <NA>  <NA>  <NA>  <NA>  jin4 x… 進行    进行   
#> 4 1              1       4 日语  <NA>  <NA>  <NA>  <NA>  Ri4 yu3 日語    日语   
#> 5 1              1       5 和    <NA>  <NA>  <NA>  <NA>  he2     龢      和     
#> 6 1              1       6 汉语  <NA>  <NA>  <NA>  <NA>  Han4 y… 漢語    汉语   
#> 7 1              1       7 的    <NA>  <NA>  <NA>  <NA>  di4     的      的     
#> 8 1              1       8 语态  <NA>  <NA>  <NA>  <NA>  yu3 ta… 語態    语态   
#> 9 1              1       9 分析  <NA>  <NA>  <NA>  <NA>  fen1 x… 分析    分析   
#> # … with 1 more variable: definition <chr>, and abbreviated variable names
#> #   ¹​sentence_id, ²​token_id, ³​pinyin_pron, ⁴​traditional_char_form,
#> #   ⁵​simplified_char_form


## mecab-ko-dic
gibasa::tokenize("하네다공항한정토트백", sys_dic = "/Downloads/mecab-ko-dic") |> 
  gibasa::prettify(into = gibasa::get_dict_features("ko-dic"))
#> # A tibble: 4 × 12
#>   doc_id sentence_id token_id token  POS   meaning prese…¹ reading type  first…²
#>   <fct>        <int>    <int> <chr>  <chr> <chr>   <chr>   <chr>   <chr> <chr>  
#> 1 1                1        1 하네다 NNP   인명    F       하네다  <NA>  <NA>   
#> 2 1                1        2 공항   NNG   장소    T       공항    <NA>  <NA>   
#> 3 1                1        3 한정   NNG   <NA>    T       한정    <NA>  <NA>   
#> 4 1                1        4 토트백 NNG   <NA>    T       토트백  Comp… <NA>   
#> # … with 2 more variables: last_pos <chr>, expression <chr>, and abbreviated
#> #   variable names ¹​presence, ²​first_pos
```

## License

GPL (\>=3).
