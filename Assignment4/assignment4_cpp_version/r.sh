#!/bin/bash

#Student Name: Daniel Cazarez
#CPSC 240-05
#Email: danielcaz2200@csu.fullerton.edu
#Script Title: BASH compile for C

rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "This will compile the C and assemble the ASM file, then link the two."

echo "Assemble the X86 files, create two object files."
nasm -f elf64 -o hertz.o hertz.asm

echo "Compile the C/C++ files."
g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o maxwell.o maxwell.cpp

g++ -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o isfloat.o isfloat.cpp

echo "Link the 'O' files."
g++ -m64 -std=c++17 -fno-pie -no-pie -o power.out maxwell.o hertz.o isfloat.o

echo "Run the program power.out"
./power.out

echo "This Bash script file will now terminate.  Bye."



