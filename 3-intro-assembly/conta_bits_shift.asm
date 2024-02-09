; Exemplo de um programa no PEPE-16 que conta
; o número de bits a 1 num dado valor com
; deslocamentos, flag C e ADDC (add with carry)

valor	EQU	6AC5H	; valor cujos bits a 1 vão ser contados

inicio:	MOV	R1, valor	; inicializa registo com o valor a analisar
		MOV	R2, 0	; inicializa contador de número de bits=1
maisUm:
		CMP	R1, 0	; isto é só para atualizar os bits de estado
		JZ	fim		; se o valor já é zero, não há mais bits 
					; a 1 para contar
		SHR	R1, 1	; retira o bit de menor peso do valor e
					; coloca-o no bit C (afinal não se perde logo)
		MOV	R3, 0	; ADDC não suporta constantes
		ADDC	R2, R3	; soma mais 1 ao contador, se esse bit=1 
		JMP	maisUm	; vai analisar o próximo bit
		
fim:		JMP	fim		; acabou. Em R2 está o número de bits=1
