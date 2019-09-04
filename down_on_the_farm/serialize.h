#ifndef __SERIALIZE_H
#define __SERIALIZE_H

# include "livestock.h"

/** @return serialized representation (null terminated) of an animal (malloc-allocated, must be freed) */
char *serialize_animal(Animal a);
/** deserialize the animal represented by the serialized string; @return non-zero on error */
int deserialize_animal(Animal *a, const unsigned char *serialized_animal);

#endif

