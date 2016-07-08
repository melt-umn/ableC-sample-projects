#include <stdio.h>

int main() {

  printf("%d\n", BT@table 1, 2, 3);

  // Using the transparent prefix when it isn't required.  
  int c = CT@table { 1 : T F *
                     0 : F * F
                     1 : T * F } ;


  // Use of table extension without the transparent prefix since 
  // this one has precedence over the bogus-table one.
  if(table { 1 : T F *
             0 : F * F
             1 : T * F })
  {
    printf("Correct.\n");
    return 0;
  } else {
    printf("Incorrect.\n");
    return 1;
  }

}
