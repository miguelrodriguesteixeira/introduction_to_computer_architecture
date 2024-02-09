; Exemplo de multiplicação por 2^N no PEPE-16 (com deslocamentos)

	N	EQU	8		; expoente de 2^N
	
	MOV	R1, 5DH		; valor a multiplicar
	MOV	R2, 8		; número de bits a deslocar
ciclo:
	SHL	R1, 1		; multplica por 2 (uma unidade do expoente de cada vez)
	SUB	R2, 1		; menos uma unidade do exponente para multiplicar
	JNZ	ciclo		; enquanto o expoente não chegar a 0, vai multiplicando

fim:	JMP	fim			; forma expedita de "terminar"

