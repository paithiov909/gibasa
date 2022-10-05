
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gibasa

<!-- badges: start -->

[![gibasa status
badge](https://paithiov909.r-universe.dev/badges/gibasa)](https://paithiov909.r-universe.dev)
![GitHub](https://img.shields.io/github/license/paithiov909/gibasa)
[![R-CMD-check](https://github.com/paithiov909/gibasa/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/gibasa/actions)
[![codecov](https://codecov.io/gh/paithiov909/gibasa/branch/main/graph/badge.svg)](https://codecov.io/gh/paithiov909/gibasa)
<!-- badges: end -->

## Overview

Gibasa is a plain ‘Rcpp’ interface to ‘MeCab’, CJK tokenizer and
morphological analysis tool.

The main goal of gibasa package is to provide an alternative to
`tidytext::unnest_tokens` for CJK text data. For analyzing CJK text
data, it usually requires part-of-speech tagging, as most of them are
not separated with spaces and `tokenizers::tokenize_words` sometimes
splits them into erroneous tokens.

Gibasa provides 3 main functions: `gibasa::tokenize`,
`gibasa::prettify`, and `gibasa::pack`.

![image](man/figures/tidytext_fig5_1_mod.drawio.png)

- `gibasa::tokenize` retrieves a TIF-compliant data.frame of corpus,
  returning tokens as format that known as ‘tidy text data’, so that
  users can replace `tidytext::unnest_tokens` with it for tokenizing CJK
  text.
- `gibasa::prettify` turns tagged features into columns.
- `gibasa::pack` retrieves a ‘tidy text data’, typically returning
  space-separated corpus.

## Installation

You can install binary package via
[r-universe](https://paithiov909.r-universe.dev/ui#package:gibasa).

``` r
# Enable repository from paithiov909
options(repos = c(
  paithiov909 = "https://paithiov909.r-universe.dev",
  CRAN = "https://cloud.r-project.org"))

# Download and install gibasa in R
install.packages("gibasa")

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

## Usage

### Tokenize sentences

``` r
res <- gibasa::tokenize(
  data.frame(
    doc_id = seq_along(audubon::polano[5:8]),
    text = audubon::polano[5:8]
  )
)
head(res)
#>   doc_id sentence_id token_id    token
#> 1      1           1        1     その
#> 2      1           1        2     ころ
#> 3      1           1        3 わたくし
#> 4      1           1        4       は
#> 5      1           1        5       、
#> 6      1           1        6 モリーオ
#>                                             feature
#> 1                   連体詞,*,*,*,*,*,その,ソノ,ソノ
#> 2         名詞,非自立,副詞可能,*,*,*,ころ,コロ,コロ
#> 3 名詞,代名詞,一般,*,*,*,わたくし,ワタクシ,ワタクシ
#> 4                      助詞,係助詞,*,*,*,*,は,ハ,ワ
#> 5                        記号,読点,*,*,*,*,、,、,、
#> 6                     名詞,固有名詞,地域,一般,*,*,*
```

### Prettify output

``` r
head(gibasa::prettify(res))
#>   doc_id sentence_id token_id    token   POS1     POS2     POS3 POS4
#> 1      1           1        1     その 連体詞     <NA>     <NA> <NA>
#> 2      1           1        2     ころ   名詞   非自立 副詞可能 <NA>
#> 3      1           1        3 わたくし   名詞   代名詞     一般 <NA>
#> 4      1           1        4       は   助詞   係助詞     <NA> <NA>
#> 5      1           1        5       、   記号     読点     <NA> <NA>
#> 6      1           1        6 モリーオ   名詞 固有名詞     地域 一般
#>   X5StageUse1 X5StageUse2 Original    Yomi1    Yomi2
#> 1        <NA>        <NA>     その     ソノ     ソノ
#> 2        <NA>        <NA>     ころ     コロ     コロ
#> 3        <NA>        <NA> わたくし ワタクシ ワタクシ
#> 4        <NA>        <NA>       は       ハ       ワ
#> 5        <NA>        <NA>       、       、       、
#> 6        <NA>        <NA>     <NA>     <NA>     <NA>
head(gibasa::prettify(res, col_select = 1:3))
#>   doc_id sentence_id token_id    token   POS1     POS2     POS3
#> 1      1           1        1     その 連体詞     <NA>     <NA>
#> 2      1           1        2     ころ   名詞   非自立 副詞可能
#> 3      1           1        3 わたくし   名詞   代名詞     一般
#> 4      1           1        4       は   助詞   係助詞     <NA>
#> 5      1           1        5       、   記号     読点     <NA>
#> 6      1           1        6 モリーオ   名詞 固有名詞     地域
head(gibasa::prettify(res, col_select = c(1,3,5)))
#>   doc_id sentence_id token_id    token   POS1     POS3 X5StageUse1
#> 1      1           1        1     その 連体詞     <NA>        <NA>
#> 2      1           1        2     ころ   名詞 副詞可能        <NA>
#> 3      1           1        3 わたくし   名詞     一般        <NA>
#> 4      1           1        4       は   助詞     <NA>        <NA>
#> 5      1           1        5       、   記号     <NA>        <NA>
#> 6      1           1        6 モリーオ   名詞     地域        <NA>
head(gibasa::prettify(res, col_select = c("POS1", "Original")))
#>   doc_id sentence_id token_id    token   POS1 Original
#> 1      1           1        1     その 連体詞     その
#> 2      1           1        2     ころ   名詞     ころ
#> 3      1           1        3 わたくし   名詞 わたくし
#> 4      1           1        4       は   助詞       は
#> 5      1           1        5       、   記号       、
#> 6      1           1        6 モリーオ   名詞     <NA>
```

### Pack output

``` r
res <- gibasa::prettify(res)
gibasa::pack(res)
#>   doc_id
#> 1      1
#> 2      2
#> 3      3
#> 4      4
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             text
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     その ころ わたくし は 、 モリーオ 市 の 博物 局 に 勤め て 居り まし た 。
#> 2 十 八 等 官 でし た から 役所 の なか でも 、 ず うっ と 下 の 方 でし た し 俸給 も ほんの わずか でし た が 、 受持ち が 標本 の 採集 や 整理 で 生れ 付き 好き な こと でし た から 、 わたくし は 毎日 ずいぶん 愉快 に はたらき まし た 。 殊に その ころ 、 モリーオ 市 で は 競馬 場 を 植物 園 に 拵え 直す と いう ので 、 その 景色 の いい まわり に アカシヤ を 植え込ん だ 広い 地面 が 、 切符 売場 や 信号 所 の 建物 の つい た まま 、 わたくし ども の 役所 の 方 へ まわっ て 来 た もの です から 、 わたくし は すぐ 宿直 という 名前 で 月賦 で 買っ た 小さな 蓄音器 と 二 十 枚 ばかり の レコード を もっ て 、 その 番小屋 に ひとり 住む こと に なり まし た 。 わたくし は そこ の 馬 を 置く 場所 に 板 で 小さな し きい を つけ て 一疋 の 山羊 を 飼い まし た 。 毎朝 その 乳 を しぼっ て つめたい パン を ひたし て た べ 、 それ から 黒い 革 の かばん へ すこし の 書類 や 雑誌 を 入れ 、 靴 も きれい に みがき 、 並木 の ポプラ の 影法師 を 大股 にわたって 市 の 役所 へ 出 て 行く の でし た 。
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          あの イーハトーヴォ の すきとおっ た 風 、 夏 で も 底 に 冷た さ を もつ 青い そら 、 うつくしい 森 で 飾ら れ た モリーオ 市 、 郊外 の ぎらぎら ひかる 草 の 波 。
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           また その なか で いっしょ に なっ た たくさん の ひと たち 、 ファゼーロ と ロザーロ 、 羊 飼 の ミーロ や 、 顔 の 赤い こども たち 、 地主 の テーモ 、 山猫 博士 の ボーガント・デストゥパーゴ など 、 いま この 暗い 巨 き な 石 の 建物 の なか で 考え て いる と 、 みんな むかし 風 の なつかしい 青い 幻 燈 の よう に 思わ れ ます 。 で は 、 わたくし は いつか の 小さな み だし を つけ ながら 、 しずか に あの 年 の イーハトーヴォ の 五月 から 十月 まで を 書きつけ ましょ う 。
gibasa::pack(res, POS1)
#>   doc_id
#> 1      1
#> 2      2
#> 3      3
#> 4      4
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         text
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 連体詞 名詞 名詞 助詞 記号 名詞 名詞 助詞 名詞 名詞 助詞 動詞 助詞 動詞 助動詞 助動詞 記号
#> 2 名詞 名詞 名詞 名詞 助動詞 助動詞 助詞 名詞 助詞 名詞 助詞 記号 助動詞 動詞 助詞 名詞 助詞 名詞 助動詞 助動詞 助詞 名詞 助詞 連体詞 副詞 助動詞 助動詞 助詞 記号 動詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 名詞 名詞 名詞 助動詞 名詞 助動詞 助動詞 助詞 記号 名詞 助詞 名詞 副詞 名詞 助詞 動詞 助動詞 助動詞 記号 副詞 連体詞 名詞 記号 名詞 名詞 助詞 助詞 名詞 名詞 助詞 名詞 名詞 助詞 動詞 動詞 助詞 動詞 助詞 記号 連体詞 名詞 助詞 形容詞 名詞 助詞 名詞 助詞 動詞 助動詞 形容詞 名詞 助詞 記号 名詞 名詞 助詞 名詞 名詞 助詞 名詞 助詞 動詞 助動詞 名詞 記号 名詞 名詞 助詞 名詞 助詞 名詞 助詞 動詞 助詞 動詞 助動詞 名詞 助動詞 助詞 記号 名詞 助詞 副詞 名詞 助詞 名詞 助詞 名詞 助詞 動詞 助動詞 連体詞 名詞 助詞 名詞 名詞 名詞 助詞 助詞 名詞 助詞 動詞 助詞 記号 連体詞 名詞 助詞 副詞 動詞 名詞 助詞 動詞 助動詞 助動詞 記号 名詞 助詞 名詞 助詞 名詞 助詞 動詞 名詞 助詞 名詞 助詞 連体詞 助動詞 名詞 助詞 動詞 助詞 名詞 助詞 名詞 助詞 動詞 助動詞 助動詞 記号 名詞 連体詞 名詞 助詞 動詞 助詞 形容詞 名詞 助詞 動詞 動詞 助動詞 助詞 記号 名詞 助詞 形容詞 名詞 助詞 名詞 助詞 副詞 助詞 名詞 助詞 名詞 助詞 動詞 記号 名詞 助詞 名詞 助詞 動詞 記号 名詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 動詞 助詞 動詞 名詞 助動詞 助動詞 記号
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          連体詞 名詞 助詞 動詞 助動詞 名詞 記号 名詞 助詞 助詞 名詞 助詞 形容詞 名詞 助詞 動詞 形容詞 感動詞 記号 形容詞 名詞 助詞 動詞 動詞 助動詞 名詞 名詞 記号 名詞 助詞 副詞 動詞 名詞 助詞 名詞 記号
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   接続詞 連体詞 名詞 助詞 名詞 助詞 動詞 助動詞 名詞 助詞 名詞 名詞 記号 名詞 助詞 名詞 記号 名詞 名詞 助詞 名詞 助詞 記号 名詞 助詞 形容詞 名詞 名詞 記号 名詞 助詞 名詞 記号 名詞 名詞 助詞 名詞 助詞 記号 名詞 連体詞 形容詞 名詞 助動詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 動詞 助詞 動詞 助詞 記号 名詞 名詞 名詞 助詞 形容詞 形容詞 名詞 名詞 助詞 名詞 助詞 動詞 動詞 助動詞 記号 助動詞 助詞 記号 名詞 助詞 名詞 助詞 連体詞 接頭詞 名詞 助詞 動詞 助詞 記号 名詞 助詞 連体詞 名詞 助詞 名詞 助詞 名詞 助詞 名詞 助詞 助詞 動詞 助動詞 助動詞 記号
```

### Change dictionary

IPA, [UniDic](https://clrd.ninjal.ac.jp/unidic/),
[CC-CEDICT-MeCab](https://github.com/ueda-keisuke/CC-CEDICT-MeCab), and
[mecab-ko-dic](https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/)
schemes are supported.

``` r
## UniDic 2.1.2
gibasa::gbs_tokenize("あのイーハトーヴォのすきとおった風", sys_dic = "/mecab/unidic-lite") |> 
    gibasa::prettify(into = gibasa::get_dict_features("unidic26")) |> 
    head()
#>   doc_id sentence_id token_id          token   POS1     POS2 POS3 POS4
#> 1      1           1        1           あの 感動詞 フィラー <NA> <NA>
#> 2      1           1        2 イーハトーヴォ   名詞 普通名詞 一般 <NA>
#> 3      1           1        3             の   助詞   格助詞 <NA> <NA>
#> 4      1           1        4     すきとおっ   動詞     一般 <NA> <NA>
#> 5      1           1        5             た 助動詞     <NA> <NA> <NA>
#> 6      1           1        6             風   名詞 普通名詞 一般 <NA>
#>       cType         cForm      lForm    lemma       orth       pron   orthBase
#> 1      <NA>          <NA>       アノ     あの       あの       アノ       あの
#> 2      <NA>          <NA>                                                     
#> 3      <NA>          <NA>         ノ       の         の         ノ         の
#> 4 五段-ラ行 連用形-促音便 スキトオル 透き通る すきとおっ スキトーッ すきとおる
#> 5 助動詞-タ   連体形-一般         タ       た         た         タ         た
#> 6      <NA>          <NA>       カゼ       風         風       カゼ         風
#>     pronBase goshu iType iForm fType fForm       kana   kanaBase       form
#> 1       アノ    和  <NA>  <NA>  <NA>  <NA>       アノ       アノ       アノ
#> 2                                                                          
#> 3         ノ    和  <NA>  <NA>  <NA>  <NA>         ノ         ノ         ノ
#> 4 スキトール    和  <NA>  <NA>  <NA>  <NA> スキトオッ スキトオル スキトオッ
#> 5         タ    和  <NA>  <NA>  <NA>  <NA>         タ         タ         タ
#> 6       カゼ    和  <NA>  <NA>  <NA>  <NA>       カゼ       カゼ       カゼ
#>     formBase iConType fConType aType               aConType aModeType
#> 1       アノ     <NA>     <NA>     0                   <NA>      <NA>
#> 2                                                                    
#> 3         ノ     <NA>     <NA>  <NA>                名詞%F1      <NA>
#> 4 スキトオル     <NA>     <NA>     3                     C1      <NA>
#> 5         タ     <NA>     <NA>  <NA> 動詞%F2@1,形容詞%F4@-2      <NA>
#> 6       カゼ     <NA>     <NA>     0                     C4      <NA>

## CC-CEDICT
gibasa::gbs_tokenize("它可以进行日语和汉语的语态分析", sys_dic = "/mecab/cc-cedict") |> 
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
gibasa::gbs_tokenize("하네다공항한정토트백", sys_dic = "/mecab/mecab-ko-dic") |> 
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
