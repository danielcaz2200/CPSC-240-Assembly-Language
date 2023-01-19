extern gettime
extern clockspeed
extern printf

global manager

segment .data

string_format: db "%s", 0
int_format: db "%ld", 0
current_time: db "The current clock time is %ld tics", 10, 0
execution_time: db "The execution time was %ld tics which equals %lf seconds.", 10, 0

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

    ; call gettime, save the value in r15
    mov rax, 0
    call gettime
    mov r15, rax

    ; print out current time, in tics
    mov rax, 0
    mov rdi, current_time
    mov rsi, r15
    call printf

    ; call gettime, save the value in r15
    mov rax, 0
    call gettime
    mov r14, rax

    ; print out current time, in tics
    mov rax, 0
    mov rdi, current_time
    mov rsi, r14
    call printf

    ; convert start, end time to
    ; float for use in math
    cvtsi2sd xmm15, r15
    cvtsi2sd xmm14, r14

    ; subtract xmm14 - xmm15
    subsd xmm14, xmm15

    ; convert xmm14 to a long int
    ; to print
    cvtsd2si r15, xmm14

    ; get cpu frequency
    mov rax, 1
    call clockspeed
    movsd xmm13, xmm0

    ; load 1 billion to be used
    mov rax, 0x41cdcd6500000000
    push rax
    movsd xmm12, [rsp]
    pop rax

    ; multiply cpu frequency by 1 billion
    ; this gives cpu speed
    mulsd xmm13, xmm12
    
    ; divide total elapsed tics by
    ; cpu speed 
    divsd xmm14, xmm13

    ; print out total execution time
    mov rax, 1
    mov rdi, execution_time
    mov rsi, r15
    movsd xmm0, xmm14
    call printf

    movsd xmm0, xmm14

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
	ret  ; return xmm0



