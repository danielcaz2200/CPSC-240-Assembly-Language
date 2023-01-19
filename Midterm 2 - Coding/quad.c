// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Second Degree

// include printf, atof
#include <stdio.h>
#include <stdlib.h>

extern double second_degree();

int main()
{
    // Greet user
    printf("\nWelcome to the Quadratic Solver by Daniel C\n");

    // Return value from x86, set return_val to return value
    double return_val = second_degree();

    // Print return value
    printf("\nThe main function received %lf and will keep it.\n", return_val);
    printf("\nZero will be returned to the OS, bye.\n");

    // End program
    return 0;
}
