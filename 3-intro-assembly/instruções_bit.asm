; Exemplos de instruções de deslocamento e lógicas no PEPE-16

	MOV	R0, 578FH		; valor a deslocar
	SHR	R0, 8		; desloca 8 bits para a direita (fixo)
	
	; deslocamento "manual" por deslocamentos sucessivos de 1 bit (variável)
	MOV	R1, 578FH		; valor a deslocar
	MOV	R2, 8		; número de bits a deslocar
ciclo:
	SHR	R1, 1		; desloca um bit de cada vez
	SUB	R2, 1		; menos um bit para deslocar
	JNZ	ciclo		; enquanto o contador não chegar a 0, vai deslocando
	
	;deslocamentos como multiplicações por potências de 2
	MOV	R3, 6
	SHL	R3, 3		; multiplica por 8 (2^3)
	SHR	R3, 1		; divide por 2 (2^1)
	
	; manipulação de dados
	MOV	R4, 5AH
	MOV	R5, 7FH
	SHL	R5, 8		; desloca o R5 de 8 bits para a esquerda
	OR	R5, R4		; junta os dois bytes na mesma word

	MOV	R6, 6E8H
	MOV	R7, 0FH		; máscara que permite eliminar (por a 0) todos os bits que não interessam
	AND	R6, R7		; aplica a máscara (ficam só os bits que estão a 1 na máscara)

fim:	JMP	fim			; forma expedita de "terminar"


