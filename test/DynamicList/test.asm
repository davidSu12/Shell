section .data


node:
		db 0 				;item
		dq 0 				;next


node_size equ  $ - node

;debug message
message db "Un error ha ocurrido"
message_length equ $ - message

new_line db 0Ah
new_line_length equ $ - new_line

section .bss
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


_start:

	mov rax, 9
	xor rdi, rdi
	mov rsi, node_size
	mov rdx, 3
	mov r10, 0x22
	mov r8, -1
	xor r9, r9
	syscall



	mov rbx, rax
	mov byte [rbx], 2
	mov qword [rbx + 1], 0


	mov rax, 9
	xor rdi, rdi
	mov rsi, node_size
	mov rdx, 3
	mov r10, 0x22
	mov r8, -1
	xor r9, r9
	syscall

	mov rcx, rax
	mov byte [rcx], 4
	mov qword [rcx + 1], rbx
	mov rbx, rcx


	._while:


	cmp rbx, 0
	je ._endwhile

	movzx rcx, byte [rbx]
	push rcx
	call printDigit

	mov rcx, qword [rbx + 1]
	mov rbx, rcx



	jmp ._while
	._endwhile:






	xor edi, edi
	mov rax, 60
	syscall

