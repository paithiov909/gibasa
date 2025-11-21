# Get transition cost between pos attributes

Gets transition cost between two pos attributes for a given dictionary.
Note that the valid range of pos attributes differs depending on the
dictionary. If `rcAttr` or `lcAttr` is out of range, this function will
be aborted.

## Usage

``` r
get_transition_cost(rcAttr, lcAttr, sys_dic = "", user_dic = "")
```

## Arguments

- rcAttr:

  Integer; the right context attribute ID of the right-hand side of the
  transition.

- lcAttr:

  Integer; the left context attribute ID of the left-hand side of the
  transition.

- sys_dic:

  Character scalar; path to the system dictionary for 'MeCab'.

- user_dic:

  Character scalar; path to the user dictionary for 'MeCab'.

## Value

An integer scalar.
