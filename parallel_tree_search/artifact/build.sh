#!/bin/bash

# When grammars have simple names, such as 'compiler' used here, the name
# may be used by others.  Thus, the 'touch' below ensures that we don't
# re-use compilation results from another grammar with the same name.

touch CompilerSpec.sv

PATH_TO_ableC="../../../ableC"

PATH_TO_extensions="../../../extensions"

PATH_TO_regex="../../../ableC/extensions/regex"

silver -I ../ \
       -I $PATH_TO_ableC \
       -I $PATH_TO_extensions \
       -I $PATH_TO_regex \
       -o ableC.jar $@ compiler

rm -f build.xml
