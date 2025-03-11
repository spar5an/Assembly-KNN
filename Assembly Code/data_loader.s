#include <xc.inc>

    
global	setup_data, load_data, load_labels, data_loc, label_loc
;this is a temporary solution to load some data in to begin coding the KNN
;20 binary data points with 3 parameters each

psect UDATA_SHR; this is wrong as data is writing over it but is not needed atm
data_loc:   ds	60
label_loc:  ds	20
counter:    ds	1
    
psect	data_code, class=CODE
data:
	db	    0xb1, 0x16, 0xbf, 0xff, 0xcc, 0x23, 0xc, 0x5, 0x73, 0x0, 0x7, 0xff, 0x88, 0xe1, 0x50, 0x46, 0xe, 0x57, 0x66, 0x24, 0xac, 0x69, 0x6, 0xe5, 0x7b, 0xf4, 0x63, 0x34, 0x0, 0xa8, 0xda, 0xf0, 0x5, 0x37, 0x9, 0xa6, 0x20, 0x10, 0xbd, 0x42, 0xda, 0x16, 0xcf, 0xdc, 0x84, 0xb5, 0xcf, 0x1d, 0xdb, 0xd4, 0x16, 0x34, 0xff, 0x0, 0x97, 0x21, 0x8f, 0x9d, 0xcd, 0x61
	align   2
labels:
	db	    0x1, 0x0, 0x1, 0x1, 0x0, 0x1, 0x1, 0x1, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0
	align   2
setup_data:
	bcf	    CFGS
	bsf	    EEPGD
    
	return
    
load_data:
    	lfsr	0, data_loc	; Load FSR0 with address in RAM	
	movlw	low highword(data)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(data)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(data)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	60		
	movwf 	counter, A	; our counter register
	
	bra	loop
	
load_labels:
	lfsr	0, label_loc	; Load FSR0 with address in RAM	
	movlw	low highword(labels)	; address of data in PM
	movwf	TBLPTRU, A	; load upper bits to TBLPTRU
	movlw	high(labels)	; address of data in PM
	movwf	TBLPTRH, A	; load high byte to TBLPTRH
	movlw	low(labels)	; address of data in PM
	movwf	TBLPTRL, A	; load low byte to TBLPTRL
	movlw	20		
	movwf 	counter, A	; our counter register
	
	bra	loop
loop:
        tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	decfsz	counter, A	; count down to zero
	bra	loop		; keep going until finished
	
	return
