; This program asks for name and prints it out

%include "lib/io.asm"

%define BUF_SIZE 32

section .bss
    buffer resb BUF_SIZE

section .data
    sName db "Enter your name: "
    lName equ $-sName

section .text:
    global _start

_start:
    mPrintStr sName, lName
    mov edx, BUF_SIZE
    mInputStr_buf buffer
    mov edx, eax
    mPrintStr_buf buffer
    mNewline
exit:
    mov eax, 1          ; system call for exit
    xor ebx, ebx        ; exit status of 0
    int 0x80            ; invoke the system call
