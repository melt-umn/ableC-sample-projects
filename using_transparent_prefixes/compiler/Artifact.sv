grammar compiler;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

import edu:umn:cs:melt:exts:ableC:tables;
import bogus_table;

{-
-- The initial specification, just listing the grammars.
-- The marking terminal disambiguation is not resolved.
parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables;
  bogus_table;
}
-}

{-
-- A specification with transparent prefixes.
-- This is one we might prefer to write.  It uses grammar order to
-- specify preferences and thus define all needed disambiguation
-- functions.  It also uses some suffix, such as ":", as 
-- specified in the host language that is added to the end of the
-- transparent prefix strings..

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables prefix 'table' with 'CT';
  bogus_table prefix 'table' with 'BT';
}
-}



{-
-- Another specification with transparent prefixes.
-- This is perhaps an acceptable thing to ask users to write now.

-- Copper printed out this list, to which users can refer.
-- [bogus_table:TableKwd_t,edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t]

-- Shorter names (TableKwd_t and Table_t) could also be used.  Suggesting that users
-- use the long names means they can just copy-and-paste these and don't need to know
-- how to pull the short name out.

-- Note: Extensions do need to export their marking terminals.
-- I don't believe we check this requirement.

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables prefix 
    edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t with "CT";

  bogus_table prefix bogus_table:TableKwd_t with "BT";

  prefix separator ":";

  preference [ bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t ];
}
-}



-- Another specification with transparent prefixes,
-- and the extra stuff we originally had to write, but hope to generate.
{-
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t
{ pluck edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t; }
-- generated from
--    preference [ bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t ];
-- just the full-name version of disambiguate TableKwd_t, Table_t {  pluck Table_t;  }

terminal Prefix_BT_t 'BT:';
terminal Prefix_CT_t 'CT:';
-- generated from the prefix-with clauses, use nubBy to remove dups
-- and the prefix separator clause.

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables prefix 
    edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t with Prefix_CT_t;

  bogus_table prefix bogus_table:TableKwd_t with Prefix_BT_t;

  compiler;
  -- generated, so as to include disambiguation function and terminal decls.
}-}

{- Current capabilities of what we can generate -}
disambiguate bogus_table:TableKwd_t, edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t
{ pluck edu:umn:cs:melt:exts:ableC:tables:tableExpr:Table_t; }

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables prefix with 'BT:';

  bogus_table prefix with 'CT:';
}


{-
-- This is the first working specification; Lucas wrote this one.
terminal Bogus_t 'bogus:';

disambiguate TableKwd_t, Table_t {  pluck Table_t;  }

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables;

  bogus_table prefix 'bogus:';
}
-}



function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}

