%define LEN_BUFFER 512
%define MAX_TROZOS 64 

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

%macro DEBUGMESSAGE 0

    push debug_message_length
    push debug_message
    call printString

%endmacro

%macro printPrompt 0

    push prompt_length
    push prompt
    call printString

%endmacro

section .data


debug_message db "Im here", 0Ah
debug_message_length equ $ - debug_message

prompt db  "$>"                               ;prompt
prompt_length equ $ - prompt                       ;len prompt

new_line db 0Ah                                         ;caracter new line
terminado db 0                                          ;variable terminado, termina el bucle del buffer

comando db  LEN_BUFFER dup(0)                           ;buffer para guardar la entrada del comando
comando_trozos dq MAX_TROZOS dup(0)                     ;buffer para guardar los trozos del comando
comando_copy db LEN_BUFFER dup(0)

section .bss


section .text
global _start

; funcion que sirve para imprimir un string
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


printNullTerminated:

    push rbp
    mov rbp, rsp

    mov rsi, qword [rbp + 16]
    mov rcx, rsi ; copia de rsi
    mov rbx, 0 

    ._while:
    cmp byte [rsi], 0 
    je ._endwhile
    inc rsi
    inc rbx
    jmp ._while
    ._endwhile:

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    ;la direccion ya se encuentra en rsi
    mov rdx, rbx ; aqui esta la longitud
    syscall

    pop rbp
    ret 8


_start:

    ._while:
    cmp byte [terminado],  0
    jne ._endwhile

    printPrompt

    ;leemos entrada
    mov rax, 0
    mov rdi, 0
    mov rsi, comando
    mov rdx, LEN_BUFFER
    syscall


    ;copiamos de un buffer a otro
    mov esi, comando
    mov edi, comando_copy
    mov rcx, rax
    rep movsb



    ;acto seguido hacemos el parsing
    mov rbx, comando_copy                           ;init lexeme
    mov rcx, comando_copy                           ;current lexeme
    mov rsi, comando_trozos                         ;aqui vamos a ir guardando los trozos
    

    ._while1:
    cmp byte [rbx], 0
    je ._endwhile1


    ;lo expresamos como dos ifs
    
    cmp byte [rcx], ' '
    jne ._false
    
    ._true:    
    mov byte [rcx], 0
    mov qword [rsi], rbx
    add rsi, 8
    inc rcx
    
    ._while2:
    cmp byte [rcx], ' '
    jne ._endwhile2
    inc rcx
    jmp ._while2
    
    ._endwhile2:
    mov rbx, rcx
    jmp ._next
    ._false:
    ._next:


    cmp byte [rcx], 0
    jne ._false1

    ._true1:
    mov qword [rsi], rbx
    mov rbx, rcx
    jmp ._next1
    
    ._false1:
    ._next1:

    inc rcx
    jmp ._while1
    ._endwhile1:


    ;probamos null terminated
    mov rsi, qword [comando_trozos]
    push rsi
    call printNullTerminated


    push LEN_BUFFER
    push comando
    call printString

    printNewLine


    jmp ._while
    ._endwhile:
    

    endProgram