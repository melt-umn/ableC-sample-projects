grammar artifact;

import edu:umn:cs:melt:ableC:drivers:compile;

construct ableC as
edu:umn:cs:melt:ableC:concretesyntax
translator using

  edu:umn:cs:melt:exts:ableC:sqlite;

  edu:umn:cs:melt:exts:ableC:tables;

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

