// to take in user input
#include <stdio.h>

// to manipulate string
#include <stdlib.h>
#include <ctype.h>

// extern function so that assembly
// module can call it
extern double precision(void);

int ispositivefloat(char user_input[])
{
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
    return (result && decimal_found);
}


// function to be called, body of precision
double precision(void)
{
    // create array to store precision in
    char precision[25];

    // prompt for user input, then scanf into allocated array
    printf("\nPlease enter the precision number and press enter: ");
    scanf("%s", precision);

    // create int to store return
    int validation_result = 999;
    validation_result = ispositivefloat(precision);

    // declare precision_double
    double precision_double;

    // check if validation succeeded
    if (validation_result != 0)
    {
        precision_double = atof(precision);
		
		// print precision, after conversion
        printf("\nThe precision number you entered was: %lf, this will be returned to the caller.\n", precision_double);
    }
    else
    {
        // indicate error!
		printf("\nInvalid number!\n");
        precision_double = -1.0;
    }
	
    return precision_double;
}