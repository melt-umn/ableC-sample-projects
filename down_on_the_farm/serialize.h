#ifndef __SERIALIZE_H
#define __SERIALIZE_H

# include "livestock.h"

/** @return serialized representation (null terminated) of an animal (allocated, must be freed) */
char *serialize_animal(Animal *a, size_t *len);

#endif

