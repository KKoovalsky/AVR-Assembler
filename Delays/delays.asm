.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x100
DELAY_MS:
ldi r17, 8
DELAY_MS1:
ldi r16, 124
DELAY_MS2:
dec r16
nop
brne DELAY_MS2
dec r17
brne DELAY_MS1
ret

.org 0x115
DELAY_100MS:
ldi r18, 30
DELAY_100MS_1:
ldi r17, 222
call DELAY_MS1
dec r18
brne DELAY_100MS_1
ret

.org 0x120
DELAY_S:
ldi r19, 30
DELAY_S_1:
ldi r18, 201
ldi r17, 220
call DELAY_MS2
dec r19
brne DELAY_S_1
nop
nop
ret

.org 0x00
rjmp MAIN

.org 0x30
MAIN:

ldi r16, high(RAMEND)
out SPH, r16
ldi r17, low(RAMEND)
out SPL, r17


call DELAY_MS

END:
rjmp END
