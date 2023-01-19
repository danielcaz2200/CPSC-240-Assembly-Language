#include <math.h>
#include <stdio.h>

extern int iseven(int iteration);

int iseven(int iteration)
{
    int ret_val = -1;
    // check if iteration is even
    if (iteration % 2 == 0)
    {
        ret_val = 0;
    }
    else
    {
        ret_val = 1;
    }
    return ret_val;
}