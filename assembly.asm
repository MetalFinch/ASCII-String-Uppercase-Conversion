Assembly code :
; -----------------------------------------------------------
; Microcontroller Based Systems Homework
; Author name: Biswas Md Iqbal Hossain
; Neptun code: AAYWO6
; -------------------------------------------------------------------
; Task description: 
;   Convert a sentence (ASCII string) to uppercase. Be sure to change only 
;   the lowercase letters (uppercase and other characters do not change).
;   Input: Start address of the string (pointer)
;   Output: The modified string at the same place
; -------------------------------------------------------------------


; Definitions
; -------------------------------------------------------------------

; Address symbols for creating pointers

STR_ADDR_IRAM  EQU 0x40

; Test data for input parameters
; (Try also other values while testing your code.)

; Store the string in the code memory as an array

ORG 0x0070 ; Move if more code memory is required for the program code
STR_ADDR_CODE:
DB "hElLO woRlD!?0@"
DB 0

; Interrupt jump table
ORG 0x0000;
    SJMP  MAIN                  ; Reset vector



; Beginning of the user program, move it freely if needed
ORG 0x0010

; -------------------------------------------------------------------
; MAIN program
; -------------------------------------------------------------------
; Purpose: Prepare the inputs and call the subroutines
; -------------------------------------------------------------------

MAIN:

    ; Prepare input parameters for the subroutine
	MOV DPTR,#STR_ADDR_CODE
	MOV R7,#STR_ADDR_IRAM
	CALL STR_CODE2IRAM ; Copy the string from code memory to internal memory
	
	MOV R7, #STR_ADDR_IRAM
; Infinite loop: Call the subroutine repeatedly
LOOP:

    CALL STR_UPPERCASE ; Call string uppercase subroutine

    SJMP  LOOP




; ===================================================================           
;                           SUBROUTINE(S)
; ===================================================================           


; -------------------------------------------------------------------
; STR_CODE2IRAM
; -------------------------------------------------------------------
; Purpose:
;   Copy a null-terminated ASCII string from code memory (ROM)
;   to internal RAM (IRAM). The NUL terminator (00h) is also copied.
; -------------------------------------------------------------------
; INPUT(S):
;   DPTR - Base address of the string in code memory (16 bits)
;   R7   - Base address of the target location in internal RAM
; OUTPUT(S):
;   The string is stored in internal RAM starting at address [R7].
; MODIFIES:
;   A, R0, DPTR, PSW
; -------------------------------------------------------------------

STR_CODE2IRAM:
    PUSH    ACC          ; Save accumulator to stack (used for temporary storage)
    PUSH    PSW          ; Save Program Status Word (contains flags)

    MOV     A, R7        ; Copy base address of IRAM target to accumulator
    MOV     R0, A        ; Copy accumulator to R0 → will be used for indirect addressing

C2I_L:
    CLR     A             ; Clear accumulator (optional, MOVC will overwrite it)
    MOVC    A, @A+DPTR    ; Read byte from code memory at DPTR offset by A (0)-CODE[DPTR]
    MOV     @R0, A        ; Store the byte into IRAM at address pointed by R0
    JZ      C2I_DONE      ; If byte is 00h (null terminator), exit loop
    INC     DPTR           ; Move to next byte in code memory
    INC     R0             ; Move to next byte in IRAM
    SJMP    C2I_L          ; Repeat the loop for next character

C2I_DONE:
    POP     PSW           ; Restore PSW to original state
    POP     ACC           ; Restore accumulator to original value
    RET                   ; Return to caller


; -------------------------------------------------------------------
; STR_UPPERCASE
; -------------------------------------------------------------------
; Purpose:
;   Convert all lowercase ASCII letters ('a'..'z') in a string
;   stored in internal RAM to uppercase ('A'..'Z').
;   Other characters remain unchanged.
; -------------------------------------------------------------------
; INPUT(S):
;   R7 - Base address of the string in internal RAM
; OUTPUT(S):
;   The modified (uppercase) string is written in-place.
; MODIFIES:
;   A, R0, PSW
; -------------------------------------------------------------------

STR_UPPERCASE:
    PUSH    ACC          ; Save accumulator (used to process each character)
    PUSH    PSW          ; Save PSW (status flags)

    MOV     A, R7
    MOV     R0, A        ; R0 points to the start of the string in IRAM for indirect addressing

UP_L:
    MOV     A, @R0       ; Load current character from IRAM
    JZ      UP_DONE      ; If null terminator (00h), exit loop

    ; Check if character is lowercase ('a' = 0x61, 'z' = 0x7A)
    CJNE    A, #061h, CHK_LOW ; Compare with 'a', jump if not equal
    SJMP    IN_RANGE           ; If A == 'a', it is lowercase, go to conversion

CHK_LOW:
    JC      STORE        ; If A < 'a' (0x61), it is not lowercase ,skip conversion
    CJNE    A, #07Bh, CHK_7B ; Compare with 0x7B ('z'+1)
    SJMP    STORE        ; If A == 0x7B, skip conversion

CHK_7B:
    JNC     STORE        ; If A >= 0x7B, it is not lowercase, skip conversion

IN_RANGE:
    ANL     A, #0DFh     ; Clear bit 5 → converts lowercase to uppercase ('a'-'z' to 'A'-'Z')

STORE:
    MOV     @R0, A       ; Store (converted or unchanged) character back into IRAM
    INC     R0            ; Move to next character in string
    SJMP    UP_L          ; Repeat the loop

UP_DONE:
    POP     PSW           ; Restore PSW
    POP     ACC           ; Restore accumulator
    RET                   ; Return to caller
