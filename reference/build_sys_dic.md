# Build system dictionary

Builds a UTF-8 system dictionary from source dictionary files.

## Usage

``` r
build_sys_dic(dic_dir, out_dir, encoding)
```

## Arguments

- dic_dir:

  Directory where the source dictionaries are located. This argument is
  passed as '-d' option argument.

- out_dir:

  Directory where the binary dictionary will be written. This argument
  is passed as '-o' option argument.

- encoding:

  Encoding of input csv files. This argument is passed as '-f' option
  argument.

## Value

A `TRUE` is invisibly returned if dictionary is successfully built.

## Details

This function is a wrapper around dictionary compiler of 'MeCab'.

Running this function will create 4 files: 'char.bin', 'matrix.bin',
'sys.dic', and 'unk.dic' in `out_dir`.

To use these compiled dictionary, you also need create a `dicrc` file in
`out_dir`. A `dicrc` file is included in source dictionaries, so you can
just copy it to `out_dir`.

## Examples

``` r
# \donttest{
if (requireNamespace("withr")) {
  # create a sample dictionary in temporary directory
  build_sys_dic(
    dic_dir = system.file("latin", package = "gibasa"),
    out_dir = tempdir(),
    encoding = "utf8"
  )
  # copy the 'dicrc' file
  file.copy(
    system.file("latin/dicrc", package = "gibasa"),
    tempdir()
  )
  # mocking a 'mecabrc' file to temporarily use the dictionary
  withr::with_envvar(
    c(
      "MECABRC" = if (.Platform$OS.type == "windows") {
        "nul"
      } else {
        "/dev/null"
      },
      "RCPP_PARALLEL_BACKEND" = "tinythread"
    ),
    {
      tokenize("katta-wokattauresikatta", sys_dic = tempdir())
    }
  )
}
#> reading /home/runner/work/_temp/Library/gibasa/latin/unk.def ... 2
#> reading /home/runner/work/_temp/Library/gibasa/latin/dic.csv ... 450
#> reading /home/runner/work/_temp/Library/gibasa/latin/matrix.def ... 1x1
#> 
#> done!
#> # A tibble: 11 × 5
#>    doc_id sentence_id token_id token feature
#>    <fct>        <int>    <int> <chr> <chr>  
#>  1 1                1        1 ka    か     
#>  2 1                1        2 tta   った   
#>  3 1                1        3 -     ー     
#>  4 1                1        4 wo    を     
#>  5 1                1        5 ka    か     
#>  6 1                1        6 tta   った   
#>  7 1                1        7 u     う     
#>  8 1                1        8 re    れ     
#>  9 1                1        9 si    し     
#> 10 1                1       10 ka    か     
#> 11 1                1       11 tta   った   
# }
```
