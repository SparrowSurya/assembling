; This program asks for name and prints it out

%include "lib/io.asm"

%define BUF_SIZE 32

section .bss
    buffer resb BUF_SIZE

section .data
    sCaret db "> "
    lCaret equ $-sCaret

section .text:
    global _start

_start:
    CallPrintStr sCaret, lCaret          ; print prompt
    CallInputStr buffer, BUF_SIZE        ; input string
    mov edx, eax                         ; capture length of input
    lea ecx, [buffer]                    ; load buf address
    call PrintStr                        ; print buffer
    Newline                              ; print newline
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
