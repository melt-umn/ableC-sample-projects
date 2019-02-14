# Down on the farm

This sample project demonstrates the use of the sqlite, conditional tables,
algebraic data types, and regular expression extensions to analyze a database
of farm animals to compute income and expenses.

The sqlite extension is used to open a connection to a database of farm
animals, execute a query selecting all such animals, and loop over the results.
The algebraic data types extension is then used to pattern match on each animal
to compute income and expenses as appropriate in each case. Condition tables
and regular expressions are used to ease the task of computing relatively
complex cases.

## Running the examples

1. Build the `ableC` compiler. This creates `ableC.jar`.
```
% make ableC.jar
```

2. Compile the sample programs. This uses `ableC.jar` to translate the
user-written extended C `accounting.xc` and `populate_table.xc` to plain C as
`accounting.c` and `populate_table.c`, then further uses gcc to create the
executables `accounting.out` and `populate_table.out`.
```
make all
```

3. Create an empty SQLite3 database called `farm.db`.
```
% ./create_database.sh
```

4. Populate `farm.db` with sample animals.
```
% ./populate_table.out
```

5. Analyze `farm.db` to compute income and expenses.
```
% ./accounting.out
```

