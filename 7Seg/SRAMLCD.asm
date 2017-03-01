.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.equ SEG_0 = 0b11000000
.equ SEG_1 = 0b11111001
.equ SEG_2 = 0b10100100   
.equ SEG_3 = 0b10110000
.equ SEG_4 = 0b10011001
.equ SEG_5 = 0b10010010
.equ SEG_6 = 0b10000010
.equ SEG_7 = 0b11111000
.equ SEG_8 = 0b10000000
.equ SEG_9 = 0b10010000
.equ SEG_A = 0b10001000
.equ SEG_B = 0b10000011
.equ SEG_C = 0b11000110
.equ SEG_D = 0b10100001
.equ SEG_E = 0b10000110
.equ SEG_F = 0b10001110
.equ SEG_H = 0b10001001
.equ SEG_L = 0b11000111
.equ SEG_P = 0b10001100

.cseg

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

	call STORE_SEG

LOOP:
	call LOAD_SEG
	rjmp LOOP

END:
rjmp END


.org 0x100
STORE_SEG:
	push r16
	ldi r16, SEG_0
	sts 0x0060, r16
	ldi r16, SEG_1
	sts 0x0061, r16
	ldi r16, SEG_2
	sts 0x0062, r16
	ldi r16, SEG_3
	sts 0x0063, r16
	ldi r16, SEG_4
	sts 0x0064, r16
	ldi r16, SEG_5
	sts 0x0065, r16
	ldi r16, SEG_6
	sts 0x0066, r16
	ldi r16, SEG_7
	sts 0x0067, r16
	ldi r16, SEG_8
	sts 0x0068, r16
	ldi r16, SEG_9
	sts 0x0069, r16
	ldi r16, SEG_A
	sts 0x006A, r16
	ldi r16, SEG_B
	sts 0x006B, r16
	ldi r16, SEG_C
	sts 0x006C, r16
	ldi r16, SEG_D
	sts 0x006D, r16
	ldi r16, SEG_E
	sts 0x006E, r16
	ldi r16, SEG_F
	sts 0x006F, r16
	pop r16
	ret

.org 0x180
LOAD_SEG:
	push r16
	lds r16, 0x0060
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0061
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0062
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0063
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0064
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0065
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0066
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0067
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0068
	out PORTB, r16
	call DELAY_S
	lds r16, 0x0069
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006A
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006B
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006C
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006D
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006E
	out PORTB, r16
	call DELAY_S
	lds r16, 0x006F
	out PORTB, r16
	call DELAY_S
	pop r16
	ret

.org 0x220
SEGBYTES:
.db SEG_0,SEG_1,SEG_2,SEG_3,SEG_4,SEG_5,SEG_6,SEG_7,SEG_8,SEG_9,SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F


.org 0x140
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
