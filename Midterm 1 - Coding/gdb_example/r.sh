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

echo "Assemble the X86 file."
nasm -f elf64 -l ohm.lis -o ohm.o ohm.asm -g -gdwarf

echo "Compile the C file."
gcc -c -m64 -Wall -std=c11 -no-pie -o faraday.o faraday.c -g

echo "Link the 'O' files."
gcc -m64 -std=c11 -no-pie -o power.out faraday.o ohm.o -g 

echo "Run the program power.out"
gdb ./power.out

echo "This Bash script file will now terminate.  Bye."



