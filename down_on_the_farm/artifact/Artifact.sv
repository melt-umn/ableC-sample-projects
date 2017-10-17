grammar artifact;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:algebraicDataTypes;

  edu:umn:cs:melt:exts:ableC:sqlite;

  edu:umn:cs:melt:exts:ableC:tables;

  edu:umn:cs:melt:exts:ableC:regex; 

  -- Transparent prefixes to resolve lexical ambiguities.
  edu:umn:cs:melt:exts:ableC:algebraicDataTypes prefix with "ADT";
  edu:umn:cs:melt:exts:ableC:regex prefix with "RX";

  -- Indicate that 'match' is to be scanned as the terminal from the
  -- `algDataTypes` grammar.  It is preferred over the one from the
  -- `regex` grammar.
  prefer
   edu:umn:cs:melt:exts:ableC:algebraicDataTypes:patternmatching:concretesyntax:Match_t
  over
   edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose:RegexMatch_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
