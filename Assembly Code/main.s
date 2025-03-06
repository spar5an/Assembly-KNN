	#include <xc.inc>

extrn	NUM1, NUM2, RESULT, long_add
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

setup:	
	movlw	0x0
	movwf	TRISC, A
	movwf	TRISD, A
	movwf	TRISE, A
	
	
read:
	movlw	0x01
	movwf	NUM1+2, A
	movwf	NUM2+2, A
	call	long_add
	movff	RESULT, PORTC, A
	movff	RESULT+1, PORTD, A
	movff	RESULT+2, PORTE, A
	goto	$
	
	end	main
