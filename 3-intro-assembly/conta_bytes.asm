; Exemplo de um programa no PEPE-16 que conta o número
; de bytes numa sequência até atingir um terminador

terminador	EQU	0FFH	; pode ser outro valor qualquer,
					; desde que não seja um byte da sequência

	PLACE 0100h
	; hexa, string, decimal, binário (ver bytes na memória)
st:	BYTE	12h, "ola meu", 45, 101b, terminador

	PLACE	0
	MOV	R1, st		; base da sequência de bytes
	MOV	R3, terminador
	MOV	R5, 0		; contador
le_prox_byte:
	MOVB	R2, [R1]		; MOVB: lê um byte (não afeta as flags)
	CMP	R2, R3		; terminador fora de -8..+7
					; (tem de estar num registo)
	JZ	fim
	ADD	R5, 1		; mais um byte detetado
	ADD	R1, 1		; endereço do próximo byte
	JMP	le_prox_byte
fim:
	JMP	fim