# Build user dictionary

Builds a UTF-8 user dictionary from a csv file.

## Usage

``` r
build_user_dic(dic_dir, file, csv_file, encoding)
```

## Arguments

- dic_dir:

  Directory where the source dictionaries are located. This argument is
  passed as '-d' option argument.

- file:

  Path to write the user dictionary. This argument is passed as '-u'
  option argument.

- csv_file:

  Path to an input csv file.

- encoding:

  Encoding of input csv files. This argument is passed as '-f' option
  argument.

## Value

A `TRUE` is invisibly returned if dictionary is successfully built.

## Details

This function is a wrapper around dictionary compiler of 'MeCab'.

Note that this function does not support auto assignment of word cost
field. So, you can't leave any word costs as empty in your input csv
file. To estimate word costs, use
[`posDebugRcpp()`](https://paithiov909.github.io/gibasa/reference/posDebugRcpp.md)
function.

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
  # write a csv file and compile it into a user dictionary
  csv_file <- tempfile(fileext = ".csv")
  writeLines(
    c(
      "qa, 0, 0, 5, \u304f\u3041",
      "qi, 0, 0, 5, \u304f\u3043",
      "qu, 0, 0, 5, \u304f",
      "qe, 0, 0, 5, \u304f\u3047",
      "qo, 0, 0, 5, \u304f\u3049"
    ),
    csv_file
  )
  build_user_dic(
    dic_dir = tempdir(),
    file = (user_dic <- tempfile(fileext = ".dic")),
    csv_file = csv_file,
    encoding = "utf8"
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
      tokenize("quensan", sys_dic = tempdir(), user_dic = user_dic)
    }
  )
}
#> reading /home/runner/work/_temp/Library/gibasa/latin/unk.def ... 2
#> reading /home/runner/work/_temp/Library/gibasa/latin/dic.csv ... 450
#> reading /home/runner/work/_temp/Library/gibasa/latin/matrix.def ... 1x1
#> 
#> done!
#> reading /tmp/RtmpmfGt9N/file1b0a30757e2a.csv ... 5
#> 
#> done!
#> # A tibble: 5 × 5
#>   doc_id sentence_id token_id token feature
#>   <fct>        <int>    <int> <chr> <chr>  
#> 1 1                1        1 qu    く     
#> 2 1                1        2 e     え     
#> 3 1                1        3 n     ん     
#> 4 1                1        4 sa    さ     
#> 5 1                1        5 n     ん     
# }
```
