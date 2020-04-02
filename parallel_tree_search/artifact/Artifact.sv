grammar artifact;

import edu:umn:cs:melt:ableC:drivers:compile;

construct ableC as
edu:umn:cs:melt:ableC:concretesyntax
translator using

  edu:umn:cs:melt:exts:ableC:algebraicDataTypes prefix with "ADT";

  edu:umn:cs:melt:exts:ableC:regex prefix with "RX";

  edu:umn:cs:melt:exts:ableC:regexPatternMatching;

  edu:umn:cs:melt:exts:ableC:cilk;

  prefer
   edu:umn:cs:melt:exts:ableC:algebraicDataTypes:patternmatching:concretesyntax:Match_t
  over
   edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose:RegexMatch_t,
   edu:umn:cs:melt:ableC:concretesyntax:Identifier_t,
   edu:umn:cs:melt:ableC:concretesyntax:TypeName_t;

