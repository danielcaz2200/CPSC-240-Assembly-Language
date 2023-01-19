// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Maxwell

/*
Copyright (C) 2021 Daniel Cazarez
This program is free software, you can redistribute it and or modify it
under the terms of the GNU General Public License version 3
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details
A copy of the GNU General Public License version 3 is available here: https://www.gnu.org/licenses/

Author Name: Daniel Cazarez
Author Email: danielcaz2200@csu.fullerton.edu

Program name: Hertz
Files in program: maxwell.c, hertz.asm, isfloat.c, r.sh
System requirements: Ubuntu Linux on an x86 machine
Programming languages: x86 Assembly, C and BASH
Date program development began: 10/20/2021
Date finished: 10/20/2021
Status: No known errors

Purpose: Provide a driver for hertz.asm, output power

File name: maxwell.c
Language: C
Data to module: None

Translation information
Compile this file: gcc -c -m64 -Wall -std=c11 -no-pie -o maxwell.o maxwell.c
Link the three files: gcc -m64 -std=c11 -no-pie -o power.out maxwell.o hertz.o isfloat.o
./power.out is the executable
*/

// include printf, atof, strlen
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
