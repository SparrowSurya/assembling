; assembly program which takes a number input and prints it


%include "lib/io.asm"
%include "lib/cast.asm"

%define BUF_SIZE 32

section .bss
    buffer resb BUF_SIZE

section .data
    sAskNum1 db "Num1: "
    lAskNum1 equ $-sAskNum1

    sAskNum2 db "Num2: "
    lAskNum2 equ $-sAskNum2

    sShowNum db "Sum: "
    lShowNum equ $-sShowNum

    num1_size dd 0
    num2_size dd 0

    num1 dd 0
    num2 dd 0
    sum dd 0

    sum_size dd 0


section .text
    global _start

_start:
    mPrintStr sAskNum1, lAskNum1    ; prompt for num1
    mInputStr buffer, BUF_SIZE      ; read input
    mov [num1_size], eax            ; store input size
    mStr2Uint buffer, num1_size     ; convert from ascii arr to uint
    mov [num1], eax                 ; store the uint value to num1

    mPrintStr sAskNum2, lAskNum2    ; prompt for num2
    mInputStr buffer, BUF_SIZE      ; read input
    mov [num2_size], eax            ; store input size
    mStr2Uint buffer, num2_size     ; convert from ascii arr to uint
    mov [num2], eax                 ; store the uint value to num2

    mov eax, [num1]                 ; load num1
    add eax, [num2]                 ; add num2
    mov [sum], eax                  ; store result in sum
    mUint2HexStr buffer, sum        ; convert from uint to hex string
    mov [sum_size], ecx             ; storing the size of string

    mPrintStr sShowNum, lShowNum    ; prompt for sum
    mov eax, 32
    sub eax, [sum_size]
    lea ecx, [buffer+eax]
    mov edx, sum_size
    call PrintStr
    mNewline                        ; newline

exit:                               ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
