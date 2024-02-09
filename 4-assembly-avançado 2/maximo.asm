; Exemplo de rotina que manipula uma tabela

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       0100H
tabela:
	WORD	3
	WORD	7
	WORD	2
	WORD	9
	WORD	6
	WORD	-1        ; terminador
	
maior_valor:
	WORD 0
pilha:
	STACK 10H				; espaço reservado para a pilha 
						; (20H bytes, pois são 10H WORDs)
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
	MOV	R1, tabela		; endereço de base da tabela
	CALL maximo			; obtém em R2 o maior dos elementos
     MOV  [maior_valor], R2	; guarda valor numa variável em memória
fim:
	JMP  fim
     
; **********************************************************************
; MAXIMO - Determina qual o maior valor de uma tabela de valores não negativos,
;		 terminada com um valor negativo
; Argumentos:	R1 - endereço de base da tabela
; Retorna:	R2 - resultado
; **********************************************************************
maximo:
	PUSH R1			; guarda os dois registos que a rotina altera
     PUSH R3
     MOV  R2, 0		; valor inicial do máximo (negativo não pode ser)
loop:
	MOV	R3, [R1]		; próximo elemento da tabela
     ADD  R1, 2		; prepara já o endereço do próximo elemento
	CMP	R3, 0		; verifica se o elemento é o terminador
	JN	sai			; se negativo, termina
	CMP	R3, R2		; verifica o elemento face ao máximo atual
	JLE	loop			; se menor ou igual, mantém o máximo
	MOV	R2, R3		; novo máximo!
	JMP  loop			; continua
sai:
     POP  R3			; repõe registos (por ordem inversa)
     POP  R1
     RET
