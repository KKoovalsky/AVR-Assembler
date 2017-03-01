.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.equ LIS35_ERROR = 1
.equ LIS35_OK = 0
.equ LIS35_WRITE = 0
.equ LIS35_READ = 0x80
.equ LIS35_ADDR_NO_INC = 0
.equ LIS35_ADDR_INC = 0x40

.equ LIS35_REG_CR2 = 0x21
.equ LIS35_REG_CR2_BOOT = 0x40

.equ LIS35_REG_OUTX = 0x29
.equ LIS35_REG_OUTY = 0x2B
.equ LIS35_REG_OUTZ = 0x2D

.equ LIS35_REG_CR1 = 0x20
.equ LIS35_REG_CR1_XEN = 0x1
.equ LIS35_REG_CR1_YEN = 0x2
.equ LIS35_REG_CR1_ZEN = 0x4
.equ LIS35_REG_CR1_DR_400HZ = 0x80
.equ LIS35_REG_CR1_ACTIVE = 0x40
.equ LIS35_REG_CR1_FULL_SCALE = 0x20

.equ LIS35_CR3 = 0x22
.equ LIS35_CR3_IHL = 0x80
.equ LIS35_CR3_CLICK_INT = 0x7
.equ LIS35_CR3_FF1_INT = 0x1


.equ LIS35_FF_WU_CFG_1 = 0x30
.equ LIS35_FF_WU_SRC_1 = 0x31
.equ LIS35_FF_WU_THS_1 = 0x32
.equ LIS35_FF_WU_DURATION_1 = 0x33


.equ LIS35_CLICK_CFG = 0x38
.equ LIS35_CLICK_THSY_X = 0x3b
.equ LIS35_CLICK_THSZ = 0x3c
.equ LIS35_CLICK_TIME_LIMIT = 0x3D


.equ LIS35_STATUS_REG = 0x27

.cseg

.org 0x00
rjmp MAIN

.org 0x30
MAIN:
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

USART_INIT:
	ldi r16, (1<<TXEN) | (1<<RXEN) | (0<<UCSZ2)
	out UCSRB, r16

	ldi r16, 0
	out UBRRH, r16
	ldi r16, 50
	out UBRRL, r16
	ldi r16, (1<<URSEL) | (3<<UCSZ0)
	out UCSRC, r16

SPI_INIT:
	ldi r16, (1<<PB5) | (1<<PB7)
	out DDRB, r16

	ldi r16, (1<<SPE) | (1<<MSTR) | (1<<SPR0)
	out SPCR, r16

	call LIS_REBOOT_MEM
	
	ldi r17, 'K'
	call SEND_UART
	 	
	; Power up
	ldi r16, LIS35_REG_CR1
	ldi r17, LIS35_REG_CR1_XEN | LIS35_REG_CR1_YEN | LIS35_REG_CR1_ZEN | LIS35_REG_CR1_ACTIVE
	call LIS_WR_REG

	mov r18, r17
	call LIS_RD_REG
	
	sub r17, r18
	brne ERROR
	
	; Configure click interrupt (enable all sigle clicks)
	ldi r16, LIS35_CLICK_CFG
	ldi r17, 0x1
	call LIS_WR_REG

	ldi r16, LIS35_CLICK_THSY_X
	ldi r17, 0x77
	call LIS_WR_REG

	ldi r16, LIS35_CLICK_THSZ
	ldi r17, 0x7
	call LIS_WR_REG

	ldi r16, LIS35_CLICK_TIME_LIMIT
	ldi r17, 0xFF
	call LIS_WR_REG

LOOP:
	call LIS_GET_POS
	call SEND_UART
	rjmp LOOP

ERROR:
	ldi r17, '!'
	call SEND_UART
	call DELAY_S
	rjmp ERROR



SPI_MASTER_TR:
	out SPDR, r16
WAIT_SPI_TR:
	sbis SPSR, SPIF
	rjmp WAIT_SPI_TR
	ret



SPI_MASTER_RCV:
	push r16
	ldi r16, 0xFF
	out SPDR, r16
	sbis SPSR, SPIF
	rjmp SPI_MASTER_RCV
	in r17, SPDR
	pop r16
	ret		



SEND_UART:
	sbis UCSRA, UDRE
	rjmp SEND_UART
	out UDR, r17
	ret



RCV_UART:
	sbis UCSRA, RXC
	rjmp RCV_UART
	in r16, UDR
	ret

LIS_WR_REG:
	push r18
	ldi r18, LIS35_WRITE|LIS35_ADDR_NO_INC
	or r16, r18
	cbi PORTB, PB4
	call SPI_MASTER_TR
	mov r16, r17
	call SPI_MASTER_TR
	sbi PORTB, PB4
	pop r18
	ret

LIS_RD_REG:
	push r18
	ldi r18, LIS35_READ|LIS35_ADDR_NO_INC
	or r16, r18
	cbi PORTB, PB4
	call SPI_MASTER_TR
	call SPI_MASTER_RCV
	sbi PORTB, PB4
	pop r18
	ret


LIS_REBOOT_MEM:
	ldi r16, LIS35_REG_CR2
	ldi r17, LIS35_REG_CR2_BOOT
	call LIS_WR_REG
	ret

LIS_GET_POS:
	cbi PORTB, PB4	
	ldi r16, LIS35_READ|LIS35_ADDR_INC|LIS35_REG_OUTX
	call SPI_MASTER_TR
	call SPI_MASTER_RCV
	mov r18, r17
	call SPI_MASTER_RCV
	mov r19, r17
	call SPI_MASTER_RCV
	mov r20, r17
	call SPI_MASTER_RCV
	mov r21, r17
	call SPI_MASTER_RCV
	mov r22, r17
	call SPI_MASTER_RCV
	mov r23, r17
	sbi PORTB, PB4
	ret

SEND_POS_UART:
	mov r17, r18
	call SEND_UART
	mov r17, r19
	call SEND_UART
	mov r17, r20
	call SEND_UART
	mov r17, r21
	call SEND_UART
	mov r17, r22
	call SEND_UART
	mov r17, r23
	call SEND_UART
	ldi r17, ' '
	call SEND_UART
	call DELAY_S
	ret

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
