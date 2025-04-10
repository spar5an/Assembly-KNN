#include <xc.inc>
    
global  UART_Setup, UART_Transmit_Message, UART_Receive_Input, UART_Receive_Data
    

psect	udata_acs   ; reserve data space in access ram
UART_counter: ds    1	    ; reserve 1 byte for variable UART_counter
receive_counter:    ds	1
    
psect	uart_code,class=CODE
UART_Setup:
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bsf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bsf	    CREN	; enable receive
    bcf	    BRG16	; 8-bit generator only
    movlw   2	; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RC6 pin
					; must set TRISC6 to 1
    return

UART_Transmit_Message:	    ; Message stored at FSR2, length stored in W
    movwf   UART_counter, A
UART_Loop_message:
    movf    POSTINC2, W, A
    call    UART_Transmit_Byte
    decfsz  UART_counter, A
    bra	    UART_Loop_message
    return

UART_Transmit_Byte:	    ; Transmits byte stored in W
    btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
    bra	    UART_Transmit_Byte
    movwf   TXREG1, A
    return

UART_Receive_Input:
    ;designed to recieve 3 bytes and output them at fsr2
    movlw   0x03
    movwf   receive_counter
    
UART_Receive_Input_Loop:
    btfss   RC1IF           ; Wait until a byte is received
    bra     UART_Receive_Input_Loop
    movff   RCREG1, POSTINC2; Read received byte
    bcf     RC1IF           ; Clear receive flag
    decfsz  receive_counter, A  ; Check if 3 bytes received
    bra     UART_Receive_Input_Loop   ; Repeat for next byte
    
    return
    
UART_Receive_Data:
    ;designed to recieve 4 bytes and output them at fsr1
    movlw   0x04
    movwf   receive_counter
    
UART_Receive_Data_Loop:
    btfss   RC1IF           ; Wait until a byte is received
    bra     UART_Receive_Data_Loop
    movff   RCREG1, POSTINC1; Read received byte
    bcf     RC1IF           ; Clear receive flag
    decfsz  receive_counter, A  ; Check if 3 bytes received
    bra     UART_Receive_Data_Loop   ; Repeat for next byte
    
    return





