;-------------------------------------------------------------------------------
;Erica Lewandowski 2016
;
;MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;Documentation: I worked with Capt Trimble for an hour on which commands to use.
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section

            .data
            .bss		store, 0x40
            .text

addArray:	.byte		0x14, 0x11, 0x32, 0x22, 0x08, 0x44, 0x04, 0x11, 0x08, 0x55

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
addOp:		.equ	0x11					; Assigning words to the operation values
subOp:		.equ	0x22
clrOp:		.equ	0x44
endOp:		.equ	0x55

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
			mov.w	#store, R10
			mov.w	#addArray, R5
			mov.b	@R5+, R6
bumpUp:
			mov.b	@R5+, R7
			mov.b	@R5+, R8

			cmp.b	#addOp, R7
			jeq		check11
			cmp.b	#subOp, R7
			jeq		check22
			cmp.b	#clrOp, R7
			jeq		check44
			cmp.b	#endOp, R7
			jeq		check55

check11:
			add.b	R8, R6
			cmp.b	#0x255, R6
			jge		maxValue
			cmp.b	#0x00 , R6
			jl		negativeValue
			mov.b	R6, 0(R10)
			inc		R10
			jmp		bumpUp

check22:
			sub.b	R6, R8		;the subtract function is not functioning correctly. The correct value should be x3e when the test function
								; is entered, but it's returning x2c
			cmp.b	#0x255, R8
			jge		maxValue
			cmp.b	#0x00 , R8
			jl		negativeValue
			mov.b 	R8, R9
			mov.b	R9, R6
			mov.b	R6, 0(R10)
			inc		R10
			jmp		bumpUp

check44:
			clr.b	R6
			cmp.b	#0x255, R6
			jge		maxValue
			cmp.b	#0x00 , R6
			jl		negativeValue
			mov.b	R6, 0(R10)
			inc		R10
			mov.b	R8, R6
			jmp		bumpUp

check55:
			jmp		forever

maxValue:
			mov.b	#0x255, R6


negativeValue:
			mov.b	#0x00, R6


forever:
			jmp		forever
;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack
;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
