grammar compiler;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:algebraicDataTypes prefix with "ADT";

  edu:umn:cs:melt:exts:ableC:regex prefix with "RX"; 

  edu:umn:cs:melt:exts:ableC:cilk;

  prefer
   edu:umn:cs:melt:exts:ableC:algebraicDataTypes:src:patternmatching:concretesyntax:matchKeyword:Match_t
  over
   edu:umn:cs:melt:exts:ableC:regex:regexMatching:RegexMatch_t;
--   edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose:RegexMatch_t;
  
}


function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}
