#!/bin/bash

#Student Name: Daniel Cazarez
#CPSC 240-05
#Email: danielcaz2200@csu.fullerton.edu
#Script Title: BASH compile for C

rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "This will compile the C++ and assemble the ASM file, then link the two."

echo "Assemble the X86 files, create two object files."
nasm -f elf64 -o second-degree.o second-degree.asm

echo "Compile the C/C++ files."
gcc -c -m64 -Wall -std=c11 -no-pie -o quad.o quad.c

g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o isfloat.o isfloat.cpp

g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o noroots.o noroots.cpp

g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o oneroot.o oneroot.cpp

g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o tworoots.o tworoots.cpp

echo "Link the 'O' files."
g++ -m64 -std=c++17 -fno-pie -no-pie -o quadratic.out quad.o second-degree.o isfloat.o noroots.o oneroot.o tworoots.o

echo "Run the program quadratic.out"
./quadratic.out

echo "This Bash script file will now terminate.  Bye."
