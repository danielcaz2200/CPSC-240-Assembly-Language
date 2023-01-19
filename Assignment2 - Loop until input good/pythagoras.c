/*
Copyright 2021 Daniel Cazarez
This program is free software, you can redistribute it and or modify it
under the terms of the GNU General Public License version 3
A copy of the GNU General Public License version 3 is available here: https://www.gnu.org/licenses/

Author Name: Daniel Cazarez
Author Email: danielcaz2200@csu.fullerton.edu

Program name: Triangle Calculator v2.0
Files in program: Triangle.asm, Pythagoras.c, r.sh
System requirements: Linux on an x86 machine
Programming languages: x86 Assembly, C and BASH
Date program development began: Aug 25, 2021
Date finished: Sept 2, 2021
Status: No known errors

Purpose: To calculate the area and hypotenuse of a triangle, based on user input. 
Afterwards, the ASM program will return the value to the C caller.

File name: pytagoras.c
Language: C
This module receives a floating point number from the Assembly module.

Translation information
Compile this file: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o pythagoras.o pythagoras.cpp
Link the two files: g++ -m64 -std=c++14 -fno-pie -no-pie -o calculator.out pythagoras.o triangle.o
./calculator.out is the executable
*/

// include printf
#include <stdio.h>

// for C, extern is only needed without the "C" directive
extern double triangle();

int main()
{
    // Greet user 
    printf("Welcome to the Right Triangles program maintained by Daniel C\n");
    printf("If errors are discovered please report them to danielcaz2200@csu.fullerton.edu for a quick fix.\n");

    // Return value from x86, set hypotenuse to the return value
    double hypotenuse = triangle();
    if (hypotenuse == 0) {
    	printf("\nThe main function received 0, please restart the program.\n");
    	return -1;
    }

    // Print out the value, format it so that it only prints up to the 4th decimal point
    printf("\nThe main function received %.4lf and plans to keep it\n", hypotenuse);
    printf("The integer 0 will be returned to the OS.\n");

    return 0;
}
