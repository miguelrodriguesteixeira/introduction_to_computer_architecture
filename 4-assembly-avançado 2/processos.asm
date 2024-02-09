; Exemplo de utilização de processos (precisa de um circuito com teclado e displays)
;
; Os displays contam, com uma temporização determinada por um ciclo de atraso.
; Há dois processos:
;	- programa principal (que também é um processo), que faz a contagem e display do valor
;	- inversor, que deteta uma tecla premida na linha 4 do teclado e inverte o sentido de contagem
;
; Note-se a declaração (com PROCESS) e criação (com CALL) do processo inversor.
; Note-se também que cada processo tem à sua disposição todos os registos (R0 a R11),
; sem perigo de interferência (cada processo tem a sua própria cópia dos registos)
;
; *********************************************************************************
; * Dados 
; *********************************************************************************
DISPLAYS	EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)
ATRASO	EQU 1000H			; atraso para tornar a contagem mais lenta

	PLACE	2000H
pilha:
	STACK 100H			; espaço reservado para a pilha do programa principal
SP_inicial:				; valor inicial para o SP do programa principal

delta_contador:
	WORD	1				; valor a somar contador (+1 para subir e -1 para descer)
						; NÃO pode estar num registo (processos não partilham registos!)

; *********************************************************************************
; * Processo do programa principal (também é um processo!)
; *********************************************************************************
	PLACE	0			; o código tem de começar em 0000H
	MOV	SP, SP_inicial		; inicializa SP do programa principal
	MOV	R2, 1			; valor a somar contador (+1 para subir e -1 para descer)
	MOV	[delta_contador], R2; NÃO pode estar num registo (processos não partilham registos!)
	
	CALL	inversor			; cria processo inversor (não chama a rotina!)

	MOV	R0, 0			; inicializa contador
evolui:
	YIELD				; sem isto, temos um ciclo bloqueante
	MOV	R2, [delta_contador]; NÃO pode estar num registo (processos não partilham registos!)
	ADD	R0, R2	     	; evolui contador
	MOV	R1, DISPLAYS		; endereço do periférico
	MOVB	[R1], R0	     	; atualiza display
	MOV	R3, ATRASO
atraso:					; ciclo para tornar a contagem mais lenta
	SUB	R3, 1		; É um ciclo lento, mas não bloqueante
	JNZ	atraso			; Pode ter YIELD, ou não
	JMP	evolui			; outra vez. Processo nunca termina


; **********************************************************************
; INVERSOR - Processo que inverte a evolução do contador, pelo teclado
;		   Basta carregar numa tecla da última linha para inverter o sentido de contagem
;		   ATENÇÃO: Devido ao ciclo de atraso no programa principal,
;		   um simples toque rápido no teclado pode passar despercebido ao inversor!
;
;		   Este processo tem dois YIELDs porque tem dois ciclos potencialmente bloqueantes
; **********************************************************************
TEC_LIN    EQU 0C000H		; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H		; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 8			; linha a testar (4ª linha, 1000b)
MASCARA    EQU 0FH			; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

	STACK 100H			; espaço reservado para a pilha do processo inversor
SP_inversor:				; valor inicial para o SP do processo inversor

PROCESS SP_inversor			; declaração do processo
inversor:
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:				; neste ciclo espera-se até uma tecla ser premida
	YIELD				; sem YIELD, o ciclo é bloqueante
	MOV  R1, LINHA			; testar a linha 4 
	MOVB [R2], R1			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JZ   espera_tecla		; se nenhuma tecla premida, repete

	MOV	R4, [delta_contador]; NÃO pode estar num registo (processos não partilham registos!)
	NEG	R4				; simétrico do R4 (+1 ou -1)
	MOV	[delta_contador], R4; atualiza na memória

ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD				; sem YIELD, o ciclo é bloqueante
	MOV  R1, LINHA			; testar a linha 4  (R1 tinha sido alterado)
	MOVB [R2], R1			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver
	JMP  espera_tecla		; repete ciclo

