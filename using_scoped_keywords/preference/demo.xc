#include <stdio.h>

int main() {

  printf("%d\n", BT::table 1, 2, 3);

  // Using the transparent prefix
  if(CT::table { 1 : T F *
                 0 : F * F
                 1 : T * F }) {
    printf("Correct.\n");
    return 0;
  } else {
    printf("Incorrect.\n");
    return 1;
  }

  // Omitting the transparent prefix allows condition tables to be used
  table { 1 : T };
}
