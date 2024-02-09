; Exemplo de um programa no PEPE-16 que conta
; o número de bits a 1 num dado valor

valor		EQU	76H		; Valor cujo número de bits a 1 é para ser contado
mascaraInicial	EQU	01H		; 0000 0001 em binário (máscara inicial)
mascaraFinal	EQU	80H		; 1000 0000 em binário (máscara final)

; Utilização dos registos:
; R0 – auxiliar (valores intermédios)
; R1 – contador de bits a 1
; R2 – máscara

inicio:
	MOV	R1, 0			; Inicializa o contador de bits com zero
	MOV	R2, mascaraInicial	; Inicializa valor da máscara
	MOV	R0, valor			; Cópia do valor
teste:
	AND	R0, R2			; Isola o bit que se quer ver se é 1
	JZ	proximo			; Se o bit for zero, passa à máscara seguinte
	ADD	R1, 1			; O bit é 1, incrementa o valor do contador
proximo:
	MOV	R0, mascaraFinal
	CMP	R2, R0			; Compara com a máscara final
	JZ	fim				; Se forem iguais, já terminou
	SHL	R2, 1			; Desloca bit da máscara para a esquerda
	JMP	teste			; Vai fazer mais um teste com a nova máscara

fim:	JMP	fim				; forma expedita de "terminar"
