# Using scoped keywords

This sample project demonstrates the use of lexically scoped disambiguation.

Extensions may often wish to introduce new keyword marking terminals that are lexically ambiguous with host terminals such as identifiers (e.g. 'table' in the case of the condition tables extension.)  One solution to this is to use lexical precedence, in which any occurrence of the identifier terminal is dominated by the new keyword; however this has the unintended side-effect of breaking host-language code that uses an identifier of the same name.  This is a major issue in C as host-language code is often present in third-party header files, for which it is not possible to specify transparent prefixes.

Another solution is to instead define disambiguation functions/groups that always pick the new extension terminal in cases when the extension terminal is valid, but otherwise permits the host terminal in different contexts.  This is a better approach, although it can still affect host code in some cases, and requires the frequent specification of disambiguation preferences at composition time, especially when using extensions that define identifier marking terminals using the Scoped disambiguation class.

An even better alternative is to treat extension marking terminals as identifiers that are defined in a global scope, similarly to identifiers defined in imported header files; this is possible by using the `Global` lexer class.  If a definition with the same name lexically shadows a global extension keyword, that name is disambiguated to the corresponding identifier terminal; however, the extension keyword may still be referenced using transparent prefixes.  This can be seen in the `compiler` example using the condition tables extension.

It is occasionally the case that two extensions define the same name as a marking terminal using the `Global` lexer class (this is analogous to the case of two C header files defining the same name.)  Since this class provides disambiguation there is not a lexical ambiguity when building the compiler; instead, the default behavior is to disallow both conflicting extension terminals by raising a syntax error.  However, it is still possible to reference both extension terminals using transparent prefixes (as seen in the `conflict` example) or override the scoped resolution mechanism by defining an explicit preference (as in the `preference` example.)

## Running the examples

To use each of these, change into the directory and then

1. build the `ableC` compiler
   ```
   % ./build.sh --clean
   ```

2. use it on the sample program
   ```
   % java -jar ableC.jar demo.xc
   ```

3. compile the resulting C program
   ```
   % gcc demo.c
   ```

4. run the program
   ```
   % ./a.out
   6
   Correct.
   ```

