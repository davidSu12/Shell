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

	push cad
	push cad1
	call strcmp

	je _message
	jmp _next
	_message:
	printString message, message_length
	_next:
	mov rax, 60
	xor rdi, rdi 
	syscall