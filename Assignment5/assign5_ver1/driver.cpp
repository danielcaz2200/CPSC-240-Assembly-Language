#include <stdio.h>
#include <stdlib.h>

extern "C" double manager();

int main()
{
    printf("Welcome to Gravitational Experiments by Daniel Cazarez\n");
    double return_val = manager();

    printf("The main function received %lf and will keep it\n", return_val);

    return 0;
}