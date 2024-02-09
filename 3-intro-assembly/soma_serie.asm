; Exemplo de um programa no PEPE-16 que soma um inteiro positivo
; com todos os inteiros positivos menores que ele

; Utilização dos registos:
; R0 – soma
; R1 – temp

N	EQU	5		; definição do N

	MOV	R0, 0	; soma <- 0
	MOV	R1, N	; temp <- N
maisUm:	
	CMP	R1, 0	; se (temp <= 0) salta para fim
	JLE	fim		; junta os dois testes
	ADD	R0, R1	; soma <- soma + temp
	SUB	R1, 1	; temp <- temp – 1
	JMP	maisUm	; salta para mais uma iteração
fim:
	JMP	fim		; "termina"
