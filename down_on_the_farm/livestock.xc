#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "livestock.h"

void freeA (Animal *a) {
    match (a) {
        Chicken(_, t, _) -> { free(t); }
        Goat(_, _, x) -> { }
    };
    free (a);
}
