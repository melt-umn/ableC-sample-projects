/* A program that searchs for regular expression matchs in strings
   contained in the nodes of an ADT tree.  This is done in parallel using
   Cilk constructs.
 */

typedef  datatype Tree  Tree;

datatype Tree {
    Fork (Tree*, Tree*, const char*);
    Leaf (const char*);
};

cilk int count_matches (Tree *t) {
  match (t) {
    Fork(t1,t2,str)-> { 
      int res_t1, res_t2;
      spawn res_t1 = count_matches(t1);
      spawn res_t2 = count_matches(t2);
      if ( str[0] =~ /foo[1-9]+/ )
        res_str = 1 ;
      else 
        res_str = 0;
      sync;
      cilk return res_t1 + res_t2 + res_str ; 
    }

    Leaf(/bar[1-9]+/) : { cilk return 1 ; }
    _ : { cilk return 0 ; }
  } ;
}


cilk int main (int argv, char **argv) {
    Tree *tree ;
    // read in a tree
    
    printf ("Number of matches = %d\n", count_matches(tree));

    cilk return 0;
}

