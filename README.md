
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gibasa

<!-- badges: start -->

![GitHub R package
version](https://img.shields.io/github/r-package/v/paithiov909/gibasa)
![GitHub](https://img.shields.io/github/license/paithiov909/gibasa)
[![R-CMD-check](https://github.com/paithiov909/gibasa/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/gibasa/actions)
<!-- badges: end -->

Gibasa is a plain ‘Rcpp’ interface to ‘MeCab’, a CJK tokenizer and
morphological analysis tool.

The main goal of gibasa package is to provide an alternative to
`tidytext::unnest_tokens` for CJK text data. For analyzing CJK text
data, it usually requires part-of-speech tagging, as most of them are
not separated with spaces and `tokenizers::tokenize_words` sometimes
splits them into erroneous tokens.

Gibasa provides 3 main functions: `gibasa::tokenize`,
`gibasa::prettify`, and `gibasa::pack`.

![image](man/figures/tidytext_fig5_1_mod.drawio.png)

-   `gibasa::tokenize` retrieves a TIF-compliant data.frame of corpus,
    returning tokens as format that known as ‘tidy text data’, so that
    users can replace `tidytext::unnest_tokens` with it for tokenizing
    CJK text.
-   `gibasa::prettify` turns tagged features into columns.
-   `gibasa::pack` retrieves a ‘tidy text data’, typically returning
    space-separated corpus.

## Installation

``` r
remotes::install_github("paithiov909/gibasa")
```

To install gibasa from source package requires the MeCab library
installed and available.

In case using Linux or Mac OSX, you can install that with their package
managers, or build and install from the source by yourself.

In case using Windows, launch msys2 console of the rtools, then install
MeCab and its dictionary with pacman before your installing package
(currently being tested on rtools42).

``` sh
$ pacman -Sy mingw-w64-ucrt-x86_64-mecab mingw-w64-ucrt-x86_64-mecab-naist-jdic
```

## Usage

### Tokenize sentences

``` r
res <- gibasa::tokenize(
  data.frame(
    doc_id = seq_len(length(audubon::polano[5:8])),
    text = audubon::polano[5:8]
  ),
  sys_dic = "/mecab/ipadic-utf8"
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
#> 6        <NA>        <NA>     <NA>
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

IPA, [UniDic](https://ccd.ninjal.ac.jp/unidic/),
[CC-CEDICT-MeCab](https://github.com/ueda-keisuke/CC-CEDICT-MeCab), and
[mecab-ko-dic](https://bitbucket.org/eunjeon/mecab-ko-dic/src/master/)
schemes are supported.

``` r
## UniDic (using UniDic-qkana_1603 here)
gibasa::gbs_tokenize("さうぢやない、あれはやまなしだ、流れて行くぞ。ついて行って見よう、あゝいゝ匂ひだな。", sys_dic = "/mecab/UniDic-qkana_1603") |> 
    gibasa::prettify(into = gibasa::get_dict_features("unidic26")) |> 
    head()
#>   doc_id sentence_id token_id token     POS1       POS2 POS3 POS4     cType
#> 1      1           1        1  さう     副詞       <NA> <NA> <NA>      <NA>
#> 2      1           1        2  ぢや   助動詞       <NA> <NA> <NA> 助動詞-ダ
#> 3      1           1        3  ない   形容詞 非自立可能 <NA> <NA>    形容詞
#> 4      1           1        4    、 補助記号       読点 <NA> <NA>      <NA>
#> 5      1           1        5  あれ   代名詞       <NA> <NA> <NA>      <NA>
#> 6      1           1        6    は     助詞     係助詞 <NA> <NA>      <NA>
#>         cForm lForm lemma orth pron orthBase pronBase goshu iType iForm fType
#> 1        <NA>  ソウ  そう さう ソー     サウ       和  さう  ソー  サウ  ソウ
#> 2 連用形-融合    ダ    だ ぢや ジャ     ヂヤ       和    だ    ダ    ダ    ダ
#> 3 終止形-一般  ナイ  無い ない ナイ     ナイ       和  ない  ナイ  ナイ  ナイ
#> 4        <NA>          、   、                   記号    、                  
#> 5        <NA>  アレ  彼れ あれ アレ     アレ       和  あれ  アレ  アレ  アレ
#> 6        <NA>    ハ    は   は   ワ       ハ       和    は    ワ    ハ    ハ
#>   fForm kana kanaBase form formBase iConType fConType
#> 1  <NA> <NA>     <NA> <NA>     <NA>     <NA>        1
#> 2  <NA> <NA>     <NA> <NA>     <NA>     <NA>     <NA>
#> 3  <NA> <NA>     <NA> <NA>     <NA>     <NA>        1
#> 4  <NA> <NA>     <NA> <NA>     <NA>     <NA>     <NA>
#> 5  <NA> <NA>     <NA> <NA>     <NA>     <NA>        0
#> 6  <NA> <NA>     <NA> <NA>     <NA>     <NA>     <NA>
#>                            aType aConType aModeType
#> 1                           <NA>     <NA>          
#> 2                        名詞%F1     <NA>          
#> 3                             C3     <NA>          
#> 4                           <NA>     <NA>          
#> 5                           <NA>     <NA>          
#> 6 動詞%F2@0,名詞%F1,形容詞%F2@-1     <NA>

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
