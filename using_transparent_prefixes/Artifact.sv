grammar simple;

{- This specification composes two grammars that lead to a lexical
   ambiguity.  There are few ways to resolve this, ranging from the
   rather simple, to more complex.

   Each is demonstrated with a different `parser` specification,
   starting with the `simpleExtendedParse`.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

import edu:umn:cs:melt:exts:ableC:tables ;
import bogus_table ;

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, simpleExtendedParser);
}


parser simpleExtendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extensin grammars being used in this
  -- composition.  They make use of the default prefix
  -- separtor of ":" defined in the host langauge.

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table prefix with "BT";

  -- Indicate that 'table' is to be scanned as the terminal from the
  -- `tableExpr` grammar.  It is preferred over the one from the
  -- `bogus_table` grammar.
  prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t;
}


parser alternateExtendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- Specify a terminal literal that is used directly to declare a prefix terminal
  -- Lexer classes, etc. can also be included after the literal
  edu:umn:cs:melt:exts:ableC:tables prefix with 'CT:';
  bogus_table prefix with /BT:/;

  prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t;
}

parser explicitExtendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;
  explicit;
  
  -- Specify the names of terminals that are declared manually to use
  -- as prefixes.  This requires including the grammar with the terminals
  -- in the parser spec compiler;

  edu:umn:cs:melt:exts:ableC:tables prefix with TablePrefix_t;
  bogus_table prefix with BogusPrefix_t;

  --prefix separator ":"; -- Can override this optionally from withing 

  --prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t;
}


-- Things that could be specified manually
-- Disambiguation function
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t
{ pluck edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t; }
  
-- Prefix terminals
terminal BogusPrefix_t 'BT:';
terminal TablePrefix_t 'CT:';


