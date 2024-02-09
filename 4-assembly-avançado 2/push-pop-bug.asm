; Exemplo de utilização de rotinas, com guarda de registos (PUSH e POP)

; ATENÇÃO ao bug introduzido na rotina potencia_2! 

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       0100H
pilha:
	STACK 10H				; espaço reservado para a pilha 
;	TABLE 10H				; igual a STACK, mas sem proteção 
						; (20H bytes, pois são 10H words)
SP_inicial:				; este é o endereço (120H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11EH (120H-2)
							
; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE	0			; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; à última da pilha (erro se SP não for inicializado)

	MOV  R0, 4			; argumentos para a rotina			
	MOV  R1, 2
	MOV  R3, 3
	CALL	soma_potencia_2	; (4 + 2) * 2^3

fim:
    JMP  fim				; termina programa

; **********************************************************************
; SOMA_POTENCIA_2 - Soma os dois argumentos e multiplica por 2^N
; Argumentos:	R0 - primeiro operando
;			R1 - segundo operando
;			R3 - expoente (N)
; Retorna:	R2 - resultado
; **********************************************************************
soma_potencia_2:
	; PUSHs e POPs são responsabilidade das rotinas chamadas, não da chamante
	CALL	soma				; soma os dois argumentos
	CALL potencia_2		; soma * 2^N
	RET					; regressa

; **********************************************************************
; SOMA - Soma os dois argumentos
; Argumentos:	R0 - primeiro operando
;			R1 - segundo operando
; Retorna:	R2 - resultado
; **********************************************************************
soma:
	PUSH	R0
	ADD	R0, R1			; obtém resultado
	MOV	R2, R0			; copia para registo do resultado
	POP	R0
	RET					; regressa

; **********************************************************************
; POTENCIA_2 - Desloca um valor de N bits para a esquerda (valor * 2^N)
; Argumentos:	R2 - valor
;			R3 - Expoente (N: número de bits a deslocar, > 0)
; Retorna:	R2 - resultado (valor deslocado)
; **********************************************************************
potencia_2:
	PUSH	R3
ciclo:
	SHL	R2, 1
	SUB	R3, 1
	JNZ	ciclo			; se saltasse para potencia_2, executava o PUSH de novo
;	POP	R3				; BUG !!!!! Alguém se esqueceu de um POP!!!
	RET					; regressa

