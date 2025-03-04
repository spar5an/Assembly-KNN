	#include <xc.inc>

extrn	KEYPAD_Setup, KEYPAD_Read, total_input
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100


psect	main_code, class=CODE
setup:	
	call	KEYPAD_Setup
	movlw	0x00
	movwf	TRISH, A
	
	
read:
	call	KEYPAD_Read
	movff	total_input, PORTH, A
	bra	read
