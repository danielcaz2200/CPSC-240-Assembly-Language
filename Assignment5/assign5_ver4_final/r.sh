#!/bin/bash

# Delete some un-needed files
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -g -o manager.o manager.asm -gdwarf

echo "Assemble get_frequency.asm"
nasm -f elf64 -g -o get_frequency.o get_frequency.asm -gdwarf

echo "Assemble read_clock.asm"
nasm -f elf64 -g -o read_clock.o read_clock.asm -gdwarf

echo "Compile driver.cpp"
g++ -c -g -m64 -Wall -fno-pie -no-pie -o driver.o driver.cpp -std=c++17

echo "Link the object files"
g++ -g -m64 -no-pie -o time_elapsed.out -std=c++17 read_clock.o get_frequency.o driver.o manager.o

# Run the program
./time_elapsed.out