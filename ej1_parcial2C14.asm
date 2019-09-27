/*
 * ej1_parcial2C14.asm
 *
 *  Created: 27/9/2019 17:08:48
 *   Author: chiqu
 */ 

	.DSEG
	.ORG 0x100
ENTRADA:	.byte 1
SALIDA: .byte 1
E: .byte 1
S: .byte 1

	.CSEG
	.ORG 0x040
	LDI R16, LOW(RAMEND) ;inicializzo el stack
	OUT SPL, R16 ;stack low
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16 ;stack high
	LDI R17, 0 ;variable aux para inicializar SALIDA
	STS SALIDA, R17 ;inicialice salida
	OUT DDRB, R17 ;seteo portB como entrada
	LDI R18, 0xFF ;para setear portC como salida
	OUT DDRC, R18 ;seteo portC como salida

LOOP:
	IN R19, PINB
	STS ENTRADA, R19 ;guardo la variable en ENTRADA, que se ubica en la SRAM
	RCALL FILTRO
	LDS R20, SALIDA ;cargo lo de SALIDA, lo q deviuelve filtro
	OUT PORTC, R20
	RJMP LOOP

FILTRO:
	LDS R19, ENTRADA ;cargo ENTRADA en R19, por que se trata de otro ejercicio
	LDS R20, SALIDA ;cargo SALIDA
	LSR R19 ;shifteo para dividir por 2
	LSR R19 ;idem
	LDI R21, 3
	MUL R20, R21
	MOV R20, R0
	LSR R20 ;divido por 2
	LSR R20 ;divido por 2
	ADD R20, R19 ;salida
	STS SALIDA, R20 ;guardo en la memoria SRAM, SALIDA, el resultado
	RET 
