; Exemplo de um programa no PEPE-16 que soma N WORDs consecutivas,
; usando um endereço que aponta para o próximo elemento

	PLACE	0100H
size	EQU	7		     ; número de elementos na lista
lista:
	WORD	12			; valores da lista
	WORD	5
	WORD	-3
	WORD	4
	WORD	2
	WORD	-1
	WORD	8
          
soma:
     WORD 0			; para armazenar o resultado

	PLACE	0
inicio:
	MOV	R1, lista	     ; primeiro elemento da lista
	MOV	R4, size	     ; tamanho da lista
     MOV  R2, 0          ; inicializa soma
loop:
	MOV	R3, [R1]		; próximo elemento da lista
	ADD	R2, R3	     ; acumula elemento na soma
	ADD	R1, 2	     ; índice para próximo elemento (+2)
	SUB	R4, 1	     ; menos um elemento para tratar
	JNZ	loop
	MOV	[soma], R2	; coloca em memória o valor da soma
fim:
	JMP	fim
