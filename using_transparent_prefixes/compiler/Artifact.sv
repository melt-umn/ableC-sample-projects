grammar compiler;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

-- Specify the seperator to append to a prefix when given as a string
prefix separator ":"; -- TODO: Move to ableC source

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- Specify a string that gets turned into a prefix terminal with the prefix seperator appended
  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_table prefix with "BT";

  {- Specify a terminal literal that is used directly to declare a prefix terminal
     Lexer classes, etc. can also be included after the literal
  edu:umn:cs:melt:exts:ableC:tables prefix with 'CT:';
  bogus_table prefix with /BT:/;
  -}

  {- Specify the names of terminals that are declared manually to use as prefixes
     This requires including the grammar with the terminals in the parser spec
  compiler;
  edu:umn:cs:melt:exts:ableC:tables prefix with TablePrefix_t;
  bogus_table prefix with BogusPrefix_t;
  -}

  --prefix separator ":"; -- Can override this optionally from withing 

  -- Specify a disambiguation function from withing the parser spec
  prefer edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t over bogus_table:TableKwd_t;
}
{- Things that could be specified manually
   Disambiguation function
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t
{ pluck edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t; }
  
  Prefix terminals
terminal BogusPrefix_t 'BT:';
terminal TablePrefix_t 'CT:';
-}

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}

