%define LEN_BUFFER 512
%define MAX_TROZOS 64

section .data


node
	buffer	db LEN_BUFFER dup(0)			;buffer comando nodo
buffer_length equ $ - buffer
	trozos	dq MAX_TROZOS dup(0)			;trozos nodo
trozos_length equ $ - trozos 
	next 	dq 0							;este es mi next
next_length equ $ - next

node_length equ $ - node

section .bss

list resq 1

section .text

global createEmptyList
global isEmptyList

createEmtpyList:							;modifica la posicion de memoria denotada por list 
	mov qword [list], 0
	ret 

isEmptyList:								;modifica el resgistro rax
	cmp qword [list], 0
	jne ._false
	._true:
	mov rax, 1
	jmp ._next
	._false:
	mov rax, 0
	._next:
	ret 

