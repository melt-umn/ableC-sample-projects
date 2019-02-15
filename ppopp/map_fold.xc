#include <stdlib.h>

int N = 1200;

int f(int n) {
  return n * n;
}

int g(int n, int m) {
  return n + m;
}

int main(void) {
  int *a = malloc(N * sizeof(int));

  map f a N;
  // forwards to:
  //({ int *result = malloc(N * sizeof(int));
  //   int *tmp_a = a;
  //   int tmp_N = N;
  //   for (int i=0; i < tmp_N; ++i) {
  //     result[i] = f(tmp_a[i]);
  //   }
  //   result;
  //});

  fold g a 1 N;
  // forwards to:
  //({ int result = 1;
  //   int *tmp_a = a;
  //   int tmp_N = N;
  //   for (int i=0; i < tmp_N; ++i) {
  //     result = g(result, tmp_a[i]);
  //   }
  //   result;
  //});
  
  fold g (map f a N) a 1 N;
  // naive forwards to:
  //({ int result = 1;
  //   int *tmp_a =
  //    ({ int *result = malloc(N * sizeof(int));
  //       int *tmp_a = a;
  //       int tmp_N = N;
  //       for (int i=0; i < tmp_N; ++i) {
  //         result[i] = f(tmp_a[i]);
  //       }
  //       result;
  //    });
  //   int tmp_N = N;
  //   for (int i=0; i < N; ++i) {
  //     result = g(result, tmp_a[i]);
  //   }
  //   result;
  //});

  // optimized forwards to:
  //({ int result = 1;
  //   int *tmp_a = a;
  //   int tmp_N = N;
  //   for (int i=0; i < tmp_N; ++i) {
  //     result = g(result, f(tmp_a[i]));
  //   }
  //   result;
  //});
}

