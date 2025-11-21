# Introduction to gibasa

## gibasaパッケージについて

gibasaは、Rから[MeCab](https://taku910.github.io/mecab/)を利用して形態素解析をおこなうためのパッケージです。

モチベーションとしては、[`tidytext::unnest_tokens`](https://juliasilge.github.io/tidytext/reference/unnest_tokens.html)を意識した処理をMeCabを利用しつつできるようにしたいということで開発しています。また、gibasaはv0.5.0からMeCabのソースコードをソースパッケージ内に含んでいるため、ビルドするのにMeCabのバイナリファイルを必要としないという長所があります。

### インストールの仕方

[CRAN](https://cran.r-project.org/package=gibasa)のほか、[r-universe](https://paithiov909.r-universe.dev/gibasa)からもインストールできます。

``` r
# Install gibasa from r-universe repository
install.packages("gibasa", repos = c("https://paithiov909.r-universe.dev", "https://cloud.r-project.org"))
```

バイナリパッケージが用意されていない環境では、ソースパッケージをビルドしてインストールします。ビルド時に`MECAB_DEFAULT_RC`という環境変数を内部的に指定するため、正しく動作させるには`mecabrc`ファイルとMeCabの辞書があらかじめ適切な位置に配置されている必要があります。使っているOSのパッケージマネージャなどからインストールしておいてください。

``` r
# Sys.setenv(MECAB_DEFAULT_RC = "/fullpath/to/your/mecabrc") # if necessary
remotes::install_github("paithiov909/gibasa")
```

Windowsの場合、ソースビルドには[Rtools](https://cran.r-project.org/bin/windows/Rtools/)が必要です。また、インストールの方法によらず、gibasaを使用するにはMeCabの辞書が必要なため、[これ](https://github.com/ikegami-yukino/mecab/releases/tag/v0.996.2)などを使ってMeCabをインストールしておいてください。

なお、v0.9.4から、オリジナルのMeCabと同様に`mecabrc`ファイルを参照できるようになったため、辞書と`mecabrc`ファイルが適切に配置されていれば、MeCabのバイナリががなくても形態素解析が可能になっています。`mecabrc`ファイルは、環境変数`MECABRC`で指定されたファイルか、`~/.mecabrc`というファイルが参照されます。

たとえば、IPA辞書（[ipadic](https://pypi.org/project/ipadic/)）をPyPIからダウンロードして利用するには、ターミナルから次のコマンドを実行します。

``` shell
$ python3 -m pip install ipadic
$ python3 -c "import ipadic; print('dicdir=' + ipadic.DICDIR);" > ~/.mecabrc
```

また、gibasaはMeCabのシステム辞書をビルドする機能もラップしているため、辞書のソースファイルを用意できれば、パッケージのインストール後に辞書を配置することによっても使用可能になります。たとえば、[kelpbeds](https://paithiov909.r-universe.dev/kelpbeds)というパッケージを利用してIPA辞書を配置して使えるようにするには、次のようにします。

``` r
install.packages("kelpbeds", repos = c("https://paithiov909.r-universe.dev", "https://cran.r-project.org"))

dic_dir <- fs::dir_create(file.path(Sys.getenv("HOME"), "ipadic-utf8"))
kelpbeds::prep_ipadic(dic_dir)
gibasa::build_sys_dic(
  dic_dir = dic_dir,
  out_dir = dic_dir,
  encoding = "utf8"
)
readr::write_lines(
  paste0("dicdir=", dic_dir),
  file.path(Sys.getenv("HOME"), ".mecabrc")
)
```

### 基本的な使い方

gibasaは、次にあげる関数を使って、CJKテキストの分かち書きをすることができるというパッケージです。

- [`gibasa::tokenize`](https://paithiov909.github.io/gibasa/reference/tokenize.md)
- [`gibasa::prettify`](https://paithiov909.github.io/gibasa/reference/prettify.md)
- [`gibasa::pack`](https://paithiov909.github.io/gibasa/reference/pack.md)

まず、`doc_id`列と`text`列をもつデータフレームについて、[`gibasa::tokenize`](https://paithiov909.github.io/gibasa/reference/tokenize.md)でtidy
textのかたちにできます（以下の例ではIPA辞書を使っています）。ちなみに、元のデータフレームの`doc_id`列と`text`列以外の列は戻り値にも保持されます。

``` r
gibasa::ginga[5]
#> [1] "　カムパネルラが手をあげました。それから四、五人手をあげました。ジョバンニも手をあげようとして、急いでそのままやめました。たしかにあれがみんな星だと、いつか雑誌で読んだのでしたが、このごろはジョバンニはまるで毎日教室でもねむく、本を読むひまも読む本もないので、なんだかどんなこともよくわからないという気持ちがするのでした。"

dat <- data.frame(
  doc_id = seq_along(gibasa::ginga[5:8]),
  text = gibasa::ginga[5:8],
  meta = c("aaa", "bbb", "ccc", "ddd")
)

res <- gibasa::tokenize(dat, text, doc_id)

head(res)
#> # A tibble: 6 × 6
#>   doc_id meta  sentence_id token_id token        feature                        
#>   <fct>  <chr>       <int>    <int> <chr>        <chr>                          
#> 1 1      aaa             1        1 　           記号,空白,*,*,*,*,　,　,　     
#> 2 1      aaa             1        2 カムパネルラ 名詞,一般,*,*,*,*,*            
#> 3 1      aaa             1        3 が           助詞,格助詞,一般,*,*,*,が,ガ,ガ
#> 4 1      aaa             1        4 手           名詞,一般,*,*,*,*,手,テ,テ     
#> 5 1      aaa             1        5 を           助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
#> 6 1      aaa             1        6 あげ         動詞,自立,*,*,一段,連用形,あげる,アゲ,アゲ……
```

[`gibasa::prettify`](https://paithiov909.github.io/gibasa/reference/prettify.md)で`feature`列の素性情報をパースして分割できます。このとき、`col_select`引数でパースしたい列を指定すると、それらの列だけをパースすることができます。

``` r
head(gibasa::prettify(res))
#> # A tibble: 6 × 14
#>   doc_id meta  sentence_id token_id token    POS1  POS2  POS3  POS4  X5StageUse1
#>   <fct>  <chr>       <int>    <int> <chr>    <chr> <chr> <chr> <chr> <chr>      
#> 1 1      aaa             1        1 　       記号  空白  NA    NA    NA         
#> 2 1      aaa             1        2 カムパネルラ…… 名詞  一般  NA    NA    NA         
#> 3 1      aaa             1        3 が       助詞  格助詞…… 一般  NA    NA         
#> 4 1      aaa             1        4 手       名詞  一般  NA    NA    NA         
#> 5 1      aaa             1        5 を       助詞  格助詞…… 一般  NA    NA         
#> 6 1      aaa             1        6 あげ     動詞  自立  NA    NA    一段       
#> # ℹ 4 more variables: X5StageUse2 <chr>, Original <chr>, Yomi1 <chr>,
#> #   Yomi2 <chr>
head(gibasa::prettify(res, col_select = 1:3))
#> # A tibble: 6 × 8
#>   doc_id meta  sentence_id token_id token        POS1  POS2   POS3 
#>   <fct>  <chr>       <int>    <int> <chr>        <chr> <chr>  <chr>
#> 1 1      aaa             1        1 　           記号  空白   NA   
#> 2 1      aaa             1        2 カムパネルラ 名詞  一般   NA   
#> 3 1      aaa             1        3 が           助詞  格助詞 一般 
#> 4 1      aaa             1        4 手           名詞  一般   NA   
#> 5 1      aaa             1        5 を           助詞  格助詞 一般 
#> 6 1      aaa             1        6 あげ         動詞  自立   NA
head(gibasa::prettify(res, col_select = c(1, 3, 5)))
#> # A tibble: 6 × 8
#>   doc_id meta  sentence_id token_id token        POS1  POS3  X5StageUse1
#>   <fct>  <chr>       <int>    <int> <chr>        <chr> <chr> <chr>      
#> 1 1      aaa             1        1 　           記号  NA    NA         
#> 2 1      aaa             1        2 カムパネルラ 名詞  NA    NA         
#> 3 1      aaa             1        3 が           助詞  一般  NA         
#> 4 1      aaa             1        4 手           名詞  NA    NA         
#> 5 1      aaa             1        5 を           助詞  一般  NA         
#> 6 1      aaa             1        6 あげ         動詞  NA    一段
head(gibasa::prettify(res, col_select = c("POS1", "Original")))
#> # A tibble: 6 × 7
#>   doc_id meta  sentence_id token_id token        POS1  Original
#>   <fct>  <chr>       <int>    <int> <chr>        <chr> <chr>   
#> 1 1      aaa             1        1 　           記号  　      
#> 2 1      aaa             1        2 カムパネルラ 名詞  NA      
#> 3 1      aaa             1        3 が           助詞  が      
#> 4 1      aaa             1        4 手           名詞  手      
#> 5 1      aaa             1        5 を           助詞  を      
#> 6 1      aaa             1        6 あげ         動詞  あげる
```

[`gibasa::pack`](https://paithiov909.github.io/gibasa/reference/pack.md)を使うと、`pull`引数で指定した列について、いわゆる「分かち書き」にすることができます。デフォルトでは`token`列について分かち書きにします。

``` r
res <- gibasa::prettify(res)
gibasa::pack(res)
#> # A tibble: 4 × 2
#>   doc_id text                                                                   
#>   <fct>  <chr>                                                                  
#> 1 1      　 カムパネルラ が 手 を あげ まし た 。 それ から 四 、 五 人 手 を あげ まし た 。 ジョバンニ も 手 を あげよ う…
#> 2 2      　 ところが 先生 は 早く も それ を 見つけ た の でし た 。            
#> 3 3      「 ジョバンニ さん 。 あなた は わかっ て いる の でしょ う 」         
#> 4 4      　 ジョバンニ は 勢い よく 立ちあがり まし た が 、 立っ て みる と もう はっきり と それ を 答える こと が でき ない…
gibasa::pack(res, POS1)
#> # A tibble: 4 × 2
#>   doc_id text                                                                   
#>   <fct>  <chr>                                                                  
#> 1 1      記号 名詞 助詞 名詞 助詞 動詞 助動詞 助動詞 記号 名詞 助詞 名詞 記号 名詞 名詞 名詞 助詞 動詞 助動詞 助動詞 記号 名詞 …
#> 2 2      記号 接続詞 名詞 助詞 形容詞 助詞 名詞 助詞 動詞 助動詞 名詞 助動詞 助動詞 記号……
#> 3 3      記号 名詞 名詞 記号 名詞 助詞 動詞 助詞 動詞 名詞 助動詞 助動詞 記号   
#> 4 4      記号 名詞 助詞 副詞 副詞 動詞 助動詞 助動詞 助詞 記号 動詞 助詞 動詞 助詞 副詞 副詞 助詞 名詞 助詞 動詞 名詞 助詞 動詞…
```

### 詳しい使い方

より詳しい使い方については、次のサイトを参照してください。

- [RとMeCabによる日本語テキストマイニングの前処理](https://paithiov909.github.io/textmining-ja/)

## ベンチマーク

[TokyoR
\#98](https://tokyor.connpass.com/event/244200/)での[LTのスライド](https://paithiov909.github.io/shiryo/gibasa/#11)でも紹介しましたが、ある程度の分量がある文字列ベクトルに対して、ごくふつうに形態素解析だけをやるかぎりにおいては、RMeCabよりもgibasaのほうが解析速度が速いと思います（というより、RMeCabでもMeCabを呼んでいる部分はおそらく十分速いのですが、欲しいかたちに加工するためのRの処理に時間がかかることが多いです）。

``` r
dat <- data.frame(
    doc_id = seq_along(gibasa::ginga),
    text = gibasa::ginga
)

gibasa <- function() {
    gibasa::tokenize(dat) |>
        gibasa::prettify(col_select = "POS1") |>
        dplyr::mutate(doc_id = as.integer(doc_id)) |>
        dplyr::select(doc_id, token, POS1) |>
        as.data.frame()
}

rmecab <- function() {
    purrr::imap_dfr(
        RMeCab::RMeCabDF(dat, 2),
        ~ data.frame(doc_id = .y, token = unname(.x), POS1 = names(.x))
    )
}

bench <- microbenchmark::microbenchmark(gibasa(),
                                        rmecab(),
                                        times = 20L,
                                        check = "equal")
ggplot2::autoplot(bench)
```

![benchmark1](https://rawcdn.githack.com/paithiov909/gibasa/7a3c17e807c3dda473f79f11b539a3e446e3ae6a/man/figures/benchmark1.png)

benchmark1
