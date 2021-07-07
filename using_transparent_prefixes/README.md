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
`bogus_table`, and the `Identifier_t` and `TypeName_t` terminals from
the host language, with which it is also ambiguous.

```
  prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
```

## Running the examples

To use each of these, change into the directory and then

1. build the `ableC` compiler
   ```
   % ./build.sh --clean
   ```

2. use it on the sample program
   ```
   % java -jar ableC.jar demo.xc
   ```

3. compile the resulting C program
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
language is not used.

#### `alternate_explicit`

This example explicitly specifies the transparent prefix terminals and
the disambiguation function that are generated in the simple `compiler`
example.

#### `alternate_separator`

This example demonstrates the use of transparent prefixes for an extension that
uses a different prefix seperator than the default separator of `::` specified in
the host language.

Note that when specifying prefixes as strings, each prefix specification may only
specify a prefix for a set of terminals with the same prefix separator.  Thus 
the terminals for which to specify the prefix must be listed explicitly in this
example, rather than applying automatically to all terminals in the grammar.
