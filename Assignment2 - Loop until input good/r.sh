#!/bin/bash

#Author: Daniel C
#Title: BASH compile for C

rm *.o
rm *.lis
rm *.out

echo " " #Blank line

echo "This will compile the C and assemble the ASM file, then link the two."

echo "Assemble the X86 file."
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

echo "Compile the C file."
gcc -c -m64 -Wall -std=c11 -no-pie -o pythagoras.o pythagoras.c

echo "Link the 'O' files."
gcc -m64 -std=c11 -no-pie -o calculator.out pythagoras.o triangle.o

echo "Run the program calculator.out"
./calculator.out

echo "This Bash script file will now terminate.  Bye."



