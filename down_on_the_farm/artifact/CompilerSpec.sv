grammar artifact;

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

  edu:umn:cs:melt:exts:ableC:algebraicDataTypes;

  edu:umn:cs:melt:exts:ableC:sqlite;

  edu:umn:cs:melt:exts:ableC:tables;
{- Not needed for the first few steps - 
  edu:umn:cs:melt:exts:ableC:regex; 

  -- Transparent prefixes
  edu:umn:cs:melt:exts:ableC:algebraicDataTypes prefix with "ADT";
  edu:umn:cs:melt:exts:ableC:regex prefix with "RX";

  -- Indicate that 'match' is to be scanned as the terminal from the
  -- `algDataTypes` grammar.  It is preferred over the one from the
  -- `regex` grammar.
  prefer
   edu:umn:cs:melt:exts:ableC:algebraicDataTypes:patternmatching:concretesyntax:matchKeyword:Match_t
  over
   edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose:RegexMatch_t;
-}
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
