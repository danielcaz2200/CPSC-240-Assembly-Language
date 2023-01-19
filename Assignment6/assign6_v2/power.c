// pow function
#include <math.h>
#include <stdio.h>

extern double power(double);

double power(double K)
{
    // comput negative 1 to some power
    double neg_1_to_power = pow(-1.0, K);
    return neg_1_to_power;

}