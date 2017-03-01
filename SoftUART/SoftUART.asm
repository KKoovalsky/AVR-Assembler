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

	ldi r16, 1
	out DDRB, r16


	ldi ZH, high(UARTBYTES<<1)
	ldi ZL, low(UARTBYTES<<1)

	ldi r21, 0b00000010
	ldi r16, 5
SEND:
	lpm r17, Z+
	sbi PORTB, PB0
	call DELAY_104
	ldi r18, 1
	nop
SEND1:
	mov r19, r18
	and r19, r17
	in r19, SREG
	cbr r19, 0b11111101
	eor r19, r21
	lsr r19
	in r20, PORTB
	cbr r20, 1
	or r20, r19
	out PORTB, r20
	call DELAY_104
	lsl r18
	brne SEND1
	ldi r19, 3
WAIT:
	dec r19
	brne WAIT
	nop
	cbi PORTB, PB0
	call DELAY_104
	nop
	nop
	nop
	nop
	nop
	dec r16
	brne SEND

nop
nop
nop
nop
sbi PORTB, PB0

END:
rjmp END

.org 0x100
UARTBYTES:
.db 0x55, 0x71, 0x00, 0xFF, 0x12, 0x00

.org 0x150
DELAY_104:
	push r16
	push r17
	ldi r16, 3
DELAY104_1:
	ldi r17, 88
DELAY104_2:
	dec r17
	brne DELAY104_2
	dec r16
	brne DELAY104_1
	pop r17
	pop r16
	nop
	nop
	ret
