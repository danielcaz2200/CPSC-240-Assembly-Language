#include <stdio.h>  // scanf, printf
#include <stdlib.h> // atof

// Declare manager as extern
extern "C" double manager();

int main()
{
    // Greet user, then enter the manager program which will perform computations
    printf("\nWelcome to Gravitational Experiments by Daniel Cazarez\n\n");

    // Return nanoseconds to the main() function
    double return_val = manager();
	
    // Print out nanoseconds returned
    printf("\nThe main function received %0.2lf nanoseconds and will keep it.\n", return_val);
    printf("A zero will be returned to the OS. Bye.\n");

    return 0;
}