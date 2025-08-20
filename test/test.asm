section .text
global _start
_start:
	mov ax, 10
	mov bx, 10
	div bx

	cmp al, 0
	jne _false
	_true:

	jmp _next
	_false:

	mov rax, 60
	mov rdi, -1
	syscall

	_next:

	mov rax, 60
	xor rdi, rdi 
	syscall