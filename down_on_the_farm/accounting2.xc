#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "livestock.h"
#include "serialize.h"
#include "sqlite.xh"

Animal **extract_farm_from_db(size_t *found_num_animals);

int main() {
    printf("Accounting for \"Contrived Examples\" farm\n");

    size_t num_animals = 0;
    Animal **farm = extract_farm_from_db(&num_animals);

    float expenses = 0.0;
    float income = 0.0;

    int mood = 1;

    for (int i=0; i<num_animals; ++i) {
        Animal *a = farm[i];
        match (a) {
            Chicken("Stella", _, _) -> {
                expenses = expenses + 10.00;  // amortized vet costs
            }
            Chicken(_, Mealworms(), eggs) -> {
                income = income + eggs * 0.10;    // price per egg
                expenses = expenses + eggs * 0.04 // food cost per egg
                                    + 0.25;       // mealworm costs
            }
            Chicken(_, Kale(), eggs) -> {
                expenses = expenses + 0.5 + 1.25; // special case
            }

            Goat(nm, bday, gallons) -> {
                if ( table {
                        bday[3]=='1' && bday[4]=='0' : T F
                        // match bday against /___10_*/ : T F
                        // bday ~= /.../ : T F
                        gallons > 10                 : * T
                        mood                         : F T })  {
                     expenses = expenses + 5.00; // extra hay for the goats
                }
                
                expenses = expenses + gallons * 1.65; // feed cost per gallon
                income += gallons * 3.40;             // price per gallon
            }
        };
        
    printf("Expenses = %.2f\n", expenses);
    }


    // free allocated datatype values
    for (int i=0; i<num_animals; ++i) {
        freeA(farm[i]);
    }

    free(farm);
}

Animal **extract_farm_from_db(size_t *found_num_animals)
{
    use "farm.db" with {
        table farm (serialized_animal VARCHAR)
    } as farm_db;

    on farm_db query {
        SELECT * FROM farm
    } as animals;

    /* count the animals */
    size_t num_animals = 0;
    foreach (a : animals) {
        ++num_animals;
    }

    Animal **farm = malloc(num_animals * sizeof(Animal *));

    /* extract the serialized representation of the animals and store in the
        farm */
    size_t i = 0;
    foreach (a : animals) {
        Animal *deser_a = deserialize_animal(a.serialized_animal);
        if (deser_a == NULL) {
            --num_animals;
        } else {
            farm[i++] = deser_a;
        }
    }

    if (found_num_animals != NULL) {
        *found_num_animals = num_animals;
    }

    return farm;
}

