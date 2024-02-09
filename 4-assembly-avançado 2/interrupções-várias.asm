; Exemplo de utilização de várias interrupções (precisa do circuito circuito-teste-interrupções.cir)

; O display conta ao ritmo do relógio ligado à interrupção 0
; O botão ligado à interrupção 1 inverte o sentido de contagem
; O botão ligado à interrupção 2 faz reset ao contador

; *********************************************************************************
; * Dados 
; *********************************************************************************
DISPLAYS   EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)

	PLACE	0100H
pilha:
	STACK 10H				; espaço reservado para a pilha 
						; (20H bytes, pois são 10H WORDs)
SP_inicial:				; este é o endereço (120H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11EH (120H-2)

tab:
	WORD	rot0				; tabela de interrupções (endereço de cada rotina de interrupção)
	WORD	rot1				; cada endereço tem de ficar na posição na tabela
	WORD	rot2				; correspondente ao respetivo número de interrupção (0 a 3)
	
; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE	0			; o código tem de começar em 0000H
	MOV	SP, SP_inicial		; inicializa SP
	MOV	BTE, tab			; inicializa BTE
	MOV	R0, 0			; inicializa contador
	MOV	R2, 1			; valor a somar contador (+1 para subir e -1 para descer)
	EI0					; permite interrupção 0
	EI1					; permite interrupção 1
	EI2					; permite interrupção 2
	EI					; permite interrupções (geral)
fim:	
	JMP	fim				; fica à espera

; **********************************************************************
; ROT0 - Rotina que trata da interrupção 0 (evolui contador)
; **********************************************************************
rot0:
	PUSH	R1	
	ADD	R0, R2	     	; evolui contador
	MOV	R1, DISPLAYS		; endereço do periférico
	MOVB	[R1], R0	     	; atualiza display
	POP	R1
	RFE			     	; regressa da interrupção

; **********************************************************************
; ROT1 - Rotina que trata da interrupção 1 (inverte sentido do contador)
; **********************************************************************
rot1:
	NEG	R2				; simétrico do R2 (+1 ou -1)
	RFE			     	; regressa da interrupção

; **********************************************************************
; ROT2 - Rotina que trata da interrupção 2 (reset ao contador)
; **********************************************************************
rot2:
	PUSH	R1	
	MOV	R0, 0			; faz reset ao contador
	MOV	R1, DISPLAYS		; endereço do periférico
	MOVB	[R1], R0	     	; atualiza display
	POP	R1
	RFE			     	; regressa da interrupção
