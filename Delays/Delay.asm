.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x100
DELAY_MS:
ldi r18, 132
DELAY_MS1:
ldi r17, 10
DELAY_MS2:
mov r16, r18
DELAY_MS3:
dec r16
brne DELAY_MS3
dec r17
brne DELAY_MS2
nop
ret

.org 0x109
DELAY_100MS:
ldi r19, 30
DELAY_100MS_1:
ldi r18, 19
ldi r17, 222
call DELAY_MS2
dec r19
brne DELAY_100MS_1
nop
nop
ret

.org 0x113
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

call DELAY_100MS

call DELAY_S

END:
rjmp END
