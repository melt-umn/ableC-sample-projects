#!/bin/bash
set -eu

main() {
	sqlite3=`find_sqlite3`

	# don't worry if test.db is already populated,
	# running on a pre-existing database will just print an error and exit
	echo "
		CREATE TABLE farm (
			serialized_animal VARCHAR
		);
	" | $sqlite3 "farm.db"
	echo "created farm.db"
}

# find the sqlite3 binary
# use binary in path if it exists, otherwise build from ../sqlite3/
find_sqlite3() {
	# TODO: better handle dependency on cwd
	top_level="."

	if which sqlite3 > /dev/null; then
		sqlite3=`which sqlite3`
	elif [ -f $top_level/sqlite/sqlite3.c ]; then
		make -sC $top_level/sqlite/
		sqlite3="$top_level/sqlite/sqlite3"
	else
		echo "ERROR: $top_level/sqlite3/sqlite3.c not found" >&2
		exit 255
	fi
	echo $sqlite3
}

main

