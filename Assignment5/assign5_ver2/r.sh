#!/bin/bash

#Delete some un-needed files
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -o manager.o manager.asm

echo "Assemble clockspeed.asm"
nasm -f elf64 -o clockspeed.o clockspeed.asm

echo "Compile driver.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o driver.o driver.cpp -std=c++17

echo "Link the object files"
g++ -m64 -no-pie -o time_elapsed.out -std=c++17 clockspeed.o driver.o manager.o

echo "\n----- Run the program -----"
./time_elapsed.out

echo "----- End Program -----"