; cast data into other format

section .text

    ; ascii digits array <=> unsigned number
    global Str2Uint
    global Uint2HexStr

; ##################################################
; Str2Uint
; ##################################################


; ASSERTION
; esi = buffer address (starting)
; ecx = no of chars/digits (only) to read

; INTERNAL
; ebx = 10
; eax

; RESULT
; eax: number

; CONSTRAINT
; bit-size <= 32
; unsigned number

; if no of digits in stored in memory
%macro mStr2Uint 2
    ; 1: buffer address
    ; 2. no of digits (stored in mem)

    lea esi, [%1]
    mov ecx, [%2]
    call Str2Uint
%endmacro

; if no of digits already stored in correct register
%macro mStr2Uint_buf 1
    ; 1: buffer address

    lea esi, [%1]
    call Str2Uint
%endmacro


Str2Uint:
    xor eax, eax               ; reset eax
    mov ebx, 10                ; needed for mul instruction
.mainloop:
    mul ebx                    ; shifting decimal place value
    mov dl, byte [esi]         ; reading digit from buffer
    sub edx, '0'               ; converting from ascii value to decimal value
    add eax, edx               ; adding the digit to eax
    inc esi                    ; moving to next digit
    dec ecx                    ; counting to know the used digits
    jnz .mainloop              ; jump if digits left to convert
    ret


; ##################################################
; Uint2Str
; ##################################################


; WORKING
; buffer filling from end to start address

; DEPENDENCY
; { mStr2Uint }

; ASSERT
; eax = number
; edi = buffer to store digits in (size should be 32-but)
; buffer have enough size to move store the digits

; RESULT
; ecx = no of digits wrote in buffer

; INTERNAL
; ebx = base of the number printed
; registers used during division edx, eax, ebx

; CONSTRAINT
; number should be 32-bit unsigned


%macro mUint2HexStr 2
    ; 1: buffer address
    ; 2: number (mem)

    lea edi, [%1]
    mov eax, [%2]
    call Uint2HexStr
%endmacro


Uint2HexStr:
    lea edi, [edi+31]          ; move to last byte of the buffer
    xor ecx, ecx               ; reset ecx
    mov ebx, 16                ; base to convert into
.mainloop:
    xor edx, edx               ;
    div ebx                    ; (edx:eax)/ebx -> quotient=eax, remainder=edx
    add dl, '0'                ; convert to ascii value of digit
    cmp dl, '9'                ; compare with ascii value 9
    jbe .write                 ; if less than or equal to ascii(9) jump
    add dl, 7                  ; converting to ABCDEF part of hexadecimal
.write:
    mov byte [edi], dl         ; storing in edi
    dec edi                    ; moving to left
    inc ecx                    ; incrementing the digit write count
    test eax, eax              ; eax=eax&eax, thus updating flags
    jnz .mainloop              ; jump if eax!=0
    ret
