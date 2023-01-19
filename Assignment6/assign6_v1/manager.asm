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
	
    ; mov return value into xmm15 <- precision num
	; if iteration num < precision num, exit loop
    movsd xmm15, xmm0

    setup_values:
	; loop variable
	mov rbx, 0
	
	; summation variable (0.0)
	xorpd xmm11, xmm11

	; will use C function pow in power
    calculations:
	cmp rbx, 500
	je sum_computed
	; get rbx into an xmm register
	cvtsi2sd xmm10, rbx
	
	; indicate return to xmm0
	; with rax = 1
	mov rax, 1
	movsd xmm0, xmm10
	call power
	
	; xmm14 contains (-1)^K
	movsd xmm14, xmm0
	
	; move rbx into xmm13 (K)
	cvtsi2sd xmm13, rbx
	
	; (K * 2.0), then add 1 (numbers + 16 bytes)
	mulsd xmm13, [numbers+8]
	addsd xmm13, [numbers+16]
	
	; divide numerator by denominator (-1)^K / (2.0K + 1.0)
	divsd xmm14, xmm13
	
	addsd xmm11, xmm14
	
	; multiply terms by 4
	mulsd xmm11, [numbers]
	
	; rbx += 1
	inc rbx
	jmp calculations
	
	
	sum_computed:
    ; store xmm11 in xmm15 (make a backup)
    movsd xmm15, xmm11

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
    movsd xmm0, xmm11

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



