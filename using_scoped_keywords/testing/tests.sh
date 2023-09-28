#!/bin/bash

# turn on option to exit on non-zero return code.
set -e -v

cd ../compiler
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

cd ../conflict
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

cd ../preference
./build.sh $@
java -Xss6M -jar ableC.jar demo.xc
gcc demo.c
./a.out

