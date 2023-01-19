; Student Name: Daniel Cazarez
; CPSC 240-05
; Email: danielcaz2200@csu.fullerton.edu
; Program Name: Computations

; Declare external functions & make 'computations' visible to C & declare constants
STRING_LEN equ 256 ; Max string length
extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global computations

segment .data
; Strings and formats

; Format for single float
float_format: db "%lf", 0

; String format for scanf, printf
format: db "%s", 0

; IO char arrays
welcome_msg: db "This program will help you compute power in watts, given resistance and voltage.", 10, 0
prompt_name: db "Please enter your name then press enter: ", 0
prompt_resistance: db "Please enter your resistance in ohms: ", 0
prompt_voltage: db "Please enter your voltage in volts: ", 0

; 8 digits of precision
print_power: db "Thank you, your power is %0.8lf watts.", 10, 0

segment .bss
; Reserve 256 bytes for name and title each
name: resb STRING_LEN

segment .text
; Entrance point of program
computations:
    ; 15 PUSHES
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

    ; print welcome message
    mov rax, 0
    mov rdi, format
    mov rsi, welcome_msg
    call printf

    name_section:
    ; prompt for name
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_name ; Load message into rdi
    call printf

    ; name input using fgets
    mov rax, 0 ; Tell fgets we have 0 floating point args
    mov rdi, name ; Load format into rdi
    mov rsi, STRING_LEN ; String length
    mov rdx, [stdin] ; Pass in value of stdin
    call fgets

    ; remove trailing newline from fgets
    mov rax, 0
    mov rdi, name
    call strlen
    sub rax, 1 ; length stored in rax, go back 1 byte
    mov byte [name + rax], 0

    input_section:
    ; prompt for current
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_resistance ; Load message into rdi
    call printf

    ; 16 bytes in total made on stack
    ; create space for quadword on stack + qword to stay on boundary
    push qword -1
    push qword -2

    ; Get user input
    mov rax, 0 ; Since we created space earlier via pushes, we do not need to specify the amount of float arguments
    mov rdi, float_format ; %lf"
    mov rsi, rsp ; rsi points to first quadword on the stack
    call scanf
    movsd xmm15, [rsp] ; Move first input into xmm15 (resistance)
    pop rax
    pop rax

    ; prompt for volts
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_voltage ; Load message into rdi
    call printf

    ; 16 bytes in total made on stack
    ; create space for quadword on stack + qword to stay on boundary
    push qword -1
    push qword -2

    ; Get user input
    mov rax, 0 ; Since we created space earlier via pushes, we do not need to specify the amount of float arguments
    mov rdi, float_format ; %lf"
    mov rsi, rsp ; rsi points to first quadword on the stack
    call scanf
    movsd xmm14, [rsp] ; Move first second input into xmm14 (voltage)
    pop rax
    pop rax

    math_section:
    ; xmm15 = resistance, xmm14 = volts
    ; backup xmm14 (volts) for later
    movsd xmm13, xmm14

    ; current = (volts / resistance), xmm14 now = current (I)
    divsd xmm14, xmm15

    ; xmm13 = P, where P (power) is volts * current, store result in xmm13
    mulsd xmm13, xmm14

    ; print out the formatted power in xmm13
    mov rax, 1
    mov rdi, print_power
    movsd xmm0, xmm13
    call printf

    ; send name to driver
    mov rax, name

    ; 15 POPS
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

    ; return
    ret
