.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x00
rjmp MAIN

.org 0x16
rjmp USART_RXC_INT

.org 0x18
rjmp USART_UDRE_INT

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, (1<<TXEN)
	out UCSRB, r16

	ldi r16, 0
	out UBRRH, r16
	ldi r16, 51
	out UBRRL, r16
	ldi r16, (1<<URSEL) | (3<<UCSZ0)
	out UCSRC, r16



	ldi r16, 48

LOOP:
	call USART_T
	call DELAY_S
	rjmp LOOP

USART_RXC_INT:

USART_UDRE_INT:

.org 0x200
USART_T:
	sbis UCSRA, UDRE
	rjmp USART_T
	out UDR, r16
	ret


.org 0x11B
DELAY_S:
	push r16
	push r17
	push r18
	ldi r16, 133
DELAY_S_1:
	ldi r17, 179
DELAY_S_2:
	ldi r18, 55
DELAY_S_3:
	dec r18
	brne DELAY_S_3
	dec r17
	brne DELAY_S_2
	dec r16
	brne DELAY_S_1
	pop r18
	pop r17
	pop r16
	ret

.org 0x240
SEGBYTES:
.db 49,50,51,65,52,53,54,66,55,56,57,67,42,48,35,68
