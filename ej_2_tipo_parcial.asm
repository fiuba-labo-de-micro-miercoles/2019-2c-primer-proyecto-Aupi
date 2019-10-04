/*
 * ej_2_tipo_parcial.asm
 *
 *  Created: 28/9/2019 17:41:50
 *   Author: Santiago
 */ 


 
 ;Enunciado: Realizar una rutina que codigique un string ubicado en memoria de codigo. El dato se envia por el puerto serie usando la funcion EnviarCaracter y el argumento s epasa en el R7 del banco 0.
 ;La codificacion es la siguiente: si es un caracter alfabetico se imprime la letra que esta tres posiciones por encima de la origian, (ej: A-->D) si se llega al fin del alfabeto, se empieza por el principio (ej Y --> B) (x-->a)
 ;SI es un numero se codifica sumandole 17 al ASCII del numero (ej '0'=48 --> 48+17=65='A'). Cualquier otro caracter se invierten los nibble del valor ASCII (ej: '<'=60=0x3C-->0xc3=195)

 ;tabla ASCII
 ; A --- 0x65  ---> Z --- 0x90
 ;
	.CSEG

		
	.DEF ASCII_A = R16
	.DEF ASCII_Z = R17
	.DEF ASCII_A_MIN = R18
	.DEF ASCII_Z_MIN = R19
	.DEF ASCII_0 = R20
	.DEF ASCII_9 = R21
	
	.EQU SUMA = 3
	.EQU RESTA = 23
	.EQU LETTER_X = 88
	.EQU LETTER_X_MIN = 120
	.EQU SUMA_NUMERO = 17

	LDI ASCII_A, 65
	LDI ASCII_Z, 90
	LDI ASCII_A_MIN, 97
	LDI ASCII_Z_MIN, 122
	LDI ASCII_0, 48
	LDI ASCII_9, 57
	LDI R24, SUMA
	
	LDI R25, 0xFF
	;.DEF LETRA_A = R16
	.DEF STRING_TERMINATOR = R25
	.DEF CARACTER = R22

	LDI R23, LOW(RAMEND) ;inicializo stack
	OUT SPL, R23
	LDI R23, HIGH(RAMEND)
	OUT SPH, R23 ;STACK INICIALIZADO

	LDI ZL, LOW(2*STRING) ;apunto a la tabla de la ROM
	LDI ZH, HIGH(2*STRING) ;multiplico por 2 pq tiene dos columnas
	
	RCALL CODIFICAR

MAIN:
	RJMP MAIN

CODIFICAR:
LOOP1:
	LPM CARACTER, Z+
	RCALL CODIFICAR_CARACTER 
	CPSE CARACTER, STRING_TERMINATOR ;si CARACTER == EOL saltea la siguiente instruccion
	JMP LOOP1
out_1: ;esta etiqueta es la que permite el funcionamiento del programa
	RET

CODIFICAR_CARACTER:
	CP CARACTER, ASCII_A
	BRSH CHEQUEAR_Z ;se ejecuta si el caracter es mayor a A
	CP ASCII_9, CARACTER
	BRSH CHEQUEAR_0 ;se ejecuta si el caracter es mayor a 9
	RJMP CODIFICAR_NIBBLE
RET_1:
	RET

CHEQUEAR_Z:
	CP ASCII_Z, CARACTER
	BRSH CODIFICAR_LETRA_MAYUS
	CP CARACTER, ASCII_A_MIN
	BRLO CODIFICAR_NIBBLE
	CP ASCII_Z_MIN, CARACTER
	BRSH CODIFICAR_LETRA_MINUS 
	RJMP CODIFICAR_NIBBLE

CHEQUEAR_0:
	CP CARACTER, ASCII_0
	BRSH CODIFICAR_NUMERO
	RJMP CODIFICAR_NIBBLE
	
CODIFICAR_LETRA_MAYUS:
	LDI R23, LETTER_X ;LETRA X
	CP CARACTER, R23
	BRSH LETRA_MAS_X
	ADD CARACTER, R24
	RJMP RET_1

LETRA_MAS_X:
	LDI R23, RESTA ;lo que tengo que restar
	SUB CARACTER, R23
	RJMP RET_1

CODIFICAR_LETRA_MINUS:
	LDI R23, LETTER_X_MIN ;LETRA x
	CP CARACTER, R23
	BRSH LETRA_MAS_x_MIN
	ADD CARACTER, R24
	RJMP RET_1

LETRA_MAS_x_MIN:
	LDI R23, RESTA ;lo que tengo que restar
	SUB CARACTER, R23
	RJMP RET_1

CODIFICAR_NIBBLE:
	SWAP CARACTER
	RJMP RET_1


CODIFICAR_NUMERO:
	LDI R23, SUMA_NUMERO ;lo que tengo que sumar al num
	ADD CARACTER, R23
	RJMP RET_1


STRING: .DB "<123"
