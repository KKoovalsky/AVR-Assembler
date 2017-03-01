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

	ldi r16, 1
	out DDRC, r16	
	sbi PORTC, PC0

	ldi r16, 0xFF
	out DDRB, r16

	call STORE_SEG
LOOP:
	//call DELAY_100MS
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
	push r22

	ldi r22, 0x12

	ldi r19, 0x0F

	ldi r16, 0xEF

LOAD_SEG1:
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
	and r22, XL
	breq SEQ_FOUND
	call SEND_UART

KEY_NOT_FOUND:
	pop r22
	pop r19
	pop r18
	pop r17
	pop r16
	ret

SEQ_FOUND:
	ldi ZH, high(SEQUENCE<<1)
	ldi ZL, low(SEQUENCE<<1)

	ldi r18, 8
SEQ_FOUND1:
	lpm r17, Z+
	call SEND_UART
	dec r18
	brne SEQ_FOUND1
	jmp KEY_NOT_FOUND



.org 0x180
SEND_UART:
	sbis UCSRA, UDRE
	rjmp SEND_UART
	out UDR, r17
	ret

.org 0x240
SEGBYTES:
.db 49,50,51,65,52,53,54,66,55,56,57,67,42,48,35,68

.org 0x280
SEQUENCE:
.db 0xFE,0x0A,0xE7,0xC8,0xFE,0x0A,0xE8,0xC8,0x31, 0x00

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

.org 0x350
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
