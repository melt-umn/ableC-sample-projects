#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "livestock.h"

int main() {
    printf("Accounting for \"Contrived Examples\" farm\n");
   
    Animal *stella = Chicken("Stella", Kale(), 0);
    Animal *ray = Chicken("Ray", Mealworms(), 5);
    Animal *winnie = Chicken("Winnie", Kale(), 2);
    Animal *chirpy = Chicken("Chirpy", Mealworms(), 4);

    Animal *edsger = Goat("Edsger", "24/04/2014", 15);
    Animal *henk = Goat("Henk", "21/10/2013", 12);
    Animal *luitzen = Goat ("Luitzen", "11/11/2011", 11);
            
    Animal *farm[7] = {stella, ray, winnie, chirpy, edsger, henk, luitzen};

    float expenses = 0.0;
    float income = 0.0;

    int mood = 1;
    
    for (int i=0; i<7; ++i) {
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
                        bday[2]=='1' && bday[3]=='0' : T F
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



    for (int i=0; i<7; ++i) {
        Animal *a = farm[i];
        freeA(a);
    }
    
}
