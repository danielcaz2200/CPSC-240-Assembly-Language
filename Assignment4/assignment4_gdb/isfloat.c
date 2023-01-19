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
    if (user_input[current_index] == '+' || user_input[current_index] == '-')
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