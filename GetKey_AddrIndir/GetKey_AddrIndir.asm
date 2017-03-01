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

	ldi XH, 0

	ldi r16, 0xFF
	out DDRB, r16

	call STORE_SEG
LOOP:
	call LOAD_SEG
	rjmp LOOP

.org 0x100
STORE_SEG:
	push r16
	ldi ZH, high(SEGBYTES<<1)
	ldi ZL, low(SEGBYTES<<1)

	ldi XL, 0xFF
	clc
STORE_SEG1:
	lpm r16, Z+
	st X, r16
	rol XL
	brcs STORE_SEG1

	pop r16
	ret

.org 0x140
LOAD_SEG:
	push r16
	in XL, PORTA
	ld r16, X
	out PORTB, r16	
	pop r16
	ret

.org 0x220
SEGBYTES:
.db SEG_0,SEG_1,SEG_2,SEG_3,SEG_4,SEG_5,SEG_6,SEG_7,SEG_8,SEG_9,SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F
