; I/O operations
extern printf
extern scanf

; check if iteration is even or odd


; time functions
extern get_time
extern clock_speed

; to get user input
extern precision

; make manager visible to C++ driver
global manager

segment .data
; formats for data types
string_format: db "%s", 0
int_format: db "%ld", 0
float_format: db "%lf", 0
small_float: db "%f", 0

numbers: dq 4.0, 2.0, 1.0

; ==============================================================================

; user IO strings
computed: db "The sum has been computed.", 10, 0
sum: db "The sum is %lf", 10, 0

; ==============================================================================

; time/frequency
current_time: db "The current clock time is %lu tics.", 10, 0
your_cpu: db "Your machine is running a CPU rated at %.2lf GHz", 10, 0
execution_tics: db "The execution time was %lu tics", 10, 0
fetching_speed: db "Fetching your clock speed.", 10, 0
blank_line: db "", 10, 0

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
	
	; use xmm15 for comparison
	xorpd xmm15, xmm15
	
	print_speed:
	; get clockspeed, then print the speed of CPU clock
	; needed block here to print the speed
	mov rax, 0
	mov rdi, string_format
	mov rsi, blank_line
	call printf

	; indicate usage of xmm0
	mov rax, 1
	call clock_speed
	
	; use clock speed return val in xmm0 in 
	; print statement
	mov rax, 1
	mov rdi, your_cpu
	call printf
	
	user_input:
    ; using 1 sse register
    ; xmm0, so pass 1 to rax
    mov rax, 1
    call precision
	
    ; mov return value into xmm14 <- precision num
	; if iteration num < precision num, exit loop
    movsd xmm14, xmm0
	
	; if xmm14 <= 0.0, retry input
	ucomisd xmm14, xmm15
	jbe user_input
	
    setup_values:
	; loop variable
	mov rbx, 0
	
	; summation variable (0.0)
	xorpd xmm15, xmm15
	
	time_start:
	; get the starting time clock tics
	call get_time

	; store the value into r14
	mov r14, rax
	
	; print out current tics,
	; tics at start of program
	mov rax, 0
	mov rdi, current_time
	mov rsi, r14
	call printf
	
	; for iterations/even/odd
	mov r11, 0
	
	; === LOOP BEGINS HERE === 
	loop_start:
	xorpd xmm13, xmm13
	
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
	
	; compare r11 to 0 
	; to see if even or odd iter
	cmp r11, 0
	je even_iteration
	
	odd_iteration:
	; multiply by -1, then addsd
	subsd xmm15, xmm13
	
	; compare current iteration to
	; the precision number
	ucomisd xmm13, xmm14
	
	; if below xmm14, jump
	jb sum_computed
	
	; otherwise, inc rbx and
	; start loop again
	inc rbx
	not r11
	jmp loop_start
	
	even_iteration:
	; increment the summation variable
	addsd xmm15, xmm13
	
	; compare current iteration to
	; the precision number
	ucomisd xmm13, xmm14
	
	; if below xmm14, jump
	jb sum_computed
	
	; otherwise, inc rbx and
	; start loop again
	inc rbx
	not r11
	jmp loop_start
	; === LOOP ENDS HERE === 
	
	sum_computed:
	; get the ending time clock tics
	; print message indicating
    ; sum has been computed
    mov rax, 0
    mov rdi, string_format
    mov rsi, computed
    call printf
	
	end_time:
	call get_time
	
	; store the value into r15
	; should contain larger val than r14
	mov r15, rax
	
	; print out current tics,
	; tics at end of program
	mov rax, 0
	mov rdi, current_time
	mov rsi, r15
	call printf
	
	; subtract end from start
	sub r15, r14
	
	; print total tics elapsed (difference)
	mov rax, 0
	mov rdi, execution_tics
	mov rsi, r15
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