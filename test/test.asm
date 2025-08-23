%macro printString 2

	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

section .data
cad db "hello",0
cad1 db "hello",0

message db "hola mundo"
message_length equ $ - message

section .text
global _start


printDigit:


    push rbp
    mov rbp, rsp

    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push r8
    push r9

    mov r9, rsp


    
    mov rdx, 0 
    mov rax, qword [rbp + 16]
    mov rcx, 0
    mov r8, 10

    ._while:
    div r8

  
    add rdx, '0'                     ;attention here, it may cause overflow
    dec rsp
    mov byte [rsp], dl
    inc rcx


    mov rdx, 0
    cmp rax, 0
    ja ._while
    ._endwhile:

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, rcx 
    syscall

    mov rsp, r9


    pop r9
    pop r8
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ._return:
    pop rbp
    ret 8


strcmp:
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]
    mov rdi, [rbp + 24]


    L1:
    mov al, byte [rsi]
    mov dl, byte [rdi]
    cmp al, 0
    jne L2
    cmp dl, 0
    jne L2
    jmp L3
    L2:
    inc rsi
    inc rdi
    cmp al, dl
    je L1
    L3:
    pop rbp
    ret 16


_start:
	


	push 1234578910
	call printDigit

	mov rax, 60
	xor rdi, rdi
	syscall