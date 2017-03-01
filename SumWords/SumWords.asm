.nolist
.include "m16def.inc"
.list
.listmac
.device ATmega16

.cseg

; Przerwanie RESET
.org 0x0000;
rjmp MAIN

; Główny program
.org 0x30
MAIN:
	; Inicjalizaja stosu
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r17, low(RAMEND)
	out SPL, r17

	; Załadowanie zmiennych
	ldi r16, 0xFA	;	Młodsza część słowa I
	ldi r17, 0xAB	;	Starsza część słowa I
	ldi r18, 0xFE	;	Młodsza część słowa II
	ldi r19, 0xAB	;	Starsza część słowa I
	
	; Dodanie młodszych części słowa
	add r16, r18
	
	; Dodanie starszej części słowa z przeniesieniem z poprzedniej sumy
	adc r17, r19
	
	; Flaga Carry zawiera wynik przeniesienia
	
END:
	rjmp END
