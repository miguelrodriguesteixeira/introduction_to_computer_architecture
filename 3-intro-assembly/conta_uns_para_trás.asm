; Exemplo de um programa no PEPE-16 que conta
; o número de bits a 1 num dado valor com
; máscara a evoluir para 0

valor		EQU	76H		; Valor cujo número de bits a 1 é para ser contado
mascaraInicial EQU	80H		; 1000 0000 em binário (máscara inicial)

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
 	SHR	R2, 1			; Desloca bit da máscara para a direita
	JNZ	teste			; Se for 0 terminou, senão vai fazer novo teste

fim:	JMP	fim				; forma expedita de "terminar"
