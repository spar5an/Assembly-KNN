#include <xc.inc>
;this file will contain all the tools needed for KNN

extrn	long_reset, long_add, long_subtract, long_compare, NUM1, NUM2, RESULT

;NONE OF THIS CODE HAS BEEN TESTED
global	calculate_distance, point_1, point_2, distance, parameter_1, parameter_2
    
psect	udata_acs
point_1:    ds	3
point_2:    ds	3
parameter_1:	ds  1
parameter_2:	ds  1
distance: ds  3
temp:	ds  1;these are useful for flipping w and squaring
temp2:	ds  1

    
psect	KNN_code, class=CODE
flip_w:;this might be replacable with an xor
    movwf   temp, A
    movlw   0x00
    movwf   temp2, A
    movf    temp, W
    subwf   temp2, W, A
    return
    
calculate_difference:
    ;takes 2 parameters 1 byte each and returns distance
    movf    parameter_1, W
    subwf   parameter_2, W
    btfss   STATUS, 0 ;this is cool, think about it
    call    flip_w
    return  ;output is stored in w
    
calculate_distance:
    movlw   0x00
    movwf   distance, A
    movwf   distance+1, A
    movwf   distance+2, A
    
    ;this was written before with a loop and pointers
    ;pointers are too valuable to waste on this task
    ;i only have 3
    ;enjoy man made horrors beyond my creation
   
    movff   point_1, parameter_1
    movff   point_2, parameter_2
    call    calculate_difference
    
    movwf   temp, A
    mulwf   temp
    
    movff   distance, NUM1
    movff   distance+1, NUM1+1
    movff   distance+2, NUM1+2
    
    movlw   0x00
    movwf   NUM2
    
    movff   PRODH, NUM2+1
    movff   PRODL, NUM2+2
    
    call    long_add
    
    movff   RESULT, distance
    movff   RESULT+1, distance+1
    movff   RESULT+2, distance+2
    
    movff   point_1+1, parameter_1
    movff   point_2+1, parameter_2
    call    calculate_difference
    
    movwf   temp, A
    mulwf   temp
    
    movff   distance, NUM1
    movff   distance+1, NUM1+1
    movff   distance+2, NUM1+2
    
    movlw   0x00
    movwf   NUM2
    
    movff   PRODH, NUM2+1
    movff   PRODL, NUM2+2
    
    call    long_add
    
    movff   RESULT, distance
    movff   RESULT+1, distance+1
    movff   RESULT+2, distance+2
    
    movff   point_1+2, parameter_1
    movff   point_2+2, parameter_2
    call    calculate_difference
    
    movwf   temp, A
    mulwf   temp
    
    movff   distance, NUM1
    movff   distance+1, NUM1+1
    movff   distance+2, NUM1+2
    
    movlw   0x00
    movwf   NUM2
    
    movff   PRODH, NUM2+1
    movff   PRODL, NUM2+2
    
    call    long_add
    
    movff   RESULT, distance
    movff   RESULT+1, distance+1
    movff   RESULT+2, distance+2
    
    ;i hate this
    
    return
    
    
    
    
    
    
    

    
    
    
    

