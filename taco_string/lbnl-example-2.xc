#include "tensors.xh"
#include "string.xh"
#include <stdio.h>

tensor format src ({dense, sparse, sparse, sparse, sparse}, {0, 2, 1, 3, 4});
tensor format out ({dense, sparse});

// Our index variables
indexvar sI, sP, dI, dP, t;
indexvar snd, dst;

int main() {
  tensor<src> dta = inst read_tensor<tensor<src>>("lbnl-network.tns");

  tensor<out> result = 
    build(tensor<out>) ({dimenof(dta)[0], dimenof(dta)[2]});

  result[sI, dI] = dta[sI, sP, dI, dP, t];

  freeTensor(dta);

  string s;
  s = "";
  foreach(double v : result[snd, dst]) {
    if(v > 500000) {
      s += "(";
      s += snd;
      s += ",";
      s += dst;
      s += ")";
    } 
  }

  freeTensor(result);

  printf("%s\n", s.text);

  return 0;
}
