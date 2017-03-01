.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x100
DELAY_MS:
	push r16
	push r17
	ldi r16, 166
DELAY_MS_1:
	ldi r17, 7
DELAY_MS_2:
	dec r17
	brne DELAY_MS_2
	dec r16
	brne DELAY_MS_1
	pop r17
	pop r16
	ret

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

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	ldi r16, 0xFF
	out DDRB, r16

LEDFUN:
	ldi r18, 5
LOOP:
	ldi r16, 0xFF
	out PORTB, r16
	ldi r16, 1
LOOP_1:
	mov r17, r16
	neg r17
	dec r17
	out PORTB, r17
	call DELAY_100MS
	lsl r16
	brne LOOP_1
	
	ldi r16, 0xFF
	out PORTB, r16
	call DELAY_100MS
	ldi r16, 0x80
LOOP_2:
	mov r17, r16
	neg r17
	dec r17
	out PORTB, r17
	call DELAY_100MS
	lsr r16
	brne LOOP_2

	dec r18
	brne LOOP
		
	ldi r16, 0
	out PORTB, r16
	
	ldi r19, 5
LOOP2:
	ldi r16, 0b00000111
	ldi r17, 0b11100000
LOOP2_1:
	mov r18, r16
	call DELAY_100MS
	eor r18, r17
	neg r18
	dec r18
	out PORTB, r18
	lsr r16
	lsl r17
	brne LOOP2_1

	call DELAY_100MS
	ldi r17, 0xFF
	out PORTB, r17
	
	ldi r16, 0b01111110
	ldi r17, 0b01111110
LOOP2_2:
	mov r18, r16
	call DELAY_100MS
	and r18, r17
	out PORTB, r18
	lsl r16
	lsr r17
	brbs SREG_H, LOOP2_2

	dec r19
	brne LOOP2

	ldi r16, 0xFF
	out PORTB, r16
	call DELAY_100MS

jmp LEDFUN

END:
rjmp END
