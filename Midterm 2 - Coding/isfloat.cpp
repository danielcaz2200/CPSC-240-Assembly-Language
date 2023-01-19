// Student Name: Daniel Cazarez
// CPSC 240-05
// Email: danielcaz2200@csu.fullerton.edu
// Program Name: Second Degree

#include <iostream>

extern "C" bool isfloat(char [ ]);

bool isfloat(char w[ ])
{  
    // check if inputted string is a float
    bool result = true;
    bool onepoint = false;
    int start = 0;
    if (w[0] == '-' || w[0] == '+') start = 1;
    unsigned long int k = start;
    while (!(w[k] == '\0') && result )
    {    
         if (w[k] == '.' && !onepoint) 
               onepoint = true;
         else
               result = result && isdigit(w[k]);
         k++;
     }
     return result && onepoint;
}
