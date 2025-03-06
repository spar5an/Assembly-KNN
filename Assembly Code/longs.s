#include <xc.inc>
   
;Library for mathematics involving 3 byte long numbers
;All are stored in bid endian
;Enter the numbers into NUM1+0/1/2 and NUM2+0/1/2 and result will come out
;In RESULT+0/1/2

    
global long_add, NUM1, NUM2, RESULT

psect	udata_acs
NUM1:	ds 3
NUM2:	ds 3
RESULT:	ds 3


long_add:
    ;lowest
    movf    NUM1+2, W
    addwf   NUM2+2, W
    movwf   RESULT+2
    
    ;middle
    movf    NUM1+1, W
    btfsc   STATUS, 0
    incf    W, F
    addwf   NUM2+1, W
    movwf   RESULT+1
    
    ;highest
    movf    NUM1, W
    btfsc   STATUS, 0
    incf    W, F
    addwf   NUM2, W
    movwf   RESULT





    RETURN


	
	