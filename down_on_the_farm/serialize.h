#ifndef __SERIALIZE_H
#define __SERIALIZE_H

# include "livestock.h"

/** @return serialized representation (null terminated) of an animal (allocated, must be freed) */
char *serialize_animal(Animal *a);
/** @return the animal represented by the serialized string; NULL on error */
Animal *deserialize_animal(const unsigned char *serialized_animal);

#endif

