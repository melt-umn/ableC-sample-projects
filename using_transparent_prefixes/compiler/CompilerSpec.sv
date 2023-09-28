grammar compiler;

{- This specification composes two grammars that lead to a lexical
   ambiguity.  There are few ways to resolve this, ranging from the
   rather simple, to more complex.

   Each is demonstrated with a different `parser` specification,
   starting with the `simpleExtendedParse`.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extensin grammars being used in this
  -- composition.  They make use of the default prefix
  -- separtor of "::" defined in the host langauge.

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table prefix with "BT";

  -- Indicate that 'table' is to be scanned as the terminal from the
  -- `tableExpr` grammar.  It is preferred over the one from the
  -- `bogus_table` grammar, and the host identifier terminals with
  -- which it is also ambiguous.
  prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
    over bogus_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return driver(args, io_in, extendedParser);
}
