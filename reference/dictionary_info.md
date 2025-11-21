# Get dictionary information

Returns all dictionary information under the current configuration.

## Arguments

- sys_dic:

  Character scalar; path to the system dictionary for 'MeCab'.

- user_dic:

  Character scalar; path to the user dictionary for 'MeCab'.

## Value

A data.frame (an empty data.frame if there is no dictionary configured
at all).

## Details

To use the
[`tokenize()`](https://paithiov909.github.io/gibasa/reference/tokenize.md)
function, there should be a system dictionary for 'MeCab' specified in
some 'mecabrc' configuration files with a line
`dicdir=<path/to/dir/dictionary/included>`. This function can be used to
check if such a configuration file exists.

Currently, this package detects 'mecabrc' configuration files that are
stored in the user's home directory or the file specified by the
`MECABRC` environment variable.

If there are no such configuration files, the package tries to fall back
to the 'mecabrc' file that is included with default installations of
'MeCab', but this fallback is not guaranteed to work in all cases.

In case there are no 'mecabrc' files available at all, this function
will return an empty data.frame.

Note that in this case, the
[`tokenize()`](https://paithiov909.github.io/gibasa/reference/tokenize.md)
function will not work even if a system dictionary is manually specified
via the `sys_dic` argument. In such a case, you should mock up a
'mecabrc' file to temporarily use the dictionary. See examples for
[`build_sys_dic()`](https://paithiov909.github.io/gibasa/reference/build_sys_dic.md)
and
[`build_user_dic()`](https://paithiov909.github.io/gibasa/reference/build_user_dic.md)
for details.

## Examples

``` r
if (FALSE) { # \dontrun{
dictionary_info()
} # }
```
