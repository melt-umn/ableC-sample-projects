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

  edu:umn:cs:melt:exts:ableC:algDataTypes;

  edu:umn:cs:melt:exts:ableC:tables;

  edu:umn:cs:melt:exts:ableC:sqlite;
 
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
