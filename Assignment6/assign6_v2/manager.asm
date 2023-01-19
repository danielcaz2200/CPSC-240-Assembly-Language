; I/O operations
extern printf
extern scanf

; to get power of -1
extern power
extern fabs

; to get user input
extern precision

; make manager visible to C++ driver
global manager

segment .data
; formats for data types
string_format: db "%s", 0
int_format: db "%ld", 0
float_format: db "%lf", 0
newline: db "", 10, 0

numbers: dq 4.0, 2.0, 1.0

; ==============================================================================

; user IO strings

iteration: db "This iteration is %lf", 10, 0
computed: db "The sum has been computed.", 10, 0
sum: db "The sum is %lf", 10, 0
debug: db "Here!", 10, 0

; ==============================================================================

segment .text
manager:
    ; 15 pushes
	push rbp
	mov rbp, rsp
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	pushf
	
	user_input:
    ; using 1 sse register
    ; xmm0, so pass 1 to rax
    mov rax, 1
    call precision
	
    ; mov return value into xmm14 <- precision num
	; if iteration num < precision num, exit loop
    movsd xmm14, xmm0

    setup_values:
	; loop variable
	mov rbx, 0
	
	; summation variable (0.0)
	xorpd xmm15, xmm15
	
	; === LOOP BEGINS HERE === 
	loop_start:
	; move rbx into xmm11
	cvtsi2sd xmm11, rbx
	
	; xmm13 = 1.0
	movsd xmm13, [numbers+16] 
	
	; xmm12 = 2.0
	movsd xmm12, [numbers+8]
	
	; 2.0 * K
	mulsd xmm11, xmm12

	; 2.0*K + 1
	addsd xmm11, [numbers+16]
	
	; 1/denom
	divsd xmm13, xmm11
	
	; multiply whole by 4.0
	mulsd xmm13, [numbers]

	; add onto accumulator
	addsd xmm15, xmm13
	
	inc rbx
	cmp rbx, 100
	je sum_computed
	jmp loop_start
	; === LOOP ENDS HERE === 
	
	
	sum_computed:
    ; print message indicating
    ; sum has been computed
    mov rax, 0
    mov rdi, string_format
    mov rsi, computed
    call printf

    ; print sum in formatted
    ; string
    mov rax, 1
    mov rdi, sum
    movsd xmm0, xmm15
    call printf

    ; 15 pops + move return value
    movsd xmm0, xmm15

	popf
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rbp

	ret



