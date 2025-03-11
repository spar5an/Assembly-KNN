	#include <xc.inc>

extrn	setup_data, load_data, load_labels, point_1, point_2, calculate_distance, distance, long_reset, data_loc, label_loc

psect	udata_acs
k:  ds	1
predict_point:	ds  3; this is going to  be an example point to classify
data_pointer:	ds  1
label_pointer:	ds  1
counter:  ds	1

psect	udata_bank1
distance_storage:  ds	9;make sure this value is 3 times k
label_storage:	ds  3;the same as k

	
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

setup:	
	;;;;;;;;;; HERE IS K ;;;;;;;;;;
	movlw	0x03;will have a hard limit of like 30
	movwf	k
	
	call	setup_data
	
read_data:
	call	load_data
	call	load_labels
	call	long_reset
	
load_predict_point:
    	movlw	0x96
	movwf	predict_point
	movlw	0xfa
	movwf	predict_point+1
	movlw	0x1e
	movwf	predict_point+2
	;this is a point that should be classified as zero, not being used atm
	

predict:
	;load first K distances
	movff	k, counter, A
	call	load_pp_p1
	
	;create pointers
	lfsr	0,  data_loc;INDF0 stores data location
	lfsr	1,  label_loc;INDF1 stores label location
	
load_first_ks_loop:	
	;load dp into p2
	movff	INDF0, point_2
	movff	INDF0+1, point_2+1
	movff	INDF0+2, point_2+2
	
	;caculate and store distance
	call	calculate_distance
	movff	distance, distance_storage
	movff	distance+1, distance_storage+1
	movff	distance+2, distance_storage+2
	
	;store classification
	movff	INDF1, label_storage
	
	;iterate pointers
	movlw	0x03
	addwf	INDF0
	incf	INDF1
    
	decfsz	counter, A
	bra	load_first_ks_loop

	goto	$
	
	

load_pp_p1:
	movff	predict_point, point_1
	movff	predict_point+1, point_1+1
	movff	predict_point+2, point_1+2
	return
	