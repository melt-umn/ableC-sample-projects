#!/bin/bash

if ./tests.sh; then
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
