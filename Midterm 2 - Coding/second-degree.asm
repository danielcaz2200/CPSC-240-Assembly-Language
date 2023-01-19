; Student Name: Daniel Cazarez
; CPSC 240-05
; Email: danielcaz2200@csu.fullerton.edu
; Program Name: Second Degree

; Declare external functions & make visible to C++ & declare constants
STRING_LEN equ 64 ; Max string length
; basic io
extern printf
extern scanf

; convert string to float
extern atof

; validates input
extern isfloat

; root functions
extern noroots
extern oneroot
extern tworoots

global second_degree

segment .data
; Strings and formats

; Format for single float
float_format: db "%lf", 0

; String format for scanf, printf
format: db "%s", 0

; I/O strings
invalid: db "That input was invalid. Restart the program.", 10, 0
caller: db "The square root of the discriminant will be returned to the caller.", 10, 0
zero_pt_zero: db "0.0 will be returned to the caller.", 10, 0

tworoot_print: db "The discriminant is %lf, so therefore the number of roots is 2.", 10, 10, 0
oneroot_print: db "The discriminant is %lf, so therefore the number of roots is 1.", 10, 10, 0
noroot_print: db "The discriminant is %lf, so therefore the number of roots is 0", 10, 10, 0

the_discriminant_is: db "The discriminant is %lf.", 10, 10, 0

prompt_quad: db "Please enter your quadratic coefficient: ", 0
prompt_lin: db "Please enter your linear coefficient: ", 0
prompt_const: db "Please enter your constant coefficient: ", 0

quad_string: db "The quadratic is %.4lfx^2 + %.4lfx^1 + %.4lf", 10, 10, 0

; final message
final_message: db "The square root of the discriminant will be returned to the caller", 10, 0

segment .bss
; Reserve 64 bytes for each string
co_quad: resb STRING_LEN
co_lin: resb STRING_LEN
co_const: resb STRING_LEN

segment .text
; Entrance point of program
second_degree:
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
	
	; ax^2 + bx +c
	begin_input:
	; print quad message
	mov rax, 0
	mov rdi, format
	mov rsi, prompt_quad
	call printf
	
	; get quad coefficient, A
	mov rax, 0
	mov rdi, format
	mov rsi, co_quad
	call scanf
	
	; make call to C function isfloat
	mov rax, 0
	mov rdi, co_quad
	call isfloat ; return value stored in rax
	
	; compare return value to 0
	mov r15, rax
	cmp r15, 0
	je invalid_input
	
	; mov rax, 1 to indicate we will use xmm0
	; then, call atof to convert the string to float
	mov rax, 1
	mov rdi, co_quad
	call atof
	movsd xmm15, xmm0 ; return value stored in xmm0
	
	; print linear message
	mov rax, 0
	mov rdi, format
	mov rsi, prompt_lin
	call printf
	
	; get linear coefficient, B
	mov rax, 0
	mov rdi, format
	mov rsi, co_lin
	call scanf
	
	; mov rax, 1 to indicate we will use xmm0
	; then, call atof to convert the string to float
	mov rax, 1
	mov rdi, co_lin
	call atof
	movsd xmm14, xmm0 ; return value stored in xmm0
	
	; print const message
	mov rax, 0
	mov rdi, format
	mov rsi, prompt_const
	call printf
	
	; get const coefficient, C
	mov rax, 0
	mov rdi, format
	mov rsi, co_const
	call scanf
	
	; mov rax, 1 to indicate we will use xmm0
	; then, call atof to convert the string to float
	mov rax, 1
	mov rdi, co_const
	call atof
	movsd xmm13, xmm0 ; return value stored in xmm0

	; xmm15 = A xmm14 = B and xmm13 = constant
	
	; print quadratic
	mov rax, 3
	mov rdi, quad_string
	movsd xmm0, xmm15
	movsd xmm1, xmm14
	movsd xmm2, xmm13
	call printf
	
	compute_discriminant:
	; store xmm14 for later use (B)
	movsd xmm12, xmm14
	
	; get 4.0 into a register
	mov r15, 4
	cvtsi2sd xmm11, r15
	
	; 4.0*a = xmm11
	mulsd xmm11, xmm15
	
	; 4.0*a*c = xmm11
	mulsd xmm11, xmm13
	
	; xmm12 = xmm12*xmm12 -> copy of xmm14, b^2
	mulsd xmm12, xmm12
	
	; b^2 - 4*a*c
	; subtract xmm12 - xmm11, discriminant = xmm12
	subsd xmm12, xmm11
	
	; print the discriminant
	mov rax, 1
	mov rdi, the_discriminant_is
	movsd xmm0, xmm12
	call printf
	
	; zero out for comparison
	xorpd xmm10, xmm10
	
	; compare xmm12 (discriminant) to zero
	ucomisd xmm12, xmm10 ; xmm10 = 0.0 
	ja pos_discriminant
	
	; compare xmm12 (discriminant) to zero
	ucomisd xmm12, xmm10
	jb neg_discriminant
	
	; compare xmm12 (discriminant) to zero
	ucomisd xmm12, xmm10
	je zero_discriminant
	
	; discriminant functions
	pos_discriminant:
	; backup xmm12
	movsd xmm11, xmm12
	
	; if there is two roots, print a message saying so
	mov rax, 1
	mov rdi, tworoot_print
	movsd xmm0, xmm11
	call printf
	
	; pass parameters to tworoots for computation
	mov rax, 3
	movsd xmm0, xmm15
	movsd xmm1, xmm14
	movsd xmm2, xmm12
	call tworoots
	
	; move return value into xmm15
	movsd xmm15, xmm0
	jmp end
	
	zero_discriminant:
	; backup xmm12
	movsd xmm11, xmm12
	
	; if there is one root, print a message saying so
	mov rax, 1
	mov rdi, oneroot_print
	movsd xmm0, xmm11
	call printf
	
	; ; pass parameters to oneroot for computation
	mov rax, 3
	movsd xmm0, xmm15
	movsd xmm1, xmm14
	movsd xmm2, xmm12
	call oneroot
	
	; move return value into xmm15
	movsd xmm15, xmm0
	jmp end
	
	neg_discriminant:
	; backup xmm12
	movsd xmm11, xmm12
	
	; print if there is no roots
	mov rax, 0
	mov rdi, noroot_print
	movsd xmm0, xmm11
	call printf
	
	; call no roots function
	mov rax, 0
	call noroots
	
	; load return value, jump to end
	mov rax, 0
	cvtsi2sd xmm15, rax
	movsd xmm0, xmm15
	jmp end
	
	invalid_input: 
	; print width message
	mov rax, 0
	mov rdi, format
	mov rsi, invalid
	call printf
	
	mov rax, 0
	mov rdi, format
	mov rsi, zero_pt_zero
	call printf
	
	; return 0 to caller
	mov rax, 0
	cvtsi2sd xmm15, rax
	movsd xmm0, xmm15
	jmp end
	
	end:
	mov rax, 0
	mov rdi, format
	mov rsi, caller
	call printf
	
	; return value to caller
	movsd xmm0, xmm15
	
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
