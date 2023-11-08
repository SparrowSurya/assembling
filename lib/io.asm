;; This file contains subroutine and macro for io

section .data
    endl db 0xA

section .text
    global PrintStr
    global InputStr
    global ErrorStr


; ##################################################
; STDOUT
; ##################################################

%macro mPrintStr 2
    ; 1: buffer/string address
    ; 2: length of buffer

    lea ecx, [%1]             ; pointer to buffer
    mov edx, %2               ; size of buffer
    call PrintStr
%endmacro

; size of buffer is already set
%macro mPrintStr_buf 1
    ; 1: buffer/string address

    lea ecx, [%1]             ; pointer to buffer
    call PrintStr
%endmacro

%macro mNewline 0
    mov edx, 1
    mov ecx, endl
    call PrintStr
%endmacro

PrintStr:
    mov ebx, 1                ; file descriptor for stdout
    mov eax, 4                ; syscall for write
    int 0x80                  ; invoke syscall
    ret


; ##################################################
; STDIN
; ##################################################

%macro mInputStr 2
    ; 1: buffer address
    ; 2: no bytes to read

    lea ecx, [%1]             ; pointer to buffer
    mov edx, %2               ; no of bytes to read
    call InputStr
%endmacro

; no of bytes to read is already set
%macro mInputStr_buf 1
    ; 1: buffer address

    lea ecx, [%1]             ; pointer to buffer
    call InputStr
%endmacro


InputStr:
    mov ebx, 0                ; file descriptior for stdin
    mov eax, 3                ; syscall for read
    int 0x80                  ; invoke syscall
    dec eax                   ; address of last byte entered (i.e. \n)
    mov byte [ecx+eax], 0     ; null terminating input (replacing \n with \0)
    ret


; ##################################################
; STDERR
; ##################################################

%macro mErrorStr 2
    ; 1: buffer/string address
    ; 2: size fo buffer/string

    lea ecx, [%1]             ; pointer to buffer
    mov edx, %2               ; size of buffer
    call ErrorStr
%endmacro

; size of buffer is already set
%macro mErrorStr_buf 2
    ; 1: buffer/string address

    lea ecx, [%1]             ; pointer to buffer
    call ErrorStr
%endmacro


ErrorStr:
    mov ebx, 2                ; file descriptior for stderr
    mov eax, 4                ; syscall for write
    int 0x80                  ; invoke syscall
    ret

