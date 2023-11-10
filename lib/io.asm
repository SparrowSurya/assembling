; ********************************************************************************
; This file contains subroutine for
; writing to stdout & sterr and reading from stdin
; ********************************************************************************


section .data

    ; newline character
    endl db 0xA


section .text
    global PrintStr
    global InputStr
    global ErrorStr


; ********************************************************************************
; PrintStr subroutine (STDOUT)
;
; Requirement
; -----------
;   1. ECX = pointer to buffer in ECX
;   2. EDX = no of characters to write to stdout
;
; Registers used
; --------------
;   EAX: file decriptior for stdout
;   EBX: syscall number for write
; ********************************************************************************

PrintStr:
    mov ebx, 1
    mov eax, 4
    int 0x80
    ret


; macro for PrintStr
; 1: buffer address
; 2: size of buffer (value)
%macro CallPrintStr 2
    lea ecx, [%1]
    mov edx, %2
    call PrintStr
%endmacro


; macro for printing newline
%macro Newline 0
    mov edx, 1
    mov ecx, endl
    call PrintStr
%endmacro


; ********************************************************************************
; InputStr subroutine (STDIN)
;
; Requirement
; -----------
;   ECX = pointer to address of buffer
;   EDX = no of bytes to read from stdin
;
; Registers used
; --------------
;   EAX: syscall number for read
;   EBX: file descriptior for stdin
;
; Result
; ------
;   EAX = no of chars entered by user
;
; Extra Functionality
; -------------------
;   * Ignore the newline character and replaces it with null char
;   * number of chars entered by user does not includes the newline character
;
; Explanation
; -----------
;   $ Hello<ENTER>
;
;   +--------+------------------+------------------+
;   |        |     ORIGINAL     |      FINAL       |
;   +--------+------------------+------------------+
;   | String |     "Hello\n     |    "Hello\0"     |
;   +--------+------------------+------------------+
;   | Length |        6         |        5         |
;   +--------+------------------+------------------+
;
; ********************************************************************************

InputStr:
    mov ebx, 0
    mov eax, 3
    int 0x80

    ; trimming newline character and adjusting length
    dec eax
    mov byte [ecx+eax], 0
    ret


; macro for InputStr
; 1: buffer address
; 2: no of chars to read (value)
%macro CallInputStr 2
    lea ecx, [%1]
    mov edx, %2
    call InputStr
%endmacro


; ********************************************************************************
; ErrorStr subroutine (STDERR)
;
; Requirement
; -----------
;   ECX = pointer to buffer in ECX
;   EDX = no of characters to write to stderr
;
; Registers used
; --------------
;   EBX: file decriptior for stderr
;   EAX: syscall number for write
; ********************************************************************************

ErrorStr:
    mov ebx, 2                ; file descriptior for stderr
    mov eax, 4                ; syscall for write
    int 0x80                  ; invoke syscall
    ret


; macro for ErrorStr
; 1: buffer address
; 2: size of buffer (value)
%macro CallErrorStr 2
    lea ecx, [%1]             ; pointer to buffer
    mov edx, %2               ; size of buffer
    call ErrorStr
%endmacro
