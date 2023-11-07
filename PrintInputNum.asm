; assembly program which takes a number input and prints it

extern print_hex

section .bss
    input_buffer resb 64

section .data
    endl db 0xa

    prompt_input db "Enter the number: "
    prompt_input_len equ $-prompt_input

    prompt_num db "Number: "
    prompt_num_len equ $-prompt_num

    bytes_entered dd 0
    number db 0


; write the message to stdout
%macro print_str 2
    ; param-1: string address
    ; param=2: string length

    lea ecx, [%1]       ; pointer to message to write
    mov edx, %2         ; length of message
    mov ebx, 1          ; file descriptor for stdout
    mov eax, 4          ; system call for write
    int 0x80            ; invoke the system call
%endmacro


; store to buffer from stdin
; no of bytes entered is stored in eax
%macro input_str 3
    ; param-1: buffer address
    ; param=2: buffer length
    ; param-3: memory to store no of bytes entered

    lea ecx, [%1]             ; pointer to the input buffer
    mov edx, %2               ; maximum number of bytes to read
    mov eax, 3                ; syscall number for sys_read
    mov ebx, 0                ; file descriptor for stdin
    int 0x80                  ; invoke syscall
    mov byte [ecx + eax], 0   ; null terminating input
    mov [%3], eax
%endmacro


; write number to stdout
%macro print_num 1
    ; param-1: number

    mov eax, [%1]         ; storing value at address into eax
    call print_hex
%endmacro


; to print newline character
%macro print_newline 0
    call print_str endl, 1
%endmacro


section .text:
    global _start

_start:
    print_str prompt_input, prompt_input_len
    input_str input_buffer, 64, bytes_entered

    ; converting from ascii sequence to number
    mov ecx, [bytes_entered]  ; bytes entered by user including the carriage return
    lea esi, input_buffer     ; loading address of buffer
    call str_to_int
    mov [number], eax         ; storing the value evaluated

    print_str prompt_num, prompt_num_len
    print_num number
    print_newline

    ; exit with success status
    mov eax, 1          ; system call for exit
    xor ebx, ebx        ; exit status of 0
    int 0x80            ; invoke the system call


; subroutine
; [in] buffer in esi register
; [in] length in ecx
; [out] number in eax
str_to_int:
    dec ecx                 ; ignoring the newline char
    xor eax, eax            ; reset the eax
    mov ebx, 10             ; to move the decimal place value by 1
str_to_int__loop:
    mul ebx                 ; eax = eax * ebx{=10} (edx:eax)
    mov dl, byte [esi]      ; edx = value at address in esi; ASSERTING all higher bits 0
    sub edx, '0'            ; converting from ascii value to int value
    add eax, edx            ; eax = eax + edx
    inc esi                 ; move to next char
    dec ecx                 ; evaluating the bytes left to convert
    jnz str_to_int__loop    ; jump if ecx not zero
    ret                     ; return
