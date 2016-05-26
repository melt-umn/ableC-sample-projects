grammar compiler;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:parseAndPrint;

terminal Bogus_t 'bogus';

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;

  edu:umn:cs:melt:exts:ableC:tables;

  compiler; -- Need to include the current grammar for now to include any terminal defs
  --bogus_table;
  bogus_table prefix TableKwd_t with Bogus_t;
}

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  return driver(args, io_in, extendedParser);
}

