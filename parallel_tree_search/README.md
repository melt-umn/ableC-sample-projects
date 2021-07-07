# Parallel tree search

This sample project demonstrates the use of the algebraic data types, cilk, and
regular expression extensions to count in parallel the nodes in a binary tree
whose values match a given regular expression.

This project requires the Cilk runtime libraries. The best way to install this
is by running [this
script](http://melt.cs.umn.edu/downloads/install-cilk-libs.sh) which will put
them in ``/usr/local``.

## Running the examples

1. Build the `ableC` compiler. This creates `ableC.jar`.
   ```
   % make ableC.jar
   ```

2. Compile the sample program. This uses `ableC.jar` to translate the
   user-written extended C `pts.xc` to plain C as `pts.c`, then further uses gcc
   to create the executable `pts.out`.
   ```
   % make all
   ```

3. Run the sample program that counts the nodes in a binary tree whose values
   match a given regular expression.
   ```
   % ./pts.out
   ```

4. Run the sample program that in parallel by using `-nproc` option
   specifies the number of threads to run in parallel.
   ```
   % ./pts.out -nproc 4
   ```

