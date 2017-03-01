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

	ldi r16, (1<<TXEN)
	out UCSRB, r16

	ldi r16, 0
	out UBRRH, r16
	ldi r16, 8
	out UBRRL, r16
	ldi r16, (1<<URSEL) | (3<<UCSZ0)
	out UCSRC, r16

	ldi XH, high(SRAM_START)
	
	ldi r16, 0xF0
	out DDRA, r16

	ldi r16, 0x0F
	out PORTA, r16

LOOP:
	call GET_SEQ_ON_KEY

	rjmp LOOP

FORWARD:
.db 0xFE,0x0A,0xE7,0xC8,0xFE,0x0A,0xE8,0xC8

LEFT:
.db 0xFE,0x0A,0xE7,0x00,0xFE,0x0A,0xE8,0xC8

RIGHT:
.db 0xFE,0x0A,0xE7,0xC8,0xFE,0x0A,0xE8,0x00

DOWN:
.db 0xFE,0x0A,0xE7,0x08,0xFE,0x0A,0xE8,0x08

KEYMASK:
.db 0b00010010,0b00100001,0b00100100,0b01000010


.org 0x100
GET_SEQ_ON_KEY:
	push r16
	push r17
	push r18
	push r19

	ldi r19, 0x0F
	ldi r16, 0xEF

GET_SEQ_ON_KEY1:
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
	brcs GET_SEQ_ON_KEY1
	rjmp KEY_NOT_FOUND
KEY_FOUND:
	
	ldi r16, 0
	ldi r17, 8
	ldi r18, 32

	ldi ZH, high(KEYMASK<<1)
	ldi ZL, low(KEYMASK<<1)

SEARCH_SEQ:
	lpm r19, Z+
	and r19, XL
	breq SEQ_FOUND
	add r16, r17
	mov r19, r16
	sub r19, r18
	brne SEARCH_SEQ
	rjmp SEQ_NOT_FOUND

SEQ_FOUND:
	ldi ZH, high(FORWARD<<1)
	ldi ZL, low(FORWARD<<1)

	ldi r17, 0
	
	add ZL, r16
	adc ZH, r17

	ldi r16, 8
SEQ_FOUND1:
	lpm r17, Z+
	call SEND_UART
	dec r16
	brne SEQ_FOUND1
	
GET_SEQ_CLEANUP:
SEQ_NOT_FOUND:
KEY_NOT_FOUND:
	pop r19
	pop r18
	pop r17
	pop r16
	ret

.org 0x180
SEND_UART:
	sbis UCSRA, UDRE
	rjmp SEND_UART
	out UDR, r17
	ret
