grammar alternate_explicit;

{- This specification composes two grammars that lead to a lexical
   ambiguity. 

   This example explicitly specifies the transparent prefix terminals
   and the disambiugation function that are generated in the `simple`
   example.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

import edu:umn:cs:melt:exts:ableC:tables ;
import bogus_table ;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- Since this grammar explicitly specifies terminals for transparent
  -- prefixes, it must be included in the parser specifiation.
  alternate_explicit;
  
  -- Specify the names of terminals that are declared manually to use
  -- as prefixes.  This requires including the grammar with the terminals
  -- in the parser spec compiler;
  edu:umn:cs:melt:exts:ableC:tables prefix with TablePrefix_t;
  bogus_table prefix with BogusPrefix_t;
}

{- Instead of writing the `prefer` clause

   prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
     over bogus_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;

   in the parser specification, one can write the resulting
   disambiguation functions manually, as is done below (note that
   a seperate disambiguation function is required for each combination
   of ambigous terminals.)  Since these terminals are named directly,
   the grammars declaring them are imported above.
-}
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t, cst:Identifier_t, cst:TypeName_t {
  pluck edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t;
}
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t, cst:Identifier_t {
  pluck edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t;
}


{- Similarly, one can define transparent prefix terminals explicitly
   instead of having the parser specification generate them.  The
   explicit specifications of the two for this example are below.
  -}
terminal BogusPrefix_t 'BT:';
terminal TablePrefix_t 'CT:';


function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return driver(args, io_in, extendedParser);
}
