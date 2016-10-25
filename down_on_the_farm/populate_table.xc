#include <stdlib.h>
#include <string.h>

#include "livestock.h"
#include "serialize.h"
#include "sqlite.xh"

int main() {
    Animal *stella = Chicken("Stella", Kale(), 0);
    Animal *ray = Chicken("Ray", Mealworms(), 5);
    Animal *winnie = Chicken("Winnie", Kale(), 2);
    Animal *chirpy = Chicken("Chirpy", Mealworms(), 4);

    Animal *edsger = Goat("Edsger", "24/04/2014", 15);
    Animal *henk = Goat("Henk", "21/10/2013", 12);
    Animal *luitzen = Goat ("Luitzen", "11/11/2011", 11);

    Animal *farm[7] = {stella, ray, winnie, chirpy, edsger, henk, luitzen};

    use "farm.db" with {
        table farm (serialized_animal VARCHAR)
    } as farm_db;

    unsigned int i;
    for (i=0; i < sizeof(farm) / sizeof(Animal *); ++i) {
        char *s_animal = serialize_animal(farm[i]);

        on farm_db commit {
            INSERT INTO farm VALUES (
                $( (const char *) s_animal )
            )
        };

        free(s_animal);
    }

    db_exit(farm_db);
}

