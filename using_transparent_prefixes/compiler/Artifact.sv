grammar compiler;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

import edu:umn:cs:melt:exts:ableC:tables;
import bogus_table;

disambiguate TableKwd_t, Table_t {
  pluck Table_t;
}

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables;

  --compiler; -- Need to include the current grammar for now to include any copper defs
  --bogus_table;
  bogus_table prefix 'bogus:';
}

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}

