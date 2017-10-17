#!/bin/bash

# turn off option to exit on non-zero return code.
set +e

./tests.sh

if [ "$?" == "0" ]; then
    echo ""
    echo "Success!"
    echo ""
    exit 0
else
    echo ""
    echo "Tests failed!"
    echo ""
    exit 1
fi
