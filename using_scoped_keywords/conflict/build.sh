#!/bin/bash

set -eu

# When grammars have simple names, such as 'compiler' used here, the name
# may be used by others.  Thus, the 'touch' below ensures that we don't
# re-use compilation results from another grammar with the same name.
touch CompilerSpec.sv

# We increase the stack and heap size for Ant so that Copper doesn't run
# out of memory when processing this grammar.  Since we have lexical
# ambiguities Copper uses a bit of memory to dump the parse table.
export ANT_OPTS="-Xss80M -Xmx4000M"

# Defaults if env var not set:
: ${ABLEC_BASE:=../../../ableC}
: ${EXTS_BASE:=../../../extensions}
: ${SVFLAGS:=""}

PATH_TO_tables="${EXTS_BASE}/ableC-condition-tables/grammars"

silver -I ../ \
       -I $ABLEC_BASE/grammars \
       -I $PATH_TO_tables \
       -o ableC.jar $SVFLAGS $@ conflict

rm -f build.xml
rm -f *.gen_cpp
rm -f *.c
rm -f *.out
