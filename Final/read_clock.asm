; Student Name: Daniel Cazarez
; CPSC 240-05
; Email: danielcaz2200@csu.fullerton.edu
; Program Name: SSE Benchmarking

; make get_time visible to other functions
global get_time

segment .text

get_time:
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
	
    ; clear rax, rdx
    mov rax, 0
    mov rdx, 0

    ; call cpuid
    ; read clock, storing a portion
    ; in the low half of rdx and rax
    cpuid
    rdtsc

    ; this moves all the necessary 
    ; bits to the high half of rdx
    shl rdx, 32
	
	; afterwards
	; rdx = | good bits | zeros |

    ; add the values, since 
    ; this is rax = rax + rdx
    ; we do not need to move anything
    ; into rax for return sake
    add rax, rdx

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

