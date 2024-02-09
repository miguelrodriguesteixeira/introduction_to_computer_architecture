; Exemplo de utilização de recursividade
; Cuidado com o tamanho da pilha!
; Acaba por esgotar o espaço e dar erro!

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
;	MOV	R1, 6			; quanto maior o valor, mais chamadas recursivas são feitas.
						; Com 6, a pilha reservada já não chega!
	CALL	fatorial			; chama rotina para calcular fatorial (em R2)
fim:
	JMP	fim

;******************************************************
; Descrição:	Calcula o fatorial de um número (n!), usando recursividade
;				n! = n * (n-1)!
; Entradas:	R1 - Parâmetro (valor n)
; Saídas:		R2 - Fatorial de n (n!)
;*******************************************************
fatorial:
	PUSH	R1
	PUSH	R3
	CMP	R1, 1	; n válido?
	JGT	ok		; trata casos n > 1
	MOV	R2, 1	; n! = 1 ( se n <= 1). Termina recursividade
	JMP	sai		; um só ponto de saída!
ok:
	MOV	R3, R1	; inicializa resultado com N
ciclo:
	SUB	R1, 1	; N-1
	CALL fatorial	; (N-1)! em R2 (chamada recursiva). Gasta pilha!
	MUL	R2, R3	; (N-1)! * N 
sai:
	POP	R3
	POP	R1
	RET
