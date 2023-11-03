; This contains `print_hex` symbol
; It prints number in hexadecimal value (uppercase)
; place the number into eax register

; allocated buffer size
%define SIZE 8

section .bss
    buffer resb SIZE

section .text
    global print_hex

; EAX = number (given)
; EBX = base (used implicit)
; ECX = size of buffer used (used implicit)

print_hex:
    mov ebx, 16                 ; ebx contains base
    xor ecx, ecx                ; ecx contains the size of buffer used (initially 0)
    lea esi, [buffer+SIZE]      ; move to the byte address next to last byte of buffer
    mov byte [esi], 0           ; null terminator at end of buffer
    dec esi                     ; decrement esi to point to last byte of buffer

; division
; divisor: mentioned register in div instruction
; divident: EAX (initially)
; remainder: EDX
; quotient: EAX

_print_hex__divide:
    xor edx, edx                ; set edx=0
    div ebx                     ; divide eax by edi (base), quotient in eax, remainder in edx
    add dl, '0'                 ; ascii value of digit in dl (remainder: 4bit/hex-digit)
    cmp dl, '9'                 ; compare ascii dl & ascii '9'
    jbe _print_hex__store       ; store if ascii in range 0-9
    add dl, 7                   ; add 7 (to use alphabet for A-F)

_print_hex__store:
    mov byte [esi], dl          ; store digit in buffer
    dec esi                     ; point to prev byte
    inc ecx                     ; counts size of buffer used
    test eax, eax               ; performs AND opr of eax with eax
    jnz _print_hex__divide      ; jump if eax!=0, as zero flag is modified by above opr

_print_hex__print:
    mov edx, ecx                ; size of buffer used

    ; evaluates starting address of buffer
    lea ecx, [buffer+SIZE]      ; move to end of buffer
    sub ecx, edx                ; subtract the size of buffer used

    mov ebx, 1                  ; file descriptor 1 (stdout)
    mov eax, 4                  ; system call number 4 (write)
    int 0x80                    ; invoke system call
    ret                         ; return
