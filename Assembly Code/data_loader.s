#include <xc.inc>

    
extrn k, UART_Receive_Data, UART_Transmit_Message, signal
global	setup_data, load_data, first_points_loc, load_first_points_data, banks_filled, high_counter, counter
;this is a temporary solution to load some data in to begin coding the KNN
;20 binary data points with 3 parameters each

PSECT udata_bank0
first_points_loc:   ds	20;this needs to be 4 times K
    
    
psect udata_acs
data_length:	ds  1
first_point_length: ds	1
counter:    ds	1
banks_filled:	ds  1
high_counter:	ds  1

    
psect	data_code, class=CODE
setup_data:
	movlw	2   ;this is the number of banks we aim to use for the data
	movwf	banks_filled
	return
	
load_data:
	lfsr	1,  0x200
	movff	banks_filled, high_counter
	movlw	0xff
	movwf	counter
	

	
load_data_loop:
	call	receive_data
	movlw	0x00
	decf	counter
	decf	counter
	decf	counter
	decf	counter
	subwfb	high_counter
	btfss	STATUS, 2
	bra	load_data_loop
	
	return
	
	
	

		
load_first_points_data:
	lfsr	1, first_points_loc
	movff	k, counter

load_first_points_loop:
	call	receive_data
	decfsz	counter
	bra	load_first_points_loop
    
	return
	
receive_data:
	movlw   0x01
	lfsr    2, signal

	call    UART_Transmit_Message
	call    UART_Receive_Data
	return
	