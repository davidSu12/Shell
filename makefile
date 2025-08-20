main: main.o
	ld main.o -o main

main.o:
	nasm -f elf64 main.asm -o main.o
clear:
	rm -f main main.o