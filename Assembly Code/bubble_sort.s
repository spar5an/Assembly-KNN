#include <xc.inc>

    ;this will sort the data in bank 1
    ;which holds distances
    
    
extrn	long_compare, NUM1, NUM2, k
    
global	bubble_sort
    
psect	udata_acs
length:	    ds  1 ;really this will hold length minus one
swap_loc:   ds	2
counter:    ds	1
swap_performed:	ds  1
storage:    ds	4
    
psect	bubble_code, class=CODE
bubble_sort:
    ;going to predict how far the end of the data should be from 0x100, then minus one
    ;FSR2 should be there and swap_performed clear
    
    movf    k, W
    mullw   0x04
    ;only going to worry about lower, as there shouldnt be a higher
    movff   PRODL, length
    decf    length
    
    
start_one:
    lfsr    2, 0x100
    
start_two:    
    bcf	    swap_performed, 0
    
    movff   POSTINC2, NUM1
    movff   POSTINC2, NUM1+1
    movff   POSTINC2, NUM1+2
    
    incf    FSR2
    
    movff   POSTINC2, NUM2
    movff   POSTINC2, NUM2+1
    movff   POSTINC2, NUM2+2
    
    call    long_compare
    btfss   STATUS, 2
    call    check_hl;have to use this as it only skips 1 instruction
    
    btfsc   swap_performed, 0
    bra	    start_one
    
    movf    length, W
    subwf   FSR2L, W
    btfsc   STATUS, 2
    return
    
    
    movlw   0x03
    subwf   FSR2
    bra	    start_two
        
    
check_hl:
    btfss   STATUS, 0
    call    swap
    return
    

swap:
    bsf	    swap_performed, 0
    
    ;fsr2 should be 7 above swap start
    movlw   0x07
    subwf   FSR2 ;this is unsafe, 8bit maths on 12bit number, but it should work
    movff   FSR2H, swap_loc
    movff   FSR2L, swap_loc+1
    addwf   FSR2
    
    
    call load_beginning
    lfsr    1, storage;using this for elegance, can be swapped later
    
    ;load first distance+label into storage
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    
    ;reset INDFO and point INDF1 at second d+l
    call    load_beginning
    
    movff   FSR0H, FSR1H
    movff   FSR0L, FSR1L
    movlw   0x04
    addwf   FSR1
    
    
    ;mov 2nd d+l to first position
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    
    ;point INDF1 at storage
    ;INDF0 is already pointing at 2nd d+l
    lfsr    1,	storage
    
    ;mov 1st d+l from storage to 2nd position
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    movff   POSTINC1, POSTINC0
    
    return

load_beginning:
    ;loads the begining of the swap location into INDF0
    movf    low swap_loc, W
    movwf   FSR0H
    
    movf    swap_loc+1, W
    movwf   FSR0L
    
    return

