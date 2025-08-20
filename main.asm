%define LEN_BUFFER 512

%macro endProgram 0
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro

%macro printNewLine 0
    
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line
    mov rdx, 1
    syscall
%endmacro

section .data


prompt db  "$>", 0
prompt_length equ $ - prompt
terminado db 0
new_line db 0Ah
buffer db  LEN_BUFFER dup(0)

section .bss


section .text
global _start


printString:
    push rbp
    mov rbp, rsp

    mov rax, 1
    mov rdi, 1
    mov rsi, qword [rbp + 16]                   ;offset string
    mov rdx, qword [rbp + 24]                   ;len string
    syscall

    pop rbp
    ret 16


_start:
    
    _while:
    cmp byte [terminado],  0
    jne _endwhile

    push prompt_length
    push prompt
    call printString

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, LEN_BUFFER
    syscall

    push LEN_BUFFER
    push buffer
    call printString

    printNewLine


    jmp _while
    _endwhile:
    

    endProgram