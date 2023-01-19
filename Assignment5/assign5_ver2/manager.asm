extern printf
extern scanf

; opted to user Lieberman's function 
; instead of professor's example "cpuidentification"
extern clockspeed

global manager

segment .data

; formats for data types
string_format: db "%s", 0
int_format: db "%ld", 0
float_format: db "%lf", 0

; user IO section initializations
prompt_height: db "Please enter the height of the meters of the dropped marble: ", 0
marble_time: db "The marble will reach earth after %lf seconds.", 10, 0
exit_msg: db "Daniel wishes you a nice day.", 10, 0

; time output section
current_time: db "The current clock time is %ld tics", 10, 0
execution_time: db "The execution time was %ld tics which equals %0.2lf nanoseconds.", 10, 0

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

	time_start:
	; call cpu id with no parameters
	; then read the clock
	cpuid
	rdtsc 
	
	; shift return value bits left 32 bits so that 
	; rdx's high end holds part of the answer, then
	; add both split answers
	shl rdx, 32
	add rax, rdx
	
	; store the value into r15
	mov r14, rdx
	
	; print out current tics
	; tics at start of program
	mov rax, 0
	mov rdi, current_time
	mov rsi, r14
	call printf
	
	; prompt height from user
	mov rax, 0
	mov rdi, string_format
	mov rsi, prompt_height
	call printf
	
	; get input from user
	push qword 0
	push qword 0
	mov rax, 0
	mov rdi, float_format
	mov rsi, rsp
	call scanf
	
	; registers xmm11-xmm15 will be used
	
	; move value into xmm15
	; reverse push
	movsd xmm15, [rsp]
	pop rax
	pop rax
	
	fall_calculation:
	; first get 2 into xmm14
	mov rax, 2
	cvtsi2sd xmm14, rax
	mov rax, 0
	
	
	; move 9.8 into xmm13
	mov rax, 0x402399999999999a
	push rax
	movsd xmm13, [rsp]
	pop rax
	
	; xmm15 = user val, xmm14 = 2, xmm13 = 9.8
	
	; xmm13 = xmm13 / xmm14
	divsd xmm13, xmm14
	
	; xmm15 = xmm15 / xmm13
	divsd xmm15, xmm13
	
	; sqrt(xmm15)
	sqrtsd xmm15, xmm15
	
	; print out time for marble to fall 
	; to earth
	mov rax, 1
	mov rdi, marble_time
	movsd xmm0, xmm15
	call printf
	
	end_time:
	; call cpu id with no parameters
	; then read the clock
	cpuid
	rdtsc 
	
	; shift return value bits left 32 bits so that 
	; rdx's high end holds part of the answer, then
	; add both split answers
	shl rdx, 32
	add rdx, rax
	
	; store the value into r15
	mov r15, rdx
	
	; print out current tics
	; tics at end of program
	mov rax, 0
	mov rdi, current_time
	mov rsi, r15
	call printf
	
	; get current clockspeed
	mov rax, 1
	call clockspeed
	movsd xmm12, xmm0
	
	time_elapsed:
	; convert start time
	cvtsi2sd xmm14, r14
	
	; convert end time
	cvtsi2sd xmm15, r15
	
	; xmm15 = xmm15 - xmm14, time elapsed in xmm15 now
	subsd xmm15, xmm14
	
	; store for use in print statement
	cvtsd2si r15, xmm15
	
	; --- multiply CPU freq by 1 billion to divide elapsed time by ---
	
	; load 1 billion to use
    mov rax, 0x41cdcd6500000000
    push rax
    movsd xmm11, [rsp]
    pop rax
	
	; multiply CPU speed (a small float) by 1 billion
	; now CPU speed in hertz
	mulsd xmm12, xmm11
	
	; divide xmm15 (time elapsed in tics)
	; by clock speed (xmm12)
	; xmm15 = seconds elapsed
	divsd xmm15, xmm12
	
	; get number in nanoseconds
	; multiply by 1 billion
	; xmm15 = secs
	; nanosecs = secs * 1 billion
	mulsd xmm15, xmm11
	
	; print time elapsed
	mov rax, 1
	mov rdi, execution_time
	mov rsi, r15
	movsd xmm0, xmm15
	call printf
	
	; print tics elapsed along with nanosecs
	mov rax, 0
	mov rdi, string_format
	mov rsi, exit_msg
	call printf
	
	; return xmm15 (nanosecs) to main
	movsd xmm0, xmm15
	
    ; 15 pops
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



