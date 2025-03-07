	#include <xc.inc>

extrn	setup_data, load_data, load_labels
	
psect	code, abs
main:
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

setup:	
	call	setup_data
	
read:
	call	load_data
	call	load_labels
	goto	$
	
	end	main
