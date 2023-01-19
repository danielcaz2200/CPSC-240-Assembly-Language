// Student Name: Daniel Cazarez
// CPSC 240-05 
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: SSE Benchmarking

#include <stdio.h>
#include <stdlib.h>

// declare manager, which is the function to be used by the driver
extern double manager();

int main()
{
    printf("\nThis is the final exam by Daniel Cazarez.\n\n");

    // enter manager.asm
    double val_returned = manager();

    // print returned value from x86
    printf("\nThe program received %.2lf and will just keep it.\n", val_returned);
    printf("\nHave a nice day.\n\n");

    return 0;
}