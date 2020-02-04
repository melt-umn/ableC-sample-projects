grammar alternate_separator;
{- This specification composes two grammars that lead to a lexical
   ambiguity. 

   In this example one grammar uses a different prefix seperator for
   some terminals than the default separator of `::` specified in the
   host language.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extension grammars being used in this
  -- composition.
  -- Note that bogus_table_separator exports multiple marking terminals
  -- with different prefix seperators, so the prefix must be specified
  -- specifically for each terminal.
  -- (Also note that we could have just specified a prefix for
  -- TableKwd, or different prefixes for the two.)

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table_separator
    prefix bogus_table_separator:TableKwd_t  with "BT"
    prefix bogus_table_separator:OtherKeyword_t  with "BT";

  -- Indicate that 'table' is to be scanned as the terminal from the
  -- `tableExpr` grammar.  It is preferred over the one from the
  -- `bogus_table` grammar.
  prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
    over bogus_table_separator:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
