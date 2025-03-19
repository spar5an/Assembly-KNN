#include <xc.inc>

extrn	UART_Transmit_Message, UART_Receive_Input, predict_point

global	input_setup, receive_input, test, signal
    
PSECT udata_acs
signal:	ds  1
    
PSECT	io_code, class=CODE
input_setup:
    movlw   0x0a
    movwf   signal
    
    return
    
receive_input:
    ;transmit ready to recieve signal
    movlw   0x01
    lfsr    2, signal
    
    call    UART_Transmit_Message
    lfsr    2, predict_point
    call    UART_Receive_Input
    
    return
    
test:
    movlw   0x01
    lfsr    2, signal
    call    UART_Transmit_Message
    return
    




