grammar alternate_separator;

-- This specification does not work!
-- See Silver issue #85
-- https://github.com/melt-umn/silver/issues/85
-- Specifying a prefix separator in a parser spec doesn't override the
-- one specified in the host language.  Instead is clashes with it.


{- This specification composes two grammars that lead to a lexical
   ambiguity. 

   This example specifies a *prefix separator* explicitly to override
   the default separator of `::` specified in the host language.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extensin grammars being used in this
  -- composition.

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table prefix with "BT";

  -- The following line overrides the prefix separator specified in
  -- ableC with a new one.
  prefix separator "@";

  -- Indicate that 'table' is to be scanned as the terminal from the
  -- `tableExpr` grammar.  It is preferred over the one from the
  -- `bogus_table` grammar.
  prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
    over bogus_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
