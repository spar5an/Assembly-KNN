#include <xc.inc>

    ;this will sort the data in bank 1
    ;which holds distances
    
    
extrn	long_compare
    
global	bubble_sort
    
psect	udata_acs
length:	    ds  1
swap_loc:   ds	2
counter:    ds	1
sorted:	    ds	1
storage:    ds	4
    
psect	bubble_code, class=CODE
bubble_sort:
    lfsr    0, 0x100
    ;first location loaded into INDF0
    ;just goint to swap first 2 to test
    
    movlw   0x01
    movwf   swap_loc
    movlw   0x00
    movwf   swap_loc+1
    
    call load_beggining
    

swap:
    lfsr    1, storage;using this for elegance, can be swapped later
    
    ;load first distance+label into storage
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    movff   POSTINC0, POSTINC1
    
    ;reset INDFO and point INDF1 at second d+l
    lfsr    0,	0x100
    
    lfsr    1,	0x100+0x004
    
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

