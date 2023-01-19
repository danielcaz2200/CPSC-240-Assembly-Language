#!/bin/bash

#Student Name: Daniel Cazarez
#CPSC 240-05
#Email: danielcaz2200@csu.fullerton.edu
#Script Title: BASH compile script for C

rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "This will compile the C and assemble the ASM files, then link all."

echo "Assemble the X86 files"
nasm -f elf64 -o get_frequency.o get_frequency.asm

nasm -f elf64 -o read_clock.o read_clock.asm

nasm -f elf64 -o manager.o manager.asm

echo "Compile the C file"
gcc -c -m64 -Wall -std=c11 -no-pie -o driver.o driver.c

echo "Link the 'O' files."
gcc -m64 -std=c11 -no-pie -o time.out driver.o manager.o read_clock.o get_frequency.o 

echo "Run the program time.out"
./time.out

echo "This Bash script file will now terminate.  Bye."



