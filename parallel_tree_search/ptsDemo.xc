//DEMO:ableCforPTS
/* A program that searchs for regular expression matchs in strings
   contained in the nodes of an ADT tree.  This is done in parallel using
   Cilk constructs.
 */

//#include <stdio.h>
//#include <stdlib.h>

//#include <cilk.h>
//#include <cilk-cilk2c-pre.h>

//#include <regex.h>

typedef datatype Tree  Tree;

datatype Tree {
    Fork (Tree*, Tree*, const char*);
    Leaf (const char*);
};

allocate datatype Tree with malloc;

cilk int count_matches (Tree *t) ;

cilk int main (int argv, char **argc) {
    int count;
    Tree *tree ;
    tree =
      malloc_Fork (malloc_Fork ( malloc_Leaf ("hello"),
                                 malloc_Leaf ("world"),
                                 "123" ),
                   malloc_Fork ( malloc_Leaf ("abc000"),
                                 malloc_Leaf ("wow456wow"),
                                 "xyz" ),
                   "9");

    spawn count = count_matches(tree);
    sync;
    printf ("Number of matches = %d", count);
    if (count == 3)
      printf (" ... correct!\n");
    else
      printf (" ... incorrect. :(\n");

    cilk return 0;
}

cilk int count_matches (Tree *t0) {
    // A small bug in the Cilk extension requires this local variable
    // t for matching to work correctly.  The cilk extension is by far the
    // complex extension with several intricate tranformations and a few
    // tricky bugs remain.
    Tree *t = t0;

    match ( t ) {
        &Fork(t1,t2,str)-> {
            int res_t1, res_t2, res_str;
            spawn res_t1 = count_matches(t1);
            spawn res_t2 = count_matches(t2);

            if ( str =~ /[1-9]+/ )
	       // To use the transparent prefix, use this conditional
	       // instead of the one above.
	       // ( RX::match str against /[1-9]+/ )

                res_str = 1 ;
            else
                res_str = 0;

            sync;
            cilk return res_t1 + res_t2 + res_str ;
    }

    &Leaf( /[1-9]+/ ) -> { cilk return 1 ; }
    _ -> { cilk return 0 ; }
  } ;
}
