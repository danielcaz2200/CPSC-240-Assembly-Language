; I/O operations
extern printf
extern scanf

; opted to use Lieberman's function 
extern get_frequency

; clock tics function
extern get_time

; make manager visible to C++ driver
global manager

segment .data
; formats for data types
string_format: db "%s", 0
int_format: db "%ld", 0
float_format: db "%lf", 0
newline: db "", 10, 0

; ==============================================================================

; user IO strings
prompt_height: db "Please enter the height in meters of the dropped marble: ", 0
marble_time: db "The marble will reach earth after %lf seconds.", 10, 10, 0

; for testing purposes, to check the current frequency
cpu_frequency: db "The current CPU frequency is %lfghz.", 10, 10, 0

; exit message
exit_msg: db "Daniel wishes you a nice day.", 10, 0

; if input is not good
bad_user_input: db "The number entered was less than or equal to 0. Please try again.", 10, 10, 0

; ==============================================================================

; time output section
current_time: db "The current clock time is %ld tics.", 10, 0
execution_time: db "The execution time was %ld tics which equals %0.2lf nanoseconds.", 10, 0
execution_time_seconds: db "In seconds, this is %lf seconds.", 10, 10, 0

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
	push qword 0
	
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
	
	; zero out a register for comparsion
	xorpd xmm11, xmm11
	
	user_input:
    ; prompt height from user
	mov rax, 0
	mov rdi, string_format
	mov rsi, prompt_height
	call printf

	; get input from user
	; create space on the stack for qword float
	push qword 0
	
	; call scanf, rax = 0
	; since SSE registers 
	; not needed in operation
	mov rax, 0
	mov rdi, float_format
	mov rsi, rsp
	call scanf
	
	; move value into xmm15,
	; reverse pushes
	movsd xmm15, [rsp]
	pop r10
	
	; compare to xmm11
	ucomisd xmm15, xmm11
	jbe bad_input
	
	loading_values:
	; get 2 into xmm14, i.e. convert an int to float
	mov rax, 2
	cvtsi2sd xmm14, rax
	
	; move 9.8 into xmm13
    ; movq essentially just moves
    ; a quadword source into another quadword dest
	mov rax, 0x402399999999999a
	movq xmm13, rax
	
	; xmm13 = xmm13 / xmm14 -> 9.8/2.0
	divsd xmm13, xmm14
	
	; so far:
	; xmm15 = user val, xmm13 = 9.8/2.0
	
	begin_calculations:
	; xmm15 = xmm15 / xmm13
	; then sqrt(xmm15)
	divsd xmm15, xmm13
	sqrtsd xmm15, xmm15
	
	push qword 0
	print_fall_time:
    ; print a newline char
    mov rax, 0
    mov rdi, string_format
    mov rsi, newline
    call printf

	; print out time needed
	; for marble to fall to earth
	mov rax, 1
	mov rdi, marble_time
	movsd xmm0, xmm15
	call printf
	pop r10
	
	time_end:
	; get the ending time clock tics
	call get_time
	
	; store the value into r15
	; should contain larger val than r14
	mov r15, rax
	
	push qword 0
	; print out current tics,
	; tics at end of program
	mov rax, 0
	mov rdi, current_time
	mov rsi, r15
	call printf
	pop r10
	
	; get CPU frequency, store in xmm12
	; (should be 2.1 on my system)
	mov rax, 1
	call get_frequency
	movsd xmm12, xmm0
	
	time_elapsed:
	; convert start time AND end time to floats
	cvtsi2sd xmm14, r14
	cvtsi2sd xmm15, r15
	
	; xmm15 = xmm15 - xmm14, time elapsed in xmm15 now
	subsd xmm15, xmm14
	
	; store for use in print statement
	; redundant, but will allow us to print two vals at once
	cvtsd2si r15, xmm15
	
	; divide xmm15 (time elapsed in tics)
	; by clock speed (xmm12) (2.1)
	; xmm15 should = time in nanoseconds
	divsd xmm15, xmm12
	
	push qword 0
	; print tics elapsed along with nanosecs
	; rax = 1 to indicate use of xmm0
	mov rax, 1
	mov rdi, execution_time
	mov rsi, r15
	movsd xmm0, xmm15
	call printf
	pop r10
	
	; backup nanoseconds
	movsd xmm10, xmm15
	
	; print this number in seconds
	; must divide nanoseconds by 1 billion
	mov rax, 0x41cdcd6500000000
	movq xmm11, rax
	
	; xmm10 = seconds
	divsd xmm10, xmm11
	
	push qword 0
	; print seconds elapsed
	; rax = 1 to indicate use of xmm0
	mov rax, 1
	mov rdi, execution_time_seconds
	movsd xmm0, xmm10
	call printf
	pop r10
	
	push qword 0
	; print exit message
	mov rax, 0
	mov rdi, string_format
	mov rsi, exit_msg
	call printf
	pop r10
	
	; return xmm15 (nanosecs) to main
	movsd xmm0, xmm15
	jmp do_15_pops
	
	bad_input:
	push qword 0
	mov rax, 0
	mov rdi, string_format
	mov rsi, bad_user_input
	call printf
	pop r10
	jmp user_input
	
	do_15_pops:
    ; 15 pops
	pop rax
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



