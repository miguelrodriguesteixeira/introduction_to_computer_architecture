; Exemplos de bits de estado (flags) no PEPE-16

	MOV	R0, 7000H
	MOV	R1, 6000H
	ADD	R0, R1		; soma os dois valores positivos,
					; mas o resultado é negativo com overflow (V, N <- 1)
	
	MOV	R2, 0B000H	; negativo
	MOV	R3, 7000H		; positivo
	ADD	R2, R3		; somar negativo com positivo não pode dar overflow,
					; mas a soma > 10000H, logo C <- 1 e R2 <- 2000H
	
	; MOVs não afetam as flags. Apenas instruções aritméticas, lógicas e de deslocamento
	; Os saltos condicionais saltam ou não, dependendo do valor das flags relevantes
	MOV	R4, 6
ciclo:
	SUB	R4, 1		; faz isto 6 vezes, até a flag Z ficar ativa (R4 dar 0)
	JNZ	ciclo
	
	MOV	R5, 0
mais:
	ADD	R5, 1		; faz isto 6 vezes também, mas precisa do CMP
	CMP	R5, 6		; faz R5 - 6, mas afeta apenas as flags (a constante
					; só pode ser entre -8 e +7, ou então usa-se um registo)
	JNZ	mais
	
	MOV	R6, 578FH
proximo:
	SHR	R6, 1		; desloca de um bit para a direita
	JNZ	proximo		; continua até R6 ser 0

fim:	JMP	fim	; forma expedita de "terminar"
