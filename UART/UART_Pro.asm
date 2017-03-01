.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x100
SEND_ONE:
	push r16
	ldi r16, 255
SEND_ONE1:
	dec r16
	brne SEND_ONE1
	pop r16
	sbi PORTB, PB0
	ret


.org 0x00
rjmp MAIN

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, 1
	out DDRB, r16

	call SEND_ONE


END:
rjmp END
