// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Maxwell

// include printf, atof
#include <stdio.h>
#include <stdlib.h>

// for C, extern is only needed without the "C" directive
extern double computations();

int main()
{
    // Greet user
    printf("Welcome to Power Unlimited brought to you by Daniel C.\n");

    // Return value from x86, set power_watts to return value
    double return_val = computations();

    // Print out the value, format it so that it only prints up to the 4th decimal point
    printf("The main function received %lf and will keep it.", return_val);
    printf("\nZero will be returned to the OS, bye.\n");
    // End program
    return 0;
}
