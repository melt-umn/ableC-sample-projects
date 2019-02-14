#include "tensors.xh"
#include "string.xh"
#include <stdio.h>

tensor format src ({dense, sparse, sparse, sparse, sparse}, {0, 2, 1, 3, 4});
tensor format out ({dense});

// Our index variables
indexvar sI, sP, dI, dP, t;

int main() {
  tensor<src> dta = inst read_tensor<tensor<src>>("lbnl-network.tns");

  tensor<out> flattened = build(tensor<out>) ({dimenof(dta)[4]});

  flattened[t] = dta[sI, sP, dI, dP, t];

  // Free dta tensor (to hopefully free up memory)
  freeTensor(dta);

  tensor<out> result = build(tensor<out>)({dimenof(flattened)[0] / 3600});

  foreach(double v : flattened[t]) {
    int i = t / 3600;
    if(i < dimenof(result)[0]) {
      double init = result[i];
      result[i] = init + v;
    }
  }

  freeTensor(flattened);

  double min = 1.0 / 0.0;
  foreach(double v : result[t]) {
    if(v < min)
      min = v;
  }

  string s;
  s = "";
  foreach(double v : result[t]) {
    s += "|";
    s += str("*") * ((int)(v / min + 0.5));
    s += "\n";
  }

  // Free result tensor
  freeTensor(result);

  printf("%s", s.text);

  return 0;
}
