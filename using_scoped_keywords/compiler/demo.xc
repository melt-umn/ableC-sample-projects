#include <stdio.h>

int main() {
  // The transparent prefix isn't required when the table keyword
  // isn't lexically shadowed
  if(table { 1 : T F *
             0 : F * F
             1 : T * F }) {
    printf("Correct.\n");
  } else {
    printf("Incorrect.\n");
    return 1;
  }

  int table = 42;
  
  // Here 'table' gets parsed as an identifier
  printf("table: %d\n", table);

  // Using it as a keyword without the prefix is a syntax error
  //table { 1 : T };

  // The table extension may still be used with a prefix
  CT::table { 1 : T };
  
  return 0;
}
