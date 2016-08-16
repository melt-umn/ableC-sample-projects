#!/bin/bash

# turn on option to exit on non-zero return code.
set -e -v

cd compiler
./build.sh --clean
java -jar ableC.jar demo.xc
gcc demo.pp_out.c
./a.out

cd ../alternate_terminals
./build.sh --clean
java -jar ableC.jar demo.xc
gcc demo.pp_out.c
./a.out

cd ../alternate_explicit
./build.sh --clean
java -jar ableC.jar demo.xc
gcc demo.pp_out.c
./a.out

set +v

