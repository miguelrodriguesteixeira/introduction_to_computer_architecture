; Exemplos de instruções de acesso à memória no PEPE-16 (em word e em byte)
; O PEPE-16 usa endereçamento de byte (todos os bytes têm endereço próprio,
; mas o processador consegue também aceder a dois bytes (word) de uma só vez.

; Só as instruções com [ ] acedem a memória!
; As que não têm é apenas para carregar registos

	; acesso à memória word a word (MOV)
	MOV R0, 0100H   	; endereço da célula de memória a aceder em word
	MOV  R2, 1234H  	; constante de 16 bits (dois bytes)
	MOV  R3, 5678H  	; constante de 16 bits (dois bytes)
	MOV [R0], R2    	; escreve uma word (16 bits) na memória
;	MOV [0100H], R2	; o endereço pode ser indicado diretamente por uma constante

	; acesso à memória byte a byte (MOVB) (o endereço tem de ser um registo)
	MOV R1, 0110H   	; endereço da célula de memória a aceder em byte
	MOVB [R1], R2   	; escreve só um byte (8 bits) na memória (0110H)
	ADD R1, 1       	; endereço 0111H
	MOVB [R1], R3   	; escreve só um byte (8 bits) na memória (0111H)
	
	MOV R1, 0110H   	; repõe endereço 0110H em R1
	MOV R4, [R1]    	; lê uma word (16 bits) da memória (endereço par)
	MOVB R5, [R1]   	; lê só um byte (8 bits) da memória (0110H)
	ADD R1, 1       	; endereço 0111H
	MOVB R6, [R1]   	; lê só um byte (8 bits) da memória (0111H)

fim:	JMP	fim	; forma expedita de "terminar"
