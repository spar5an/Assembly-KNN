	#include <xc.inc>

extrn	setup_data, load_data, load_labels

psect	udata_acs
k:  ds	1
predict_point:	ds  3; this is going to  be an example point to classify
	
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

setup:	
	call	setup_data
	
read:
	call	load_data
	call	load_labels
	
;test for tools
	movlw	0x96
	movwf	predict_point
	movlw	0xfa
	movwf	predict_point+1
	movlw	0x1e
	movwf	predict_point+2
	;this is a point that should be classified as zero
	
	


	goto	$
	
	end	main
