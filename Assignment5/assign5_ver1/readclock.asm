global gettime                     ; Makes function callable from other linked files.

segment .text

gettime:

; Back up all registers and set stack pointer to base pointer
push rbp
mov rbp, rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

push qword 0                        ; Extra push to create even number of pushes

;----------------------------------READ CLOCK-----------------------------------------------

mov rax, 0  
mov rdx, 0

cpuid                              ; Identifies the type of cpu being used on pc.
rdtsc                              ; Counts the number of cycles/tics occured since pc reset.

shl rdx, 32
add rax, rdx

;---------------------------------END OF FILE-----------------------------------------------

pop r8                             ; Remove extra push of -1 from stack.

; Restores all registers to their original state.
popf                                                 
pop rbx                                                     
pop r15                                                     
pop r14                                                      
pop r13                                                      
pop r12                                                      
pop r11                                                     
pop r10                                                     
pop r9                                                      
pop r8                                                      
pop rcx                                                     
pop rdx                                                     
pop rsi                                                     
pop rdi                                                     
pop rbp

ret
