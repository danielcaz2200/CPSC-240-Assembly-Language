#include <math.h>
#include <stdio.h>

int main()
{
    double sum = 0.0;
	double precision = 0.0;
	double iteration = 0.0;
	double numerator = 0.0;
	double denom = 0.0;
	
	printf("\nPlease enter a precision number: ");
	scanf("%lf", &precision);
	
	int i = 0;
	while(1) {
        numerator = pow(-1.0, i);
		
        denom = ((2.0 * i) + 1.0);
        iteration = (numerator / denom);
		
        sum += iteration;
		
        printf("Iteration num: %.16lf\n", (iteration * 4.0));
		
		if (fabs((iteration * 4.0)) < precision) {
			break;
		}
		++i;
    }
	
	sum *= 4.0;
	
    printf("The sum is %lf\n", sum);
    return 0;
}