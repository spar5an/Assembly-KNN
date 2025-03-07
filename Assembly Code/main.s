	#include <xc.inc>

extrn	NUM1, NUM2, RESULT, long_add, long_subtract, long_reset, long_compare
	
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
	call	long_reset
	movlw	0x0
	movwf	NUM1+2, A
	movwf	NUM2+2, A
	movlw	0x00
	movwf	NUM1+1, A
	movlw	0x00
	movwf	NUM2+1, A
	call	long_compare
	
	movlw	0x1
	btfss	STATUS, 2
	movlw	0x2
	btfss	STATUS, 0
	movlw	0x3
	; if equal, will display 1, as both z and c are set
	; if n1>n2 will display 2
	; if n1<n2 will display 3
	
	movwf	PORTC, A
	movwf	PORTD, A
	movwf	PORTE, A
	goto	$
	
	end	main
