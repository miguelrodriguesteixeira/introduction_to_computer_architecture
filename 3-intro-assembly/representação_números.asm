; Exemplos de valores no PEPE-16 (complemento para 2)

	MOV	R0, 25H		; coloca uma constante de um byte no R0 (positiva)
	MOV	R1, 1234H		; coloca uma constante de dois bytes no R1 (positiva)
	MOV	R2, 256		; (100H) o PEPE-16 converte decimais para hexadecimais
	MOV	R3, 7FFFH		; valor mais positivo com 16 bits (32767)
	MOV	R4, 0
	SUB	R4, 1		; dá -1 (todos os bits a 1, FFFFH)
	SUB	R4, 1		; -2 (FFFEH)
	SUB	R4, 1		; -3 (FFFDH)
	; as constantes que começam por uma letra (positivas ou negativas) 
	; têm de ter um 0 antes
	; (para se distinguirem dos labels e constantes com nome)
	; (mas isto é só no assembly, nos valores matemáticos não se usa o 0 antes)
	; nas constantes negativas tem sempre de se indicar os 16 bits
	MOV	R5, 0FFFCH	; -4
	MOV	R6, 0FFF0H	; -16
	MOV	R7, 9000H		; -28672 (negativo). Bit de maior peso a 1
	MOV	R8, 8000H		; valor mais negativo com 16 bits (-32768)
	MOV	R9, 0FFH		; 255 (positivo) 
	MOV	R10, 0FFFH	; 4095 (positivo)
	MOV	R11, 0FF01H	; -255 (negativo)
	
fim:	JMP	fim	; forma expedita de "terminar"
