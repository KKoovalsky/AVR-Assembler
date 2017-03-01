.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.macro ADD_M
ldi r16, 100
ldi r17, 20
add r16, r17
.endmacro

.macro ADD_ARG_M
ldi r16, @0
ldi r17, @1
add r16, r17
.endmacro

.macro ADD_ARG_REG_M
ldi @2, @0
ldi @3, @1
add @2, @3
.endmacro

.cseg

.org 0x0100
ADD_P:
ldi r16, 100
ldi r17, 20
add r16, r17
ret

.org 0x104
ADD_ARG_P:
add r16, r17
ret

.org 0x106
DELAY_1:
nop
nop
nop
nop
ret

.org 0x10B
DELAY_2:
inc r16
brne DELAY_2
ret

.org 0x10E
DELAY_3:
inc r16
breq END_DEL
rjmp DELAY_3
END_DEL:
ret

.org 0x112
DELAY_4:
inc r16 ; Could use DEC
brne DELAY_4
inc r17
brne DELAY_4
ret

.org 0x0117
DELAY_5:
dec r16 ; Could use DEC
brne DELAY_5
dec r17
brne DELAY_5
dec r18
brne DELAY_5
ret

.org 0x11E
DELAY_6:
ldi r16, 0xFF
ldi r17, 0xFF
ldi r18, 0x20
dec r16 ; Could use DEC
brne DELAY_6
dec r17
brne DELAY_6
dec r18
brne DELAY_6
ret

.org 0x0000
rjmp MAIN
.org 0x30
MAIN:
ldi r16, high(RAMEND)
out SPH, r16
ldi r17, low(RAMEND)
out SPL, r17

ADD_ARG_M 10,12
ADD_ARG_REG_M 100,20,r16,r17
call ADD_P
call ADD_P
call ADD_P

ldi r16, 100
ldi r17, 20
call ADD_ARG_P

call DELAY_1

call DELAY_3

call DELAY_2

call DELAY_4

call DELAY_5

call DELAY_6

END:
rjmp END
