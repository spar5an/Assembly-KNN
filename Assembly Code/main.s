	#include <xc.inc>

extrn	setup_data, load_data, load_labels, point_1, point_2, calculate_distance, distance

psect	udata_acs
k:  ds	1
predict_point:	ds  3; this is going to  be an example point to classify
distance1:   ds	3;testing only
distance2:  ds	3;testing only
distance3:  ds	3;testing only

	
	
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
;	movlw	0x96
;	movwf	predict_point
;	movlw	0xfa
;	movwf	predict_point+1
;	movlw	0x1e
;	movwf	predict_point+2
;	;this is a point that should be classified as zero, not being used atm
	
	;test1
	movlw	0x00
	movwf	point1
	movwf	point1+1
	movwf	point1+2
	
	movlw	0xff
	movwf	point2
	movwf	point2+1
	movwf	point2+2
	
	call	calculate_distance
	movff	distance, distance1
	
	movlw	0x00
	movwf	point1
	movwf	point1+1
	movwf	point1+2
	
	movwf	point2
	movwf	point2+1
	movwf	point2+2
	
	call	calculate_distance
	movff	distance, distance2
	
	movlw	0x00
	movwf	point1
	movwf	point1+1
	movwf	point1+2
	
	
	movwf	point2
	movwf	point2+1
	movlw	0xff
	movwf	point2+2
	
	call	calculate_distance
	movff	distance, distance1

	goto	$
	
	end	main
