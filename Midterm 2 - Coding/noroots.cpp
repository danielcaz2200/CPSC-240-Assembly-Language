// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Second Degree

#include <iostream>
#include <cmath>

extern "C" void noroots();

void noroots()
{ 
	// don't do anything, since discriminant negative.
	std::cout << "Negative discriminant, no roots" << std::endl;
	std::cout << "Since the discriminant is negative, 0 will be returned" << std::endl;
	std::cout << std::endl;
	return;
}