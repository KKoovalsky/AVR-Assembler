.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x10B
DELAY_100MS:
	push r16
	push r17
	push r18
	ldi r16, 162
DELAY_100MS_1:
	ldi r17, 137
DELAY_100MS_2:
	ldi r18, 5
DELAY_100MS_3:
	dec r18
	brne DELAY_100MS_3
	dec r17
	brne DELAY_100MS_2
	dec r16
	brne DELAY_100MS_1
	pop r18
	pop r17
	pop r16
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

.org 0x00
rjmp MAIN

.org 0x100
DELAY_104:
	push r16
	push r17
	ldi r16, 2
DELAY104_1:
	ldi r17, 135
DELAY104_2:
	dec r17
	brne DELAY104_2
	dec r16
	brne DELAY104_1
	pop r17
	pop r16
	ret

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, 1
	out DDRB, r16

LOOP:

	call DELAY_100MS

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	sbi PORTB, PB0

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	sbi PORTB, PB0

	call DELAY_104

	sbi PORTB, PB0

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	cbi PORTB, PB0

	call DELAY_104

	sbi PORTB, PB0

	JMP LOOP

END:
rjmp END
