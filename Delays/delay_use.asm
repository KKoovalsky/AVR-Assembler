.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

.org 0x100
DELAY_MS:
push r16
ldi r18, 10
DELAY_MS1:
ldi r17, 255
DELAY_MS2:
ldi r16, 255
DELAY_MS3:
dec r16
brne DELAY_MS3
dec r17
brne DELAY_MS2
dec r18
brne DELAY_MS1
pop r16
ret

.org 0x120
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

.org 0x150
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

ldi r16, 0xFF
out DDRB, r16
ldi r16,1
LOOP:
mov r20, r16
neg r20
out PORTB, r20
lsl r16
call DELAY_MS
rjmp LOOP
out PORTB, r16
call DELAY_MS
rjmp LOOP

END:
rjmp END
