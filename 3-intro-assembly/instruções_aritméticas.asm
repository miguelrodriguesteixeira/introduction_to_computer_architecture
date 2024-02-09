; Exemplos de instruções aritméticas no PEPE-16

	MOV	R0, 8		; multiplicando
	MOV	R1, 7		; multiplicador
	MUL	R0, R1		; multiplica os dois (resultado em R0)
	
	; multiplicação "manual" por somas sucessivas
	MOV	R2, 8		; multiplicando
	MOV	R3, 7		; multiplicador
	MOV	R4, 0		; inicializa resultado final		
ciclo:
	ADD	R4, R2		; soma mais uma vez o multiplicando
	SUB	R3, 1		; menos uma vez para somar
;	CMP	R3, 0		; não é preciso. O SUB já afeta as flags
	JNZ	ciclo		; enquanto o multiplicador não chegar a 0, vai somando
	
fim:	JMP	fim	; forma expedita de "terminar"
