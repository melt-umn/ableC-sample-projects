# Type qualifiers

This sample project demonstrates the use of several type qualifier extensions to
perform a computation over a tagged union and to trace the execution of a
recursive function.

The `nonnull` qualifier performs static checks that can prevent possible
dereferences of null by raising errors on such dereferences at compile time.

The `check` qualifier performs dynamic checks. Qualifying a tagged union with
`check` will cause code to be generated on each variant access to ensure at
runtime that the variant matches the current tag.

The `watch` qualifier demonstrates the code generation of type qualifiers beyond
error checking. Qualifying a function with `watch` will cause print statements
to be generated that display the arguments to the function prior to the call
and the return value after. Such output, as seen in the file tq_output.txt, can
be useful in debugging.

Our GPCE '17 paper below presents our formulation of type qualifiers in detail.

Type Qualifiers as Composable Language Extensions.
Travis Carlson and Eric Van Wyk,
In Proceedings of 16th ACM SIGPLAN International Conference on Generative
Programming: Concepts and Experiences (GPCE '17) ACM, 13 pages.


## Running the examples

1. Build the `ableC` compiler. This creates `ableC.jar`.   
   ```
   % make ableC.jar
   ```
   

2. Compile the sample program. This uses `ableC.jar` to translate the
   user-written extended C `tq.xc` to plain C as `tq.c`, then further uses gcc
   to create the executable `tq.out`.
   ```
   % make all
   ```

3. Run the sample program.
   ```
   % ./tq.out
   ```

