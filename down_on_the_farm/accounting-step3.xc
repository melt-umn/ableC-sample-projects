#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

#include "livestock.h"
#include "serialize.h"
#include "sqlite.xh"

int main() {
    printf("Accounting for \"Contrived Examples\" farm\n\n");

    float total_expenses = 0.0;
    float total_income = 0.0;

    int mood = 1;

    use "farm.db" with {
        table farm (serialized_animal VARCHAR)
    } as farm_db;

    on farm_db query {
        SELECT * FROM farm
    } as animal_rows;

    foreach (animal_row : animal_rows) {
        Animal *a = deserialize_animal(animal_row.serialized_animal);
        if (a == NULL) {
            continue;
        }

        float expenses = 0.0;
        float income = 0.0;

        match (a) {
            Chicken(nm, _, _) -> {
                printf("Chicken: %s\n", nm);
            }
            Goat(nm, bday, _) -> {
                printf("Goat: %s, birthday %s\n", nm, bday);
            }
        };
            
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
                        gallons > 10                 : * T
                        mood                         : F T } ) {
                     expenses = expenses + 5.00; // extra hay for the goats
                }
                
                expenses = expenses + gallons * 1.65; // feed cost per gallon
                income += gallons * 3.40;             // price per gallon
            }
        };
        
        printf("   expenses = %.2f\n", expenses);
        printf("   income   = %.2f\n", income);

        total_expenses += expenses;
        total_income += income;
        freeA(a);
    }

    printf ("\nTotals:\n");
    printf("   expenses = %.2f\n", total_expenses);
    printf("   income   = %.2f\n", total_income);

    finalize(animal_rows);
    db_exit(farm_db);
}

