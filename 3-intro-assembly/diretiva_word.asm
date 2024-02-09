; Exemplo de utilização da diretiva WORD no PEPE-16

		PLACE	0100H	; início dos endereços
OLA		EQU	4			; constante definida com o valor 4
VAR1:	WORD	10			; reserva uma palavra no endereço 0100H
VAR2:	WORD	OLA 			; reserva uma palavra no endereço 0102H
						; ver valores na memória
		PLACE	0000H
inicio:
		MOV	R1, OLA	; R1 <- 4 (isto é um dado)
		MOV	R2, VAR2	; R2 <- 0102H (isto é um endereço)
                         ; isto NÃO acede à memória!

; agora sim, vamos aceder à memória
		MOV	R3, [R2]	; R3 <- M[VAR2], ou 
                         ; R3 <- M[0102H]
                         ; R3 fica com 4 (valor do OLA)
		MOV	R4, 5AH
		MOV	[R2], R4	; M[VAR2] <- 5AH, ou 
                         ; M[0102H] <- 5AH
fim:      JMP  fim