test: test.o
	ld test.o -o test

test.o: test.asm
	nasm -f elf64 test.asm -o test.o

clear:
	rm -f test test.o