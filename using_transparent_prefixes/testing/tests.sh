#!/bin/bash

# turn on option to exit on non-zero return code.
set -e -v

cd ../compiler
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

cd ../alternate_terminals
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

cd ../alternate_explicit
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

cd ../alternate_separator
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

