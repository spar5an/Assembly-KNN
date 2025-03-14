	#include <xc.inc>

extrn	setup_data, load_data, point_1, point_2, calculate_distance, distance, long_reset, data_loc, bubble_sort
extrn	NUM1, NUM2, RESULT, long_compare

global k
	
psect	udata_acs
k:  ds	1
predict_point:	ds  3; this is going to  be an example point to classify
data_pointer:	ds  1
counter:  ds	1
storage_dl:  ds	4;this stores the distance to and the label of the point we are testing
endpoint:   ds	1

psect	udata_bank1
distance_storage:  ds	12;make sure this value is 4 times k

	
	
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
	call	long_reset
	
load_predict_point:
    	movlw	0x96
	movwf	predict_point
	movlw	0xfa
	movwf	predict_point+1
	movlw	0x1e
	movwf	predict_point+2
	;this is a point that should be classified as zero, not being used atm
	

train:
	;load first K distances
	movff	k, counter, A
	call	load_pp_p1
	
	;create pointers
	lfsr	0,  distance_storage;INDF0 stores distance location
	lfsr	1,  data_loc;INDF1 stores data_location
	
load_first_points:	
	;load dp into p2
	movff	POSTINC1, point_2
	movff	POSTINC1, point_2+1
	movff	POSTINC1, point_2+2
	
	;caculate and store distance
	call	calculate_distance
	movff	distance, POSTINC0
	movff	distance+1, POSTINC0
	movff	distance+2, POSTINC0
	
	;with new data structure (as of 11/03/) label stored directly after point
	;so both pointers should now be looking at labels
	
	;copying labels
	movff	POSTINC1, POSTINC0
    
	decfsz	counter, A
	bra	load_first_points
	
	call	bubble_sort
	
	
predict:
	;point fsr1 at 0x200
	lfsr	1, 0x200
	
	;calculate distance to points
	movlw	0x04
	mulwf	k
	
	movf	PRODL, W;technically unsafe but if multiplation goes baove 255 then it deserves  to break anyway
	addwf	FSR1, f;should now be pointing at new point
	
	;perform distance calculation
	call	load_pp_p1;loads prediction point into p1 in knn_tools
	movff	POSTINC1, point_2
	movff	POSTINC1, point_2+1
	movff	POSTINC1, point_2+2
	
	call	calculate_distance
	
	movff	distance, storage_dl;this can be optimised
	movff	distance+1, storage_dl+1
	movff	distance+2, storage_dl+2
	movff	POSTINC1,   storage_dl+3
	
	;loop compare distances
	;loading dl into num1
	movff	storage_dl, NUM1
	movff	storage_dl+1, NUM1+1
	movff	storage_dl+2, NUM1+2
	
	lfsr	2, 0x100;point fsr2 at beginning of k points
	
	movf	k, W
	movwf	counter
compare_loop:
	movff	POSTINC2, NUM2
	movff	POSTINC2, NUM2+1
	movff	POSTINC2, NUM2+2
	
	incf	FSR2 ;move it past the label

	call	long_compare
	btfsc	STATUS, 0
	call	check_eq
	
	decfsz	counter
	bra	compare_loop
	
	goto	$
	
	
check_eq:
	btfss	STATUS, 2
	call	cascading_push
	return
	
cascading_push:
	;this is going to be the most difficult task in the whole project
	;aiming to insert the new point into the k d+l storage
	;and in the process delete the last entry
	
	;calculate endpoint
	movf	counter, W
	subwf	k, W
	mullw	0x04
	movff	PRODL, endpoint
	movlw	0x04
	addwf	endpoint, f
	
	;check if pushing the last point
	movf	0x01
	subwf	counter, w
	btfss	STATUS, 2
	bra	
	
	
	
	

	;start backwards, copy second last element into last storage
	movf	k, W
	mullw	0x04
	
	movlw	0x04
	subwf	PRODL, W
	
	movwf	FSR0L
	movlw	0x08
	subwf	PRODL, W
	movwf	FSR2L
	;fsr2 looking at 2nd last point, fsr0 looking at last
	
push_loop:	
	call	copy_push
	;check if fsr2 is at the correct address
	movf	endpoint, W
	subwf	FSR2L, W
	btfss	STATUS, 2
	bra	sub8
	
inject:
	;now to inject the new point
	call	sub4;moves fsr2 into position
	
	movff	storage_dl, POSTINC2
	movff	storage_dl+1, POSTINC2
	movff	storage_dl+2, POSTINC2
	movff	storage_dl+3, POSTINC2
	
	
	return

sub8:
	movlw	0x08
	subwf	FSR2L, f
	subwf	FSR0L, f
	bra	push_loop
	
sub4:
	movlw	0x04
	subwf	FSR2L, f
	return
	
copy_push:
	;take where fsr2 and move to fsr0
	;this will be possible without 2 pointers but they make it easier
	movff	POSTINC2, POSTINC0
	movff	POSTINC2, POSTINC0
	movff	POSTINC2, POSTINC0
	movff	POSTINC2, POSTINC0

	return

load_pp_p1:
	movff	predict_point, point_1
	movff	predict_point+1, point_1+1
	movff	predict_point+2, point_1+2
	return
	