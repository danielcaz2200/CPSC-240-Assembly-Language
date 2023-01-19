// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: IsFloat

/*
Copyright (C) 2021 Daniel Cazarez
This program is free software, you can redistribute it and or modify it
under the terms of the GNU General Lesser Public License
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details
A copy of the GNU Lesser General Public License is available here: https://www.gnu.org/licenses/

Author Name: Daniel Cazarez
Author Email: danielcaz2200@csu.fullerton.edu

Program name: Hertz
Files in program: maxwell.c, hertz.asm, isfloat.c, r.sh
System requirements: Ubuntu Linux on an x86 machine
Programming languages: x86 Assembly, C and BASH
Date program development began: 10/20/2021
Date finished: 10/20/2021
Status: No known errors

Purpose: Check if char array is a floating point number

File name: isfloat.c
Language: C
Data to module: char user_input[]

Translation information
Compile this file: gcc -c -m64 -Wall -std=c11 -no-pie -o isfloat.o isfloat.c
Link the three files: gcc -m64 -std=c11 -no-pie -o power.out maxwell.o hertz.o isfloat.o
./power.out is the executable
*/

// include printf and isdigit
#include <stdio.h>
#include <ctype.h>

// make ispositivefloat visible to any calling functions
extern int ispositivefloat(char[]);

int ispositivefloat(char user_input[])
{
    // print validating message
    printf("Validating input...\n");

    // assume the input is a float until
    // proven otherwise
    int result = 1;

    // decimal not found at the start of function
    int decimal_found = 0;

    // start index
    int current_index = 0;

    // check if index 0 is a plus sign, if so move
    // start index up one
    if (user_input[current_index] == '+')
    {
        ++current_index;
    }

    while (user_input[current_index] != '\0' && result)
    {
        // check if decimal is in string
        if ((user_input[current_index] == '.') && !decimal_found)
        {
            decimal_found = 1;
        }
        else
        {
            // is digit returns 0 if not digit, non-zero if digit
            if (isdigit(user_input[current_index]) == 0)
            {
                result = 0;
                break;
            }
        }
        ++current_index;
    }
	 // if result is true but no decimal found, prompt user for a decimal
    if (result && !decimal_found)
    {
        printf("Sorry, that was not a float, please input a decimal point as well.\n");
    }
    return (result && decimal_found);
}