// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Second Degree

#include <iostream>
#include <cmath>

extern "C" double oneroot(double a, double b, double discriminant);

double oneroot(double a, double b, double discriminant)
{
	// calculate root for quadratic with discriminant of 0
	double x1;
	x1 = -b/(2*a);
    std::cout << "The one root is " << x1 << ". Have a nice day." << std::endl;
	std::cout << std::endl;
	// just return 0, since we would be doing the sqrt of 0.0
	double return_val = 0.0;
	
	return return_val;
}