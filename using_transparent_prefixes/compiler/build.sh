#!/bin/bash

# When grammars have simple names, such as 'compiler' used here, the name
# may be used by others.  Thus, the 'touch' below ensures that we don't
# re-use compilation results from another grammar with the same name.
touch Artifact.sv

# We increase the stack and heap size for Ant so that Copper doesn't run
# out of memory when processing this grammar.  Since we have lexical
# ambiguities Copper uses a bit of memory to dump the parse table.
export ANT_OPTS="-Xss80M -Xmx4000M"


PATH_TO_ableC="../../../../ableC_Home/ableC"

PATH_TO_tables="../../../../ableC_Home/ableC/extensions/conditional-tables"

silver -I ../ \
       -I $PATH_TO_ableC \
       -I $PATH_TO_tables \
       -o ableC.jar $@ compiler
