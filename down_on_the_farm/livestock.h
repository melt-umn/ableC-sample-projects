#ifndef __LIVESTOCK_H
#define __LIVESTOCK_H

typedef datatype Treat  Treat;
datatype Treat { Kale(); Mealworms(); };

typedef datatype Animal  Animal;

datatype Animal {
    Chicken (const char*, Treat*, int);  // name, favorite treat, eggs per week
    Goat (const char*, const char*, int);      // name, birthday, gallons per week
};


void freeA(Animal *);

#endif

