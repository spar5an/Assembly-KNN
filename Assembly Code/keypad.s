#include <xc.inc>
    
global KEYPAD_Setup, KEYPAD_Read, delay, total_input

psect	udata_acs
total_input: ds	    1
delay_count1: ds    1


    
psect	keypad_code, class=CODE
KEYPAD_Setup:
	movlb	0xf
	bsf	REPU;enable pullup resistors
	movlb   0
	clrf	LATE, A
	return
	
KEYPAD_Read:
	;read column data
	movlw	0x0F
	movwf	TRISE, A
	call	delay
	movff	PORTE, total_input, A
	
	;read row data
	movlw	0xF0
	movwf	TRISE, A
	call	delay
	movf	PORTE, W, A
	
	iorwf	total_input, f, A
	return
	
delay:	
	decf	delay_count1, A	; decrement until zero
	bc	delay
	return
	
	