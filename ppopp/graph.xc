#include "tensors.xh"
#include "run.xh"
#include "lvars.xh"
#include "sum_int.xh"
#include "int_set.xh"
#include "int_set.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int FIB_ITERATIONS = 32;

tensor format ds ({dense, sparse});

tensor<ds> load_graph(const char *filename, int num_nodes, int num_edges) {
    int num_nodes = 7;
    tensor<ds> res = build(tensor<ds>)({num_nodes, num_nodes});

    // A very simple/small graph for testing purposes
    // Taken from https://hog.grinvin.org/ViewGraphInfo.action?id=736
    res[0, 6] = 1;
    
    res[1, 6] = 1;
    
    res[2, 6] = 1;
    
    res[3, 4] = 1;
    res[3, 5] = 1;
    
    res[4, 3] = 1;
    res[4, 5] = 1;
    
    res[5, 3] = 1;
    res[5, 4] = 1;
    res[5, 6] = 1;

    res[6, 0] = 1;
    res[6, 1] = 1;
    res[6, 2] = 1;
    res[6, 5] = 1;
/*
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        fprintf(stderr, "ERROR: could not open `%s`: %s\n", filename, strerror(errno));
	exit(255);
    }

    int found_edges = 0;
    int from, to;
    while (fscanf(fp, "%d %d\n", &from, &to) == 2) {
        res[from, to] = 1;
        res[to, from] = 1;
	found_edges++;
    }
    fclose(fp);

    if (found_edges != num_edges) {
        fprintf(stderr, "ERROR: expected %d edges, found %d edges\n", num_edges, found_edges);
	exit(255);
    }
*/   
    return res; 
}

Lvar<int> *accum;

int fib (int n) {
    if (n < 2) {
        return n;
    } else {
        int result1, result2;
        result1 = fib(n-1);
        result2 =  fib(n-2);
        return result1 + result2;
    }
}

void compute (int v) {
    int fibres1 = 0;
    int fibres2 = 0;
    int fibres3 = 0;
    for (int i=0; i < FIB_ITERATIONS; ++i) {
        fibres1 += fib(v % 20 + 4);
        fibres2 += fib(v % 15 + 9);
        fibres3 += fib(v % 10 + 11);
    }
    put ((fibres1 + fibres2 + fibres3)/3) in accum;
}

tensor<ds> edges;

void find_neighbors(int n, Lvar<IntSet*> *nbrs)
{
    indexvar i;
    foreach (double v : edges[n, i]) {
        put_int_set(nbrs, i);
    }
}

int main(int argc, char **argv) {

    if (argc < 2) {
      exit(0);
    }

    int NUM_THREADS = atoi(argv[1]);

    if (argc > 2) {
        FIB_ITERATIONS = atoi(argv[2]);
    }

    accum = makeLvar_sum_int();

    // from: http://snap.stanford.edu/data/ego-Facebook.html
    edges = load_graph("facebook_combined.txt", 4039, 88234);

    int start = 1;

    IntSet *new = new_intset();
    intset_insert(new, start);

    IntSet *seen = new_intset();

    Lattice<IntSet*> *D = lattice_int_set();

    while (!intset_is_empty(new)) {
//        cilk for n in new {
        IntSetItr *new_itr = new_intsetitr(new);
        while (intsetitr_has_next(new_itr)) {
           run compute(intsetitr_next(new_itr));
        }
        delete_intsetitr(new_itr);

        intset_union(seen, new);

        Lvar<IntSet*> *nbrs = newLvar(D);

        new_itr = new_intsetitr(new);
        while (intsetitr_has_next(new_itr)) {
            int n = intsetitr_next(new_itr);
            run find_neighbors(n, nbrs);
        }

        delete_intsetitr(new_itr);

	// TODO: use channels to sync here
//        sync;
        freeze(nbrs);
        IntSet* frozen_nbrs = get nbrs;

        intset_minus(get nbrs, seen);
        delete_intset(new);
        new = frozen_nbrs;
        freeLvar nbrs;
    }
    
    sync;

    freeze(accum);
    printf("Sum = ");
    display(accum);  
    printf("\n");
    Lattice<int>* lat = getLattice accum;
    freeLvar(accum);
    delete_intset(seen);
    free(lat);
    free(D);
    delete_intset(new);

    freeTensor(edges);

    return 0;
}

