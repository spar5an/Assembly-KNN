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
    ; Add LSB (Least Significant Byte) with Carry
    MOVF NUM1+2, W  ; Load NUM1 low byte (NUM1+2) into WREG
    BTFSC STATUS, 0 ; Check Carry bit (STATUS, 0 for carry flag)
    INCF WREG, F    ; If carry set, increment WREG
    ADDWF NUM2+2, W ; Add NUM2 low byte (NUM2+2)
    MOVWF RESULT+2  ; Store low byte in RESULT (RESULT+2)
    
    ; Add Middle Byte with Carry
    MOVF NUM1+1, W  ; Load NUM1 middle byte (NUM1+1) into WREG
    BTFSC STATUS, 0 ; Check Carry bit (STATUS, 0 for carry flag)
    INCF WREG, F    ; If carry set, increment WREG
    ADDWF NUM2+1, W ; Add NUM2 middle byte (NUM2+1)
    MOVWF RESULT+1  ; Store middle byte in RESULT (RESULT+1)
    
    ; Add MSB (Most Significant Byte) first
    MOVF NUM1, W    ; Load NUM1 high byte (NUM1+0) into WREG
    ADDWF NUM2, W   ; Add NUM2 high byte (NUM2+0)
    MOVWF RESULT    ; Store high byte in RESULT (RESULT+0)





    RETURN


	
	