; Outro exemplo de rotina (fatorial com um ciclo)

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       0100H
pilha:
	STACK 10H				; espaço reservado para a pilha 
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
	MOV	R1, 4			; argumento
	CALL	fatorial			; chama rotina para calcular fatorial (em R2)
fim:
	JMP	fim

;******************************************************
; Descrição:	Calcula o fatorial de um número (n!), usando um ciclo
;				n! = n * (n-1) * (n-2) * ... * 2 * 1
; Entradas:	R1 - Parâmetro (valor n)
; Saídas:	  	R2 - Fatorial de n (n!)
;*******************************************************
fatorial:
	PUSH	R1
	CMP	R1, 1	; n válido?
	JGT	ok		; trata casos n > 1
	MOV	R2, 1	; n! = 1 ( se n <= 1)
	JMP	sai		; um só ponto de saída!
ok:
	MOV	R2, 1	; inicializa resultado com 1 (elemento neutro)
ciclo:
	MUL	R2, R1	; resultado = resultado * n-1
	SUB	R1, 1	; n = n - 1
	JGT	ciclo	; se R1 > 1, vai acumulando
sai:
	POP	R1
	RET
