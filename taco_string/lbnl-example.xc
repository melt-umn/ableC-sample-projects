#include "tensors.xh"
#include "string.xh"
#include <stdio.h>

/*
 * This file contains a simple demonstration of how extensions can be combined. This
 * program uses the tensor algebra extension, to process network data and the string
 * extension to produce a visual graph of network traffic over time.
 * The lbnl-network.tns file provided and used herein, is from frostt.io
 */

// The network traffic data is represented by a 5th order tensor, in order the indices
// represent the sender's IP address, the sender's port number, the destination's IP
// address, the destination's port number, and the time.
// Since we expect every IP address contained in the network data to send at least one
// packet, we store that dimension densely. However, we do not expect every sender IP
// address to use every port, or contact every other address, or send packets continually
// and so store the remaining dimensions of the tensor sparsely. 
tensor format src ({dense, sparse, sparse, sparse, sparse}, {0, 2, 1, 3, 4});

// In reducing the tensor down to network usage over time, we are interested in creating
// a single dimensional tensor (a vector) where the index is time. Since the network is 
// constantly in use, we store this densely.
tensor format out ({dense});

// Our index variables (used for indexing into tensors)
indexvar sI, sP, dI, dP, t;

int main() {
  // Read the file lbnl-network.tns into the program
  tensor<src> dta = inst read_tensor<tensor<src>>("lbnl-network.tns");

  // Create a vector to store our initial "flattening" of the network data.
  tensor<out> flattened = build(tensor<out>) ({dimenof(dta)[4]});

  // To flatten this data, we access each element in the network data tensor, and
  // store them all into the flattened tensor, based on the timestamp of the packet.
  // Since sender IP (sI), sender port (sP), destination IP (dI), and destination
  // port (dP) are not used on the left-hand side, the compiler automatically adds
  // all values with the same timestamp together into flattened
  flattened[t] = dta[sI, sP, dI, dP, t];

  // Free dta tensor (to hopefully free up memory)
  freeTensor(dta);

  // Create a smaller vector, we do this because the original data was timestamped
  // by second, which would create an enourmous output, instead we choose to visualize
  // by hour (so we divide the size by 3600)
  tensor<out> result = build(tensor<out>)({dimenof(flattened)[0] / 3600});

  // In this loop we go through each value in the flattened tensor and add up all
  // network usage that occured in the same hour
  foreach(double v : flattened[t]) {
    int i = t / 3600; // Find the hour of this network usage value
    if(i < dimenof(result)[0]) { // This condition ignores the small spill-over at the end
      double init = result[i];
      result[i] = init + v;
    }
  }

  freeTensor(flattened);

  // This loop is intended to find the minimum value, as this will be used in properly
  // scaling the graph.
  double min = 1.0 / 0.0;
  foreach(double v : result[t]) {
    if(v < min)
      min = v;
  }

  string s;
  s = ""; // Create an empty string object
  foreach(double v : result[t]) { // Go through each hour
    s += "|";
    
    // Adds a number of stars based on how much higher the network usage was this hour
    // than at the minimum
    s += str("*") * ((int)(v / min + 0.5)); 
    
    s += "\n";
  }

  // Free result tensor
  freeTensor(result);

  printf("%s", s.text);

  return 0;
}
