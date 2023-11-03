section .data
    msg db 'Hello, world!', 0xa ; message to print, includes newline character
    len equ $-msg               ; length of the message

section .text
    global _start

_start:
    ; write the message to stdout
    mov eax, 4          ; system call for write
    mov ebx, 1          ; file descriptor for stdout
    mov ecx, msg        ; pointer to message to write
    mov edx, len        ; length of message
    int 0x80            ; invoke the system call

    ; exit with success status
    mov eax, 1          ; system call for exit
    xor ebx, ebx        ; exit status of 0
    int 0x80            ; invoke the system call
