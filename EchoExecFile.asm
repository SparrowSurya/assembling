; ********************************************************************************
; This asm program reads the filename of executable
; ********************************************************************************

%include "lib/io.asm"


section .data
    argc dd 0


section .text
    global _start


_start:
    lea eax, [argc]                      ; load argc address into eax
    pop dword [eax]                      ; save no of args to argc

    pop ebx                              ; first arg address
    xor eax, eax                         ; clear eax
    xor edi, edi                         ; clear edi (edi = counts len of arg0)
loop_count_arg:
    mov al, byte [ebx+edi]               ; eax: char
    inc edi                              ; index++ (counter)
    cmp al, 0                            ; check if null
    jne loop_count_arg                   ; jump if null char
    dec edi                              ; excludes null char

    ; print buffer value
    mov ecx, ebx
    mov edx, edi
    call PrintStr
    Newline

exit:
    ; exit with success status
    mov eax, 1          ; system call for exit
    xor ebx, ebx        ; exit status of 0
    int 0x80            ; invoke the system call
