; *********************************************************************************
; * IST-UL
; * Modulo:     lab5-variante.asm
; * Descri��o:  Este � um programa simples, com rotinas que escrevem nos displays
; *             hexadecimais Low (bits 3-0 de POUT-1) e High (bits 7-4 de POUT-1).
; *             Dado que os dois displays s�o independentes, mas partilham o mesmo 
; *             perif�rico, cuja unidade de escrita m�nima � um byte, a forma de 
; *	           escrever apenas um dos nibbles (grupo de 4 bits) � ter uma c�pia do
; *	           seu valor (byte com o valor dos dois displays) em mem�ria, 
; *             modificar apenas o nibble que se quer, e depois escrever esse byte. 
; *             � usual designar esta c�pia em mem�ria por imagem do perif�rico.
; *
; * Nota:  Igual a lab5-registos.asm mas usando uma �nica rotina para escrever nos 
; * 		 dois displays, que invoca outras duas rotinas.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
DISPLAYS    EQU 0A000H		; endere�o do porto dos displays hexadecimais
NIBBLE_3_0  EQU 000FH		; m�scara para isolar os 4 bits de menor peso	
NIBBLE_7_4  EQU 00F0H		; m�scara para isolar os bits 7 a 4	

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espa�o reservado para a pilha 
						; (200H bytes, pois s�o 100H words)
SP_inicial:				; este � o endere�o (1200H) com que o SP deve ser 
						; inicializado. O 1.� end. de retorno ser� 
						; armazenado em 11FEH (1200H-2)
imagem_hexa:
	BYTE	00H				; imagem em mem�ria dos displays hexadecimais 
						; (inicializada a zero, mas podia ser outro valor qualquer).
							
; *********************************************************************************
; * C�digo
; *********************************************************************************
	PLACE	0			; o c�digo tem de come�ar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; � �ltima da pilha

	MOV  R1, 1234H			; inicializa registos com valores (quaisquer)
	MOV  R2, 4567H
	MOV  R3, 89ABH

;	MOV  R0, 7			; argumento para a rotina			
;	CALL hexa_low			; escreve 7 no display Low
;	MOV  R0, 3
;	CALL hexa_high			; escreve 3 no display high

	MOV  R1, 37H
	CALL hexa_display		; substitui os dois CALLs anteriores (agora em coment�rio)

;	MOV  R0, 0AH
;	CALL hexa_low			; escreve A no display low
;	MOV  R0, 0FH
;	CALL hexa_high			; escreve F no display high

	MOV  R1, 0FAH
	CALL hexa_display		; substitui os dois CALLs anteriores (agora em coment�rio)

fim:
    JMP  fim				; termina programa

; *********************************************************************************
;* ROTINAS
; *********************************************************************************

; **********************************************************************
; HEXA_DISPLAY - Rotina que escreve um byte nos dois displays hexadecimais
; Argumentos: R1 - n�mero (entre 0 e FFs) a escrever no displays hexadecimais
;
; **********************************************************************
hexa_display:
	PUSH R0				; guarda registo
	MOV	R0, 0FH			; m�scara
	AND	R0, R1			; elimina bits excepto bits 3 a 0
	CALL hexa_low			; escreve-os no display Low
	MOV  R0, R1			; c�pia para n�o destruir o par�metro
	SHR  R0, 4			; coloca bits 7-4 nos bits de menor peso
	CALL hexa_high			; escreve-os no display High
	POP  R0				; recupera registo
	RET					; regressa

; **********************************************************************
; HEXA_LOW - Rotina que escreve um valor no display hex. Low de POUT-1 (bits 3-0)
; Argumentos: R0 - n�mero (entre 0 e FH) a escrever no display hexadecimal
;
; **********************************************************************
hexa_low:
	PUSH R0				; guarda registos
	PUSH R1
	PUSH R2
	PUSH R3
	MOV  R1, NIBBLE_3_0		; m�scara para isolar os 4 bits de menor peso
	AND  R0, R1			; limita valor de entrada a valores entre 0 e FH
	MOV  R2, imagem_hexa	; endere�o da imagem dos displays hexadecimais	
	MOVB R3, [R2]			; l� imagem dos displays na mem�ria
	MOV  R1, NIBBLE_7_4		; m�scara para isolar os bits 7 a 4 (display High)
	AND  R3, R1			; elimina o valor anterior do display Low
	OR   R3, R0			; junta o novo valor do display Low (bits 3 a 0)
	MOVB [R2], R3			; atualiza imagem dos displays na mem�ria
	MOV  R1, DISPLAYS		; endere�o dos displays hexadecimais
	MOVB [R1], R3			; atualiza displays
	POP  R3				; recupera os valores dos registos (ordem inversa)
	POP  R2
	POP  R1
	POP  R0
	RET					; regressa

; **********************************************************************
; HEXA_HIGH - Rotina que escreve um valor no display hex. High de POUT-1 (bits 7-4)
; Argumentos: R0 - n�mero (entre 0 e FH) a escrever no display hexadecimal
;
; **********************************************************************
hexa_high:
	PUSH R0				; guarda registos
	PUSH R1
	PUSH R2
	PUSH R3
	MOV  R1, NIBBLE_3_0		; m�scara para isolar os 4 bits de menor peso
	AND  R0, R1			; limita valor de entrada a valores entre 0 e FH
	SHL  R0, 4			; desloca valor para ficar j� nos bits 7 a 4
	MOV  R2, imagem_hexa	; endere�o da imagem dos displays hexadecimais	
	MOVB R3, [R2]			; l� imagem dos displays na mem�ria
	MOV  R1, NIBBLE_3_0		; m�scara para isolar os bits 3 a 0 (display Low)
	AND  R3, R1			; elimina o valor anterior do display High
	OR   R3, R0			; junta o novo valor do display High (bits 7 a 4)
	MOVB [R2], R3			; atualiza imagem dos displays na mem�ria
	MOV  R1, DISPLAYS		; endere�o dos displays hexadecimais
	MOVB [R1], R3			; atualiza displays 
	POP  R3				; recupera os valores dos registos (ordem inversa)
	POP  R2
	POP  R1
	POP  R0
	RET					; regressa
