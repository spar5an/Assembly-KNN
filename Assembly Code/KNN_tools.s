#include <xc.inc>
;this file will contain all the tools needed for KNN

extrn	long_subtract, long_compare, NUM1, NUM2, RESULT
    
psect	udata_acs
point_1:    ds	3
point_2:    ds	3
parameter_1:	ds  1
parameter_2:	ds  1
total_distance: ds  3
temp:	ds  1;this is useful for flipping w

    
psect	KNN_code, class=CODE
flip_w:
    
    
calculate_distance:
    ;takes 2 parameters 1 byte each and returns distance
    
    movf    parameter_1, W
    subwf   parameter_2, W
    btfsc   STATUS, 0
    sublw   0xff    ;this will flip the distance
    
    
    

