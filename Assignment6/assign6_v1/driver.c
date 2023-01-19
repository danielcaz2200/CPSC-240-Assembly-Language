#include <stdio.h>

extern double manager();

int main()
{
    // Greet user
    printf("Welcome to this program written by Daniel Cazarez.\n");

    // Return and print summation
    double summation = manager();
    printf("\nThe driver received this number %lf but has no knowledge about it.\n", summation);
    printf("\n0 will be returned to the O.S., bye.\n");

    return 0;
}