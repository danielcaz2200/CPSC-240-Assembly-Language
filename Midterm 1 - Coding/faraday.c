// Student Name: Daniel Cazarez
// CPSC 240-05 
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Power In Watts Driver

// include printf
#include <stdio.h>

// for C, extern is only needed without the "C" directive
extern char* computations();

int main()
{
    // Greet user 
    printf("Welcome to the high voltage system program brought to you by Daniel C\n");

    // Return value from x86, set power_watts to return value
    char* name = computations();

    // Print out the value, format it so that it only prints up to the 4th decimal point
    printf("\nGoodbye %s. Have a nice research party.\n", name);
    printf("Zero will be returned to the OS.\n");

    // End program
    return 0;
}
