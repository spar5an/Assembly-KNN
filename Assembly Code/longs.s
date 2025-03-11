#include <xc.inc>
   
;Library for mathematics involving 3 byte long numbers
;All are stored in bid endian
;Enter the numbers into NUM1+0/1/2 and NUM2+0/1/2 and result will come out
;In RESULT+0/1/2
;comp bit is set if NUM1 > NUM2 and long_compare is run

    
global long_add, long_subtract, long_compare, long_reset, NUM1, NUM2, RESULT

psect	udata_acs
NUM1:	ds 3
NUM2:	ds 3
RESULT:	ds 3

psect	long_code, class=CODE
long_reset:
    ;this is used to easily clear num1 and num2 
    ;useful for development, should be swapped out later if possible
    ;as it increases runtime
    movlw   0x0
    
    movwf    NUM1+2, A
    movwf    NUM1+1, A
    movwf    NUM1, A
    
    movwf    NUM2+2, A
    movwf    NUM2+1, A
    movwf    NUM2, A
    
    movwf    RESULT+2, A
    movwf    RESULT+1, A
    movwf    RESULT, A
    
    return
    
long_add:
    ;lowest
    movf    NUM1+2, W, A
    addwf   NUM2+2, W, A
    movwf   RESULT+2, A
    
    ;middle
    movf    NUM1+1, W
    addwfc  NUM2+1, W
    movwf   RESULT+1, A
    
    ;highest
    movf    NUM1, W
    addwfc  NUM2, W
    movwf   RESULT

    return

 long_subtract:
    ;lowest
    movf    NUM1+2, W, A
    subwf   NUM2+2, W, A
    movwf   RESULT+2, A
    
    ;middle
    movf    NUM1+1, W
    subwfb  NUM2+1, W
    movwf   RESULT+1, A
    
    ;highest
    movf    NUM1, W
    subwfb  NUM2, W
    movwf   RESULT

    return

long_compare:
    ;stole this architecture from chatgpt because it was very good
    ;only changed the gotos to bras to make them quicker
    ;Compare Most Significant Byte (MSB)
    movf    NUM1, W         ; Load NUM1 MSB into WREG
    subwf   NUM2, W         ; WREG = NUM1 - NUM2
    btfss   STATUS, 2       ; If Z=1 (NUM1 MSB == NUM2 MSB), skip next instruction
    bra    compare_done    ; If MSB is different, we are done (C or N decides result)

    ; Compare Middle Byte
    movf    NUM1+1, W       ; Load NUM1 middle byte
    subwf   NUM2+1, W       ; WREG = NUM1+1 - NUM2+1
    btfss   STATUS, 2       ; If Z=1 (bytes are equal), skip next instruction
    bra    compare_done    ; If different, we are done

    ; Compare Least Significant Byte (LSB)
    movf    NUM1+2, W       ; Load NUM1 LSB
    subwf   NUM2+2, W       ; WREG = NUM1+2 - NUM2+2

compare_done:
    ; Result is stored in STATUS register:
    ; - C (Carry) = 1 if NUM1 >= NUM2
    ; - C (Carry) = 0 if NUM1 < NUM2
    ; - Z (Zero)  = 1 if NUM1 == NUM2 and also C = 1
    return
    