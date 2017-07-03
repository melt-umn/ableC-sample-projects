#include <stdio.h>
#include <stdlib.h>
#include <regex.h>

typedef  datatype Tree  Tree;
datatype Tree {
    Fork (Tree*, Tree*, const char*);
    Leaf (const char*);
};

cilk int count_matches (Tree *t) {
  match (t) {
    Fork(t1,t2,str) -> {
      int res_t1, res_t2;
      spawn res_t1 = count_matches(t1);
      spawn res_t2 = count_matches(t2);
      if ( str =~ /[1-9]*/ )
        res_str = 1;
      else
        res_str = 0;
      sync;
      cilk_return res_t1 + res_t2 + res_str;
    }

    Leaf(/[1-9]*/) -> { cilk_return 1; }
  } ;
}

cilk int main (int argc, char **argv) {
    Tree *tree;  // then, read in a tree
    printf ("Number of matches = %d\n", count_matches(tree));
    cilk_return 0;
}

