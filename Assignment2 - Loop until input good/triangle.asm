; Copyright 2021 Daniel Cazarez
; This program is free software, you can redistribute it and or modify it
; under the terms of the GNU General Public License version 3
; A copy of the GNU General Public License version 3 is available here: https://www.gnu.org/licenses/

; Author Name: Daniel Cazarez
; Author Email: danielcaz2200@csu.fullerton.edu

; Program name: Triangle Calculator v2.0
; Files in program: Triangle.asm, Pythagoras.cpp, r.sh
; System requirements: Ubuntu Linux on an x86 machine
; Programming languages: x86 Assembly, C++ and BASH
; Date program development began: Aug 25, 2021
; Date finished: Sept 2, 2021
; Status: No known errors

; Purpose: To calculate the area and hypotenuse of a triangle, based on user input.
; Afterwards, the ASM program will return the value to the C++ caller.

; File name: Triangle.asm
; Language: x86 Assembly
; This module receives no arguments.

; Translation information
; Compile this file: nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm
; Link the two files: g++ -m64 -std=c++14 -fno-pie -no-pie -o calculator.out pythagoras.o triangle.o
; ./calculator.out is the executable


; Declare external functions & make 'triangle' visible to C++ & declare constant
STRING_LEN equ 256 ; Max string length
extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global triangle

segment .data
; Strings and formats

; Format for single float
float_format: db "%lf", 0

; Format for two floats
two_float_format: db "%lf %lf", 0

; Space char
space: db " ", 0

; If input is invalid
invalid: db "A number below or equal to zero was detected, please input postive floats.", 10, 0

; String format for scanf, printf
format: db "%s", 0

prompt_name: db "Please enter your last name: ", 0

prompt_title: db "Please enter your title: ", 0

prompt_sides: db "Please enter the sides of your triangle separated by a space: ", 0

display_area: db "The area of this triangle is ", 0

square_units: db " square units.", 10, 0

display_hyp: db "The hypotenuse is ", 0

units: db " units.", 10, 0

exit_message: db "Please enjoy your triangles ", 0

segment .bss
; Reserve 256 bytes for name and title each

name: resb STRING_LEN

title: resb STRING_LEN

segment .text
; Entrance point of program
triangle:
    push rbp ; Save base pointer to stack
    mov rbp, rsp ; Move rsp into rbp

    push rdi ; Backup rdi
    push rsi ; Backup rsi
    push rdx ; Backup rdx
    push rcx ; Backup rcx
    push r8  ; Backup r8
    push r9 ; Backup r9
    push r10 ; Backup r10
    push r11 ; Backup r11
    push r12 ; Backup r12
    push r13 ; Backup r13
    push r14 ; Backup r14
    push r15 ; Backup r15
    push rbx ; Backup rbx
    pushf ; Backup rflags

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_name ; Load message into rdi
    call printf

    ; Name input using fgets
    mov rax, 0 ; Tell fgets we have 0 floating point args
    mov rdi, name ; Load format into rdi
    mov rsi, STRING_LEN ; String length
    mov rdx, [stdin] ; Pass in value of stdin
    call fgets

    ;  Remove trailing newline from fgets
    mov rax, 0
    mov rdi, name
    call strlen
    sub rax, 1 ; length stored in rax, go back 1 byte
    mov byte [name + rax], 0

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_title ; Load message into rdi
    call printf

    ; Title input using fgets
    mov rax, 0 ; Tell fgets we have 0 floating point args
    mov rdi, title ; Load format into rdi
    mov rsi, STRING_LEN ; String length
    mov rdx, [stdin] ; Pass in value of stdin
    call fgets

    ;  Remove trailing newline from fgets
    mov rax, 0
    mov rdi, title
    call strlen
    sub rax, 1 ; length stored in rax, go back 1 byte
    mov byte [title + rax], 0

    ; If inputs are negative, restart here
    restart: 
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_sides ; Load message into rdi
    call printf

    ; 16 bytes in total made on stack
    ; Create space for 2 float numbers, i.e. push two quadwords on the stack
    push qword -1
    push qword -2

    mov rax, 0 ; Since we created space earlier via pushes, we do not need to specify the amount of float arguments
    mov rdi, two_float_format ;"%lf %lf"
    mov rsi, rsp ; rsi points to first quadword on the stack
    mov rdx, rsp
    add rdx, 8 ; rdx points to second quadword on the stack
    call scanf

    movsd xmm15, [rsp] ; Move first input into xmm15
    movsd xmm14, [rsp+8] ; Move second input into xmm14, at address rsp + 8
    
    ; Reverse previous push statements
    pop rax
    pop rax
    
    ; Zero-out xmm11, all bits = 0
    xorpd xmm11, xmm11
    
    ; check xmm15 against xmm11, jump if xmm15 < xmm11
    ucomisd xmm15, xmm11
    jbe negative
    
    ; check xmm14 against xmm11, jump if xmm14 < xmm11
    ucomisd xmm14, xmm11
    jbe negative
    

    mov rax, 0x4000000000000000; Move 2.0 into rax
    push rax ; Push rax to the top of the stack
    movsd xmm13, [rsp] ; Move value at rsp (top of stack, 2.0) into xmm13
    pop rax ; Reverse push

    ; Make backups to use for hypotenuse
    movsd xmm12, xmm15 ; xmm12 = xmm15 val

    ; Begin computations for area
    mulsd xmm12, xmm14 ; xmm12 *= xmm14
    divsd xmm12, xmm13 ; xmm12 /= xmm13 (xmm13 = 2.0) -> xmm12 now holds area

    mov rax, 0
    mov rdi, display_area ; "The area of this triangle is "
    call printf

    mov rax, 1 ; Tell printf we have a float argument
    mov rdi, float_format ; "%lf"
    movsd xmm0, xmm12 ; xmm12 placed in xmm0 to print
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; inserts newline char
    mov rsi, square_units ; " square units."
    call printf

    mulsd xmm15, xmm15 ; xmm15 squared
    mulsd xmm14, xmm14 ; xmm14 squared

    addsd xmm14, xmm15 ; xmm14 += xmm15 (a^2 + b^2)

    sqrtsd xmm14, xmm14 ; sqrt(xmm14)

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, display_hyp ; "The hypotenuse is "
    call printf

    mov rax, 1 ; Tell scanf we have 1 floating point argument
    mov rdi, float_format ; "%lf"
    movsd xmm0, xmm14 ; xmm14 placed in xmm0 to print
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, units ; " units."
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, exit_message ; "Please enjoy your triangles "
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, title ; Title from user input
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, space ; Load spcace char into rdi
    call printf

    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, name ; Name from user input
    call printf

    ; Move final value into xmm0 to be returned
    movsd xmm0, xmm14
    
    jmp end ; jump to end block
    
    ; If user input is invalid, run this block
    negative:
    mov rax, 0
    mov rdi, format
    mov rsi, invalid
    call printf
    jmp restart
    
    end:
    popf ; Restore rflags
    pop rbx ; Restore rbx
    pop r15 ; Restore r15
    pop r14 ; Restore r14
    pop r13 ; Restore r13
    pop r12 ; Restore r12
    pop r11 ; Restore r11
    pop r10 ; Restore r10
    pop r9 ; Restore r9
    pop r8 ; Restore r8
    pop rcx ; Restore rcx
    pop rdx ; Restore rdx
    pop rsi ; Restore rsi
    pop rdi ; Restore rdi

    pop rbp ; Restore rbp
    ret
