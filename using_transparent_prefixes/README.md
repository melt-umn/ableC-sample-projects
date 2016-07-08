# Using transparent prefixes

This sample project demonstrates how to use transparent prefixes to fix
any lexical ambiguities that arise when composing
independently-developed language extensions that have passed the
modular determinism analysis.  Any lexical ambiguities that arise when
these grammars are composed will involve a marking token from at least
one of the extensions.

In the examples here we compose two extensions
`edu:umn:cs:melt:exts:ableC:tables` (found in the extensions that are
part of `ableC`) and `bogus_table` found in this repository.

Both introduce a marking token with the regular expression `table`
(that occur in the same parsing context), and thus create a lexical 
ambiguity.

The directory `compiler` demonstrates the simplest and most
straightforward way to specify transparent prefixes to resolve the
ambiguity.  We expect this approach to work in nearly all situations.

In this simplest case, the programmer can add the prefix to be used
using the `prefix` clause and a double quoted string, as in the
following two lines from the specification:
```
  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table prefix with "BT";
```

These make use of the default prefix separator of "::" defined in the
host language.  (The separator syntax of `::` is chosen since it is
the same as the C++ scope operator and thus perhaps more familiar to
end users.)  With these specifications, writing `CT::table` in a
program will scan as the marking token from the first extension
listed, and `BT::table` will scan as the marking token for the second.

This specification also contains the following line which indicates
that writing `table` without a prefix will scan as a the token from
the first grammar.  It is preferred over the second one,
`bogus_table`.

```
  prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t;
```

## Running the examples

To uses each of these, change into the directory and then
1. build the `ableC` compiler
```
  % ./build.sh --clean
```

2. use it on the sample program
```
  % java -jar ableC.jar demo.xc
```

3. compiler the resulting C program
```
   % gcc demo.pp_out.c
```

4. run the program
```
   % ./a.out
   6
   Correct.
```

## Alternate compiler specifications

Three alternate specifications are also provided that illustrate
additional ways to resolve the ambiguity can be found in the
specification file.  These are more complex, but provide more
flexibility.

#### `alternate_terminals`

This example specifies the regular expressions for transparent prefix
terminal symbols explicitly, thus the prefix separator of the host
langauge is not used.

#### `alternate_explicit`

This example explicitly specifies the transparent prefix terminals and
the disambiugation function that are generated in the simple `compiler`
example.

#### `alternate_separator`

This example specifies a *prefix separator* explicitly to override the
default separator of `::` specified in the host language.

This specification does not yet work.
See Silver issue #85,
https://github.com/melt-umn/silver/issues/85.

Specifying a prefix separator in a parser spec doesn't override the
one specified in the host language.  Instead it clashes with it.

