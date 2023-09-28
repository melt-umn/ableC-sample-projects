grammar alternate_terminals;

{- This specification composes two grammars that lead to a lexical
   ambiguity.  

   This example specifies the regular expressions for transparent
   prefix terminal symbols explicitly, thus the prefix separator of
   the host langauge is not used.

 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- Specify a terminal literal that is used directly to declare a
  -- prefix terminal Lexer classes, etc. can also be included after
  -- the terminal specification.  Note that the `prefix separator`
  -- specification is not used but the `::` are instead part of the
  -- regular expression for the prefix terminal.
  edu:umn:cs:melt:exts:ableC:tables prefix with 'CT::';
  bogus_table prefix with /BT::/;

  -- Indicate that 'table' is to be scanned as the terminal from the
  -- `tableExpr` grammar.  It is preferred over the one from the
  -- `bogus_table` grammar.
  prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
    over bogus_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return driver(args, io_in, extendedParser);
}

