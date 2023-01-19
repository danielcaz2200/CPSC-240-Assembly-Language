#!/bin/bash

#Student Name: Daniel Cazarez
#CPSC 240-05
#Email: danielcaz2200@csu.fullerton.edu
#Script Title: BASH compile for C

rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "This will compile the C and assemble the ASM files, then link all."

echo "Assemble the X86 files"
nasm -f elf64 -o frequency.o frequency.asm -g -gdwarf

nasm -f elf64 -o read_clock.o read_clock.asm -g -gdwarf

nasm -f elf64 -o manager.o manager.asm -g -gdwarf

echo "Compile the C files."
gcc -c -m64 -Wall -std=c11 -no-pie -o driver.o driver.c -g

gcc -c -m64 -Wall -std=c11 -no-pie -o precision.o precision.c -g

gcc -c -m64 -Wall -std=c11 -no-pie -o iseven.o iseven.c -g

echo "Link the 'O' files."
gcc -m64 -std=c11 -no-pie -o summation.out driver.o manager.o frequency.o read_clock.o precision.o iseven.o -g

echo "Run the program summation.out"
gdb ./summation.out

echo "This Bash script file will now terminate.  Bye."



