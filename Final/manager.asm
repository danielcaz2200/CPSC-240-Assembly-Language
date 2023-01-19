; Student Name: Daniel Cazarez
; CPSC 240-05
; Email: danielcaz2200@csu.fullerton.edu
; Program Name: SSE Benchmarking

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
float_format: db "%lf", 0

; ==============================================================================

; for testing purposes, to check the current frequency
cpu_frequency: db "The current CPU frequency is %.2lf GHz.", 10, 10, 0
; for testing purposes ONLY

; UI
welcome: db "Welcome to SSE benchmarking program.", 10, 0
prompt_rate: db "Please enter the rate (m/sec): ", 0
prompt_duration: db "Please enter time duration (seconds): ", 0
distance_traveled: db "The distance traveled was %.3lf meters.", 10, 0
newline_char: db "", 10, 0

; exit message
exit_msg: db "Daniel wishes you a nice winter break. Nanoseconds will be returned to the driver.", 10, 0

; ==============================================================================

; time output section
execution_time: db "The computation required %lu tics which equals %0.2lf nanoseconds based on processor GHz.", 10, 0

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
	
	; prompt m/sec rate
	push qword 0
	mov rax, 0 
	mov rdi, string_format
	mov rsi, prompt_rate
	call printf
	pop r10
	
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
	
	; prompt duration in seconds
	push qword 0
	mov rax, 0 
	mov rdi, string_format
	mov rsi, prompt_duration
	call printf
	pop r10
	
	push qword 0
	; call scanf, rax = 0
	; since SSE registers 
	; not needed in operation
	mov rax, 0
	mov rdi, float_format
	mov rsi, rsp
	call scanf
	
	; move value into xmm14,
	; reverse pushes
	movsd xmm14, [rsp]
	pop r10

	time_start:
	; get the starting time clock tics
	call get_time

	; store the value into r14
	mov r14, rax
	
	computations:
	; distance will be stored in xmm11
	; xmm11 = distance
	movsd xmm11, xmm15
	mulsd xmm11, xmm14
	; === end computations ===
	
	time_end:
	; get the ending time clock tics
	call get_time
	
	; store the value into r15
	; should contain larger val than r14
	mov r15, rax
	
	push qword 0
	; print distance traveled
	mov rax, 1
	mov rdi, distance_traveled
	movsd xmm0, xmm11 
	call printf
	pop r10
	
	; get CPU frequency, store in xmm13
	; (should be 2.1 on my system)
	; rax = 1 to signify using xmm0
	mov rax, 1
	call get_frequency
	movsd xmm13, xmm0
	
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
	divsd xmm15, xmm13
	
	; print newline to format next block
	push qword 0
	mov rax, 0
	mov rdi, string_format
	mov rsi, newline_char
	call printf 
	pop r10
	
	push qword 0
	; print tics elapsed along with nanosecs
	; rax = 1 to indicate use of xmm0
	mov rax, 1
	mov rdi, execution_time
	mov rsi, r15
	movsd xmm0, xmm15
	call printf
	pop r10
	
	push qword 0
	; print exit message
	mov rax, 0
	mov rdi, string_format
	mov rsi, exit_msg
	call printf
	pop r10
	
	do_15_pops:
	; return nanosecs
	; return xmm15 (nanosecs) to main
	movsd xmm0, xmm15
	
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



