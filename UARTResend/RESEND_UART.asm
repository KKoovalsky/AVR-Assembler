.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x00
	rjmp MAIN

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, (1<<TXEN) | (1<<RXEN) | (0<<UCSZ2)
	out UCSRB, r16

	ldi r16, 0
	out UBRRH, r16
	ldi r16, 52
	out UBRRL, r16
	ldi r16, (1<<URSEL) | (3<<UCSZ0)
	out UCSRC, r16

	
LOOP:
	call RCV_UART

	call TO_LOWER

	call SEND_UART

	rjmp LOOP

.org 0x180
SEND_UART:
	sbis UCSRA, UDRE
	rjmp SEND_UART
	out UDR, r16
	ret

RCV_UART:
	sbis UCSRA, RXC
	rjmp RCV_UART
	in r16, UDR
	ret

TO_LOWER:
	push r18
	push r17
	push r19	

	ldi r18, 0x40					;Lower bound - ['A' - 1] character
	ldi r17, 0x5A					;Upper bound - ['Z'] character

	sub r18, r16					;Check if character is inside bounds
	brbc 4, NOT_UPPER

	sub r17, r16
	brbs 4, NOT_UPPER

	ldi r19, 32						;32 - difference between lower and upper character
	add r16, r19

NOT_UPPER:
	pop r19
	pop r17
	pop r18	
	ret
