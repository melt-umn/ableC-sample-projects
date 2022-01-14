grammar preference;

{- This specification composes two grammars that define the same lexically scoped
 - keyword marking terminal.  
 - These must be disambiguated with transparent prefixes (see
 - using_transparent_prefixes sample project), and optionally a
 - preference to allow one terminal to be used without a prefix.
 -}
import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  -- The two lines below define the transparent prefix for
  -- the two different extension grammars being used in this
  -- composition.  They make use of the default prefix
  -- seperator of "::" defined in the host langauge.

  edu:umn:cs:melt:exts:ableC:tables prefix with "CT";
  bogus_scoped_table prefix with "BT";

  -- We can override the default scoped disamguation conflict behavior of
  -- disallowing both options by specifying an explicit preference.
  -- Here we specify that the condition tables 'table' keyword should be
  -- chosen over the bogus_scoped_table 'table' keyword and host terminals
  -- with which it is also lexically ambiguous.
  -- It would also be possible to explicitly prefer the bogus scoped table
  -- or even the host Identifer_t terminal, thus leaving the meaning of
  -- host code using 'table' as a variable name without prefixes to be unchanged.
  prefer edu:umn:cs:melt:exts:ableC:tables:concretesyntax:Table_t
    over bogus_scoped_table:TableKwd_t, cst:Identifier_t, cst:TypeName_t;
}


function main
IOVal<Integer> ::= args::[String] io_in::IOToken
{
  return driver(args, io_in, extendedParser);
}
