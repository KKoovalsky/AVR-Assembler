.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.dseg
b_uartDataToSend:		; b_ prefix stand for boolean variable.
	.BYTE	1

.cseg

.org 0x00
	rjmp MAIN

.org 0x16
	rjmp USART_RXC_HANDLER

.org 0x18
	rjmp USART_UDRE_HANDLER

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, (1<<TXEN) | (1<<RXEN) | (1<<RXCIE)
	out UCSRB, r16

	ldi r16, 0
	out UBRRH, r16
	ldi r16, 52
	out UBRRL, r16
	ldi r16, (1<<URSEL) | (3<<UCSZ0)
	out UCSRC, r16

	ldi r16, 0
	sts b_uartDataToSend, r16

LOOP:
	rjmp LOOP

USART_RXC_HANDLER:
	push r17
	ldi r17, 1
	sts b_uartDataToSend, r17
	in r16, UDR
	call TO_LOWER
	sbi UCSRB, UDRIE
	pop r17
	reti

USART_UDRE_HANDLER:
	push r17
	lds r17, b_uartDataToSend
	sbrs r17, 0
	rjmp TURN_OFF_USART_TXC
	out UDR, r16
	ldi r17,0 
	sts b_uartDataToSend, r17
USART_TXC_CLEANUP:
	pop r17
	reti
TURN_OFF_USART_TXC:
	cbi UCSRB, UDRIE
	rjmp USART_TXC_CLEANUP

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
