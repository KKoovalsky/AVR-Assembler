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

	ldi XH, high(SRAM_START)
	
	ldi r16, 1
	out DDRC, r16	
	sbi PORTC, PC0

	ldi r16, 0xFF
	out DDRB, r16

	call STORE_SEG
LOOP:
	call DELAY_100MS
	call LOAD_SEG

	rjmp LOOP


.org 0x100
STORE_SEG:
	push r16
	push r17
	push r18

	ldi ZH, high(SEGBYTES<<1)
	ldi ZL, low(SEGBYTES<<1)

	ldi r16, 0xEF

STORE_SEG1:
	ldi r17, 0xFE
	clh
	sec
STORE_SEG2:
	mov XL, r16
	and XL, r17
	lpm r18, Z+
	st X, r18
	sec
	rol r17
	brhs STORE_SEG2
	sec
	rol r16
	brcs STORE_SEG1

	pop r18
	pop r17
	pop r16
	ret


.org 0x140
LOAD_SEG:
	push r16
	push r17
	push r18
	push r19

	ldi r19, 0x0F

	ldi r16, 0xEF

LOAD_SEG1:
	mov r17, r16
	neg r17
	dec r17
	out DDRA, r17
	out PORTA, r16

	nop
	nop
	nop
	nop	

	in XL, PINA
	out PORTB, XL
	mov r18, XL
	cbr r18, 0b11110000
	eor r18, r19
	brne KEY_FOUND

	sec
	rol r16
	brcs LOAD_SEG1
	rjmp KEY_NOT_FOUND
KEY_FOUND:
	
	ld r17, X
	out PORTB, r17
	call SEND_UART

KEY_NOT_FOUND:
	pop r19
	pop r18
	pop r17
	pop r16
	ret

.org 0x180
SEND_UART:
	push r18
	push r19
	push r21
	ldi r21, 0b00000010
	cbi PORTC, PC0
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
	in r20, PORTC
	cbr r20, 1
	or r20, r19
	out PORTC, r20
	call DELAY_104
	lsl r18
	brne SEND1
	ldi r19, 3
WAIT:
	dec r19
	brne WAIT
	nop
	sbi PORTC, PC0
	call DELAY_104
	pop r21
	pop r19
	pop r18
	ret

.org 0x240
SEGBYTES:
.db 49,50,51,65,52,53,54,66,55,56,57,67,42,48,35,68

.org 0x260
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

.org 0x300
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
