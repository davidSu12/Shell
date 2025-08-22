%define LEN_BUFFER 512
%define MAX_TROZOS 64 
%define TAMAÑO_ENTRADA_COMANDO 9
%define NEW_LINE 0Ah


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

overflow_message db "An overflow has ocurred", 0Ah
overflow_message_length equ  $ - overflow_message

debug_message db        "Im here", 0Ah
debug_message_length equ $ - debug_message

prompt db               "$>"                               ;prompt
prompt_length equ $ - prompt                       ;len prompt

new_line db             0Ah                                         ;caracter new line
terminado db            0                                          ;variable terminado, termina el bucle del buffer

comando db              LEN_BUFFER dup(0)                           ;buffer para guardar la entrada del comando
comando_trozos dq       MAX_TROZOS dup(0)                     ;buffer para guardar los trozos del comando
comando_copy db         LEN_BUFFER dup(0)

string1 db              "authors",0
string2 db              "pid", 0
string3 db              "ppid",0
string4 db              "cd",0
string5 db              "date",0
string6 db              "historic",0
string7 db              "open", 0
string8 db              "close", 0
string9 db              "dup",0
string10 db             "infosys",0
string11 db             "help",0
string12 db             "quit",0
string13 db             "exit", 0
string14 db             "bye", 0

;---------------------------------
%define OFFSET_ENTRADA_COMANDO 9

comandos:

    db 0
    dq string1

    db 1
    dq string2 

    db 2
    dq string3

    db 3
    dq string4

    db 4 
    dq string5

    db 5
    dq string6 

    db 6
    dq string7

    db 7 
    dq string8

    db 8
    dq string9

    db 9
    dq string10

    db 10
    dq string11

    db 11
    dq string12

    db 12
    dq string13

    db 13
    dq string14

    db -1
    dq 0
    

section .bss


section .text
global _start


;esta funcion imprime todos los comandos disponibles
imprimirComandos:

    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]

    ._while:
    cmp byte [rsi], -1
    je ._return

    push qword [rsi]

    jmp ._while
    ._endwhile:


    ._return:
    pop rbp
    ret 8

;funcion que sirve para imprimir un digito en formato string
;todo:fix the risk of overflow in this function
printDigit:


    push rbp
    mov rbp, rsp

    mov ax, word [rbp + 16]
    mov rcx, 0
    mov dl, 10

    ._while:
    cmp ax, 0
    je ._endwhile

    div dl

    movzx bx, al                    ;this is my quotient
    add ah, '0'                     ;attention here, it may cause overflow
    dec rsp
    mov byte [rsp], ah
    inc rcx
    mov ax, bx

    jmp ._while
    ._endwhile:

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, rcx 
    syscall


    ._return:
    mov rsp, rbp
    pop rbp
    ret

strcmp:
    push rbp
    mov rbp, rsp
		
		push rax
		push rdx
		push rdi
		push rsi 

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

		pop rsi
		pop rdi 
		pop rdx
		pop rax

    pop rbp
    ret 16



buscarCodigoComando: ;function not finished
    
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]
    

procesarEntrada:     ;function not finished

    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]                     ;offset de comando
    mov rdi, [rbp + 24]                     ;trozos comando




printString:        

    push rbp
    mov rbp, rsp

		push rax
		push rdi
		push rsi
		push rdx

    mov rax, 1
    mov rdi, 1
    mov rsi, qword [rbp + 16]                   ;offset string
    mov rdx, qword [rbp + 24]                   ;len string
    syscall

		pop rdx
		pop rsi
		pop rdi
		pop rax

    pop rbp
    ret 16



strlen:
    push rbp
    mov rbp, rsp
 
		push rsi
		push rdx

    mov rsi, qword [rbp + 16]
    mov rdx, 0
    
    ._while:
    cmp byte [rsi], 0
    je ._endwhile
    inc rsi
    inc rdx 
    jmp ._while
    
    ._endwhile:
    mov rax, rdx
		
		pop rdx
		pop rsi

    pop rbp
    ret 8

printNullTerminated:

    push rbp
    mov rbp, rsp

		push rsi
		push rcx
		push rbx
		
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

		push rbx
		push rcx
		call printString

		pop rbx
		pop rcx
		pop rsi 

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
    cld
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



    cmp byte [rcx], NEW_LINE
    jne ._false2
    ._true2:
    mov byte [rcx], 0
    mov qword [rsi], rbx
    add rsi, 8
    mov rbx, rcx
    jmp ._next2
    ._false2:
    ._next2:


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


    
    mov rsi, qword [comando_trozos]
    push rsi
    call strlen
    push rax
    call printDigit




    jmp ._while
    ._endwhile:
    

    endProgram