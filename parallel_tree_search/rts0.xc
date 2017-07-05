/* A non-Cilk version.
 */

#include <stdio.h>
#include <stdlib.h>
#include <regex.h>

//#include <cilk.h>
//#include <cilk-cilk2c-pre.h>

typedef  datatype Tree  Tree;

datatype Tree {
    Fork (Tree*, Tree*, const char*);
    Leaf (const char*);
};


// cilk
int count_matches (Tree *t) {
    int foo = 0;
    match ( (Tree *) t) {
        Fork(t1,t2,str)-> { 
            int res_t1, res_t2;
            // spawn
	    res_t1 = count_matches(t1);
            // spawn
	    res_t2 = count_matches(t2);

            int res_str = 0;
            if ( str =~ /foo[1-9]+/ )
                res_str = 1 ;
            else 
                res_str = 0;

            // sync;
            // cilk
	    return res_t1 + res_t2 + res_str ; 
    }

    Leaf( /l/ ) -> {
        // cilk
	    return 1 ; }
    _ -> {
        // cilk
	  return 0 ; }
  } ;
}


//cilk
int main (int argv, char **argc) {
    Tree *tree ;
    tree =
        Fork (
            Fork ( Leaf ("hello"),
                   Leaf ("world"),
                   "foo123" ),
            Fork ( Leaf ("abc"),
                   Leaf ("456"),
                   "xyz" ),
            "789"
            );
            
    // read in a tree

    int result = 0;
    //spawn
    result = count_matches(tree);
    printf ("Number of matches = %d\n", result);

    // cilk 
    return 0;
}



