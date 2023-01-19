#!/bin/bash

#Delete some un-needed files
rm *.o
rm *.out

#echo "Assemble manager.asm"
nasm -f elf64 -o manager.o manager.asm

#echo "Assemble clockspeed.asm"
nasm -f elf64 -o clockspeed.o clockspeed.asm

#echo "Assemble read_clock.asm"
nasm -f elf64 -o readclock.o readclock.asm

#echo "Compile driver.cpp"
g++ -c -m64 -Wall -fno-pie -no-pie -o driver.o driver.cpp -std=c++17

#echo "Link the object files"
g++ -m64 -no-pie -o test.out -std=c++17 driver.o readclock.o manager.o clockspeed.o

#echo "\n----- Run the program -----"
./test.out

#echo "----- End Program -----"