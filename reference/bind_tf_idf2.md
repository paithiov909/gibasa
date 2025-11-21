# Bind term frequency and inverse document frequency

Calculates and binds the term frequency, inverse document frequency, and
TF-IDF of the dataset. This function experimentally supports 4 types of
term frequencies and 5 types of inverse document frequencies.

## Usage

``` r
bind_tf_idf2(
  tbl,
  term = "token",
  document = "doc_id",
  n = "n",
  tf = c("tf", "tf2", "tf3", "itf"),
  idf = c("idf", "idf2", "idf3", "idf4", "df"),
  norm = FALSE,
  rmecab_compat = TRUE
)
```

## Arguments

- tbl:

  A tidy text dataset.

- term:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing terms.

- document:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing document IDs.

- n:

  \<[`data-masked`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Column containing document-term counts.

- tf:

  Method for computing term frequency.

- idf:

  Method for computing inverse document frequency.

- norm:

  Logical; If passed as `TRUE`, TF-IDF values are normalized being
  divided with L2 norms.

- rmecab_compat:

  Logical; If passed as `TRUE`, computes values while taking care of
  compatibility with 'RMeCab'. Note that 'RMeCab' always computes IDF
  values using term frequency rather than raw term counts, and thus
  TF-IDF values may be doubly affected by term frequency.

## Value

A data.frame.

## Details

Types of term frequency can be switched with `tf` argument:

- `tf` is term frequency (not raw count of terms).

- `tf2` is logarithmic term frequency of which base is `exp(1)`.

- `tf3` is binary-weighted term frequency.

- `itf` is inverse term frequency. Use with `idf="df"`.

Types of inverse document frequencies can be switched with `idf`
argument:

- `idf` is inverse document frequency of which base is 2, with smoothed.
  'smoothed' here means just adding 1 to raw values after
  logarithmizing.

- `idf2` is global frequency IDF.

- `idf3` is probabilistic IDF of which base is 2.

- `idf4` is global entropy, not IDF in actual.

- `df` is document frequency. Use with `tf="itf"`.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
) |>
  dplyr::group_by(doc_id) |>
  dplyr::count(token) |>
  dplyr::ungroup()
bind_tf_idf2(df) |>
  head()
} # }
```
