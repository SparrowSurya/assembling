; assembly program which takes a number input and prints it

extern print_hex

section .data
    endl db 0xa

    prompt_num db "Number: "
    prompt_num_len equ $-prompt_num

    number db 69


; write the message to stdout
%macro print_str 2
    ; param-1: string address
    ; param=2: string length

    mov edx, %2         ; length of message
    mov ecx, %1         ; pointer to message to write
    mov ebx, 1          ; file descriptor for stdout
    mov eax, 4          ; system call for write
    int 0x80            ; invoke the system call
%endmacro


; store to buffer from stdin
%macro input_str 2
    ; param-1: buffer address
    ; param=2: buffer length

    mov edx, %2         ; length of message
    mov ecx, %1         ; pointer to message to write
    mov ebx, 1          ; file descriptor for stdout
    mov eax, 4          ; system call for write
    int 0x80            ; invoke the system call
%endmacro


; write number to stdout
%macro print_num 1
    ; param-1: number

    mov eax, [%1]       ; storing value at address into eax
    call print_hex
%endmacro


; to print newline character
%macro print_newline 0
    call print_str endl, 1
%endmacro


section .text:
    global _start

_start:
    print_str prompt_num, prompt_num_len
    print_num number
    print_newline

    ; exit with success status
    mov eax, 1          ; system call for exit
    xor ebx, ebx        ; exit status of 0
    int 0x80            ; invoke the system call
