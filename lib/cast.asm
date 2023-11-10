; ********************************************************************************
; This file contains subroutine & macros for casting between uint & str
; ********************************************************************************


section .text

    global Str2Uint
    global Uint2Str


; ********************************************************************************
; Str2Uint subroutine:
;   convertes from string in decimal to decimal number
;   i.e. '23' -> 23
;
; Requirements
; ------------
;   ESI = buffer address
;   ECX = no of chars to read from buffer
;
; Registers used
; --------------
;   EBX: constant (10)
;   EAX: storing the number
;
; Result
; ------
;   EAX = uint
;
; Constraint
; -------
;   * at max supports 32-bit number
;   * string should only contain chars [0123456789]
;
; Working
; -------
;   1. divides the number to get
; ********************************************************************************

Str2Uint:
    xor eax, eax               ; reset eax
    mov ebx, 10                ; divisor
.mainloop:
    mul ebx                    ; increasing decimal place value
    mov dl, byte [esi]         ; reading digit from buffer
    sub edx, '0'               ; converting from ascii value to decimal value
    add eax, edx               ; adding the digit to eax
    inc esi                    ; moving to next digit
    dec ecx                    ; counting to know the digits left
    jnz .mainloop              ; jump if count not zero
    ret


; macro for Str2Uint
; 1: buffer address
; 2. no of digits (value)
%macro CallStr2Uint 2
    lea esi, [%1]
    mov ecx, %2
    call Str2Uint
%endmacro


; ********************************************************************************
; Uint2Str subroutine:
;   converts the decimal number to string
;   i.e. 23 -> '23'
;
; Requirements
; ------------
;   EAX = number
;   EDI = buffer to store chars in it
;
; Registers used
; --------------
;   ECX: chars wrote to buffer
;   EBX: base (10) for division
;    DL: stores the ascii value (temporary)
;
; Result
; ------
;   ECX = number of chars wrote
;
; Constraint
; ----------
;   * number should be 32-bit
;   * number must be unsigned
;   * buffer should have length 32-bits (4bytes)
;   * characters wrote to buffer [0123456789ABCDEF]
;   * does not prefix '0x'
; ********************************************************************************

Uint2Str:
    lea edi, [edi+31]          ; move to last byte of the buffer
    xor ecx, ecx               ; reset ecx
    mov ebx, 10                ; base 10 (const)
.mainloop:
    xor edx, edx               ; to prevent floating point or overflow exception
    div ebx                    ; (edx:eax)/ebx -> quotient=eax, remainder=edx
    add dl, '0'                ; convert to ascii value of digit
    mov byte [edi], dl         ; storing in buffer
    dec edi                    ; moving to left of buffer
    inc ecx                    ; incrementing the digit write count
    test eax, eax              ; eax=eax&eax, thus updating flags
    jnz .mainloop              ; jump if eax!=0
    ret


; macro for Uint2Str
; 1: buffer address
; 2: number (value)
%macro CallUint2Str 2
    lea edi, [%1]
    mov eax, %2
    call Uint2Str
%endmacro
