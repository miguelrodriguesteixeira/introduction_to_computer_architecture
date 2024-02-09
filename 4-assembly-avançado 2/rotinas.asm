; Exemplo de utilização de rotinas

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

	MOV  R0, 7			; argumentos para a rotina			
	MOV  R1, 3
	CALL soma				; soma os operandos
	
	MOV	R0, 4
	MOV	R1, R2			; porque o resultado não está no registo certo
	CALL soma				; soma os operandos
	
	MOV  R3, 3			; vai deslocar 3 bits para a esquerda (soma * 2^3)
	CALL	potencia_2		; desloca R2 para a esquerda

fim:
    JMP  fim				; termina programa

; **********************************************************************
; SOMA - Soma os dois argumentos
; Argumentos:	R0 - primeiro operando
;			R1 - segundo operando
; Retorna:	R2 - resultado
; **********************************************************************
soma:
	ADD	R0, R1			; obtém resultado
	MOV	R2, R0			; copia para registo do resultado
	RET					; regressa

; **********************************************************************
; POTENCIA_2 - Desloca um valor de N bits para a esquerda (valor * 2^N)
; Argumentos:	R2 - valor
;			R3 - Expoente (N: número de bits a deslocar, > 0)
; Retorna:	R2 - resultado (valor deslocado)
; **********************************************************************
potencia_2:
	SHL	R2, 1
	SUB	R3, 1
	JNZ	potencia_2
	RET					; regressa
