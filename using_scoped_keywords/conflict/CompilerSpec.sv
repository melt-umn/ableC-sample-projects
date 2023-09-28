grammar conflict;

{- This specification composes two grammars that define the same lexically scoped
 - keyword marking terminal.  
 - These must be disambiguated with transparent prefixes (see
 - using_transparent_prefixes sample project), and optionally a
 - preference to allow one terminal to be used without a prefix.
 -}
 
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extension grammars being used in this
  -- composition.  They make use of the default prefix
  -- seperator of "::" defined in the host langauge.

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_scoped_table prefix with "BT";

  -- Note that we do not specify a preference here for which
  -- terminal to select when no prefix is given.
  -- The default behavior for the disambiguation of two
  -- globally scoped keyword marking terminals is to permit
  -- neither and raise a syntax error.
}


function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return driver(args, io_in, extendedParser);
}
