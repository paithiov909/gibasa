# Check if scalars are blank

Check if scalars are blank

## Usage

``` r
is_blank(x, trim = TRUE, ...)
```

## Arguments

- x:

  Object to check its emptiness.

- trim:

  Logical. If passed as `TRUE` and the object is a character vector,
  [`stringi::stri_trim()`](https://rdrr.io/pkg/stringi/man/stri_trim.html)
  is applied before checking.

- ...:

  Additional arguments for
  [`base::sapply()`](https://rdrr.io/r/base/lapply.html).

## Value

Logicals.

## Examples

``` r
is_blank(list(c(a = "", b = NA_character_), NULL))
#> [[1]]
#> [1] TRUE TRUE
#> 
#> [[2]]
#> [1] TRUE
#> 
```
