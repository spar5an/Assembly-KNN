	#include <xc.inc>

extrn	NUM1, NUM2, RESULT, long_add
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100


psect	main_code, class=CODE
setup:	
	movlw	0x0
	movwf	TRISC, A
	movwf	TRISD, A
	movwf	TRISE, A
	
	
read:
	movlw	0x01
	movwf	NUM1, A
	movwf	NUM2, A
	call	long_add
	movf	RESULT, PORTC, A
	movf	RESULT+1, PORTD, A
	movf	RESULT+2, PORTE, A
