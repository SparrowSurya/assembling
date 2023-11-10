; ********************************************************************************
; Program: Prints sum of two numbers taken from user
; ********************************************************************************


; custom libraries
%include "lib/io.asm"
%include "lib/cast.asm"

%define BUFFER_SIZE 16


section .bss

    ; used for io opertions
    buffer resb BUFFER_SIZE


section .data

    AskNum1 db "Num1: ", 0
    len_AskNum1 equ $-AskNum1

    AskNum2 db "Num2: ", 0
    len_AskNum2 equ $-AskNum2

    ShowNum db "Sum: ", 0
    len_ShowNum equ $-ShowNum

    chars_num1 dd 0
    chars_num2 dd 0
    chars_sum  dd 0

    num1 dd 0
    num2 dd 0
    sum  dd 0


section .text
    global _start


_start:

    CallPrintStr AskNum1, len_AskNum1          ; prompt for num1
    CallInputStr buffer, BUFFER_SIZE           ; read input
    mov [chars_num1], eax                      ; store input size
    CallStr2Uint buffer, [chars_num1]          ; convert from str to uint
    mov [num1], eax                            ; store the uint value to num1

    CallPrintStr AskNum2, len_AskNum2          ; prompt for num2
    CallInputStr buffer, BUFFER_SIZE           ; read input
    mov [chars_num2], eax                      ; store input size
    CallStr2Uint buffer, [chars_num2]          ; convert from str to uint
    mov [num2], eax                            ; store the uint value to num2

    mov eax, [num1]                            ; load num1
    add eax, [num2]                            ; add num2
    mov [sum], eax                             ; store result in sum
    CallUint2Str buffer, [sum]                 ; convert from uint to string
    mov [chars_sum ], ecx                      ; storing the size of string

    CallPrintStr ShowNum, len_ShowNum          ; prompt for sum
    mov eax, BUFFER_SIZE                       ; size of buffer
    sub eax, [chars_sum]                       ; offset to start of number
    lea ecx, [buffer+eax]                      ; get address of offset
    mov edx, chars_sum                         ; size of sum
    call PrintStr                              ; print buffer (sum)
    Newline                                    ; newline

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
