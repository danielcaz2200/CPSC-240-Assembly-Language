// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Second Degree

#include <iostream>
#include <cmath>

extern "C" double tworoots(double a, double b, double discriminant);

double tworoots(double a, double b, double discriminant)
{
	// calculate root for quadratic with discriminant greater than 0
	double x1, x2;
    x1 = (-b + sqrt(discriminant)) / (2 * a);
    x2 = (-b - sqrt(discriminant)) / (2 * a);
    std::cout << "The two roots are " << x1 << " and " << x2 << ". Have a nice day." << std::endl;
	std::cout << std::endl;
	
	// return discriminant sqrt
	double return_val = sqrt(discriminant);
	
	return return_val;
}