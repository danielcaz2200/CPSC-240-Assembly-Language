; Student Name: Daniel Cazarez
; CPSC 240-05
; Email: danielcaz2200@csu.fullerton.edu
; Program Name: Computations

; Declare external functions & make 'computations' visible to C & declare constants
STRING_LEN equ 256 ; Max string length
; basic io
extern printf
extern scanf

; input string
extern fgets
extern stdin
extern strlen

; convert string to float
extern atof

; validates input
extern validate

global computations

segment .data
; Strings and formats

; define negative 1
negative_one: dq -1.0

; Format for single float
float_format: db "%lf", 0

; String format for scanf, printf
format: db "%s", 0

; IO char arrays
power_msg: db "We will find your power.", 10, 0
prompt_name: db "Please enter your name then press enter: ", 0

prompt_resistance: db "Please enter your resistance in ohms: ", 0
prompt_current: db "Please enter your current in amps: ", 0

; 8 digits of precision
print_power: db "Thank you, %s your power consumption is %0.8lf watts.", 10, 0

invalid: db "Sorry, that input was invalid. Please restart the program.", 10, 0

segment .bss
; Reserve 256 bytes for name and title each
name: resb STRING_LEN
float_1: resb STRING_LEN
float_2: resb STRING_LEN
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

    ; push qwords for stack alignment purposes + clearing rsp
	push qword 0
	push qword 0

	; print power message
	mov rax, 0
	mov rdi, format
	mov rsi, power_msg
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
    ; prompt for resistance
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_resistance ; Load message into rdi
    call printf
	
	; get current from user, store the value at the
	; top of the stack at rsp
	mov rax, 0
	mov rdi, format
	mov rsi, rsp
	call scanf
	

    ; make call to C function validate
	mov rdi, rsp
	call validate
	
    
    ; compare return value to 0
	cmp rax, 0
	je invalid_input
	
	; mov rax, 1 to indicate we will use xmm0
	; then, call atof to convert the string to float
	mov rax, 1
	mov rdi, rsp
	call atof
	movsd xmm15, xmm0

    ; prompt for current
    mov rax, 0 ; Tell printf we have 0 floating point args
    mov rdi, format ; Load format into rdi
    mov rsi, prompt_current ; Load message into rdi
    call printf
	
	; get current from user, store the value at the
	; top of the stack at rsp
	mov rax, 0
	mov rdi, format
	mov rsi, rsp
	call scanf

    ; make call to C function validate
	mov rdi, rsp
	call validate
	
	; compare return value to 0
	cmp rax, 0
	je invalid_input
	
	; mov rax, 1 to indicate we will use xmm0
	; then, call atof to convert the string to float
	mov rax, 1
	mov rdi, rsp
	call atof
	movsd xmm14, xmm0

    math_section:
    ; xmm15 = resistance, xmm14 = current
    
	; square xmm14, store in xmm14
	mulsd xmm14, xmm14

    ; multiply xmm15, xmm14 -> store in xmm15
	mulsd xmm15, xmm14
	
	; backup xmm15 to xmm14
	movsd xmm14, xmm15

    ; print out the formatted power in xmm15
    mov rax, 1
    mov rdi, print_power
	mov rsi, name
    movsd xmm0, xmm15
    call printf
	
	; send power to driver 
    movsd xmm0, xmm14
	jmp end
	
	; handle invalid input, return 0 to driver.
	invalid_input:
	mov rax, 0
	mov rdi, format
	mov rsi, invalid
	call printf
	
    ; make xmm15 -1, return it to C driver
	movsd xmm15, qword [negative_one]
	movsd xmm0, xmm15
	jmp end

	end:
    ; reverse pushes, clear rsp
	pop rax
	pop rax

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
