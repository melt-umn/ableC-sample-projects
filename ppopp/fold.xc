#include "lvars.xh"
#include "int.xh"
#include "quiesce.xh"
#include "run.xh"

int TASK_SIZE;
int NUM_THREADS;
int N = 1200;

// example map function
int f(int i) {
  return i * i;
}

// example fold function
Value<int>* g(int a, int b) {
  return value (a + b);
}

int leq(int a, int b) {
  return a <= b;
}

Lvar<int>* accum;
Lvar<int>* done;

void task(int* xs) { 
  for (int i = 0; i < TASK_SIZE; ++i) { 
    put (f(xs[i])) in (accum);
  }
  done_task(done);
}

int main (int argc, char **argv) {
  accum = makeLvar_int(leq, g);
  done = make_quiescer();

  // declare, allocate and fill array `arr` with 
  // `NUM_THREADS * TASK_SIZE` values 

  if (argc < 2) {
    exit(0);
  }

  NUM_THREADS = atoi(argv[1]);
  if (N % NUM_THREADS != 0) {
    exit(0);
  }
  TASK_SIZE = N / NUM_THREADS;

  int* arr = malloc(N * sizeof(int));
  for (int i = 0; i < N; i++) {
    arr[i] = i + 1;
  }

  for (int i = 0; i < NUM_THREADS; ++i) {
    run task(&arr[i * TASK_SIZE]);
  }

  quiesce(done, NUM_THREADS);

  freeze accum;
  printf ("Result: %d\n", get accum);
  free(arr);
  free(getLattice(accum));
  free(accum);
  return 1;
}
