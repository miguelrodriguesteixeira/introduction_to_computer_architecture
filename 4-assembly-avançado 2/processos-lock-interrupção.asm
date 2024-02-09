; Exemplo de utilização de processos e interrupções, com comunicação por LOCK (precisa do circuito circuito-teste-interrupções.cir)
;
; Os displays contam, com uma temporização determinada pela interrupção 0 (temporizador).
; Há quatro processos:
;	- programa principal (que também é um processo), que faz a contagem e display do valor ao ritmo da interrupção 0
;	- teclado, que deteta uma tecla
;	- inversor, que deteta a tecla C (premida na linha 4 do teclado) e inverte o sentido de contagem
;	- duplica, que deteta a tecla D (premida na linha 4 do teclado) e duplica o delta da contagem
;
; Note-se a declaração (com PROCESS) e criação (com CALL) dos processos.
; Note-se também que cada processo tem à sua disposição todos os registos (R0 a R11),
; sem perigo de interferência (cada processo tem a sua própria cópia dos registos)
;
; *********************************************************************************
; * Dados 
; *********************************************************************************
DISPLAYS	EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)
ATRASO	EQU 2000H			; atraso para tornar a contagem mais lenta

	PLACE	1000H
pilha:
	STACK 100H			; espaço reservado para a pilha do programa principal
SP_inicial:				; valor inicial para o SP do programa principal

tab:
	WORD	rot0				; tabela de interrupções (endereço de cada rotina de interrupção)

delta_contador:
	WORD	1				; valor a somar contador (+1 para subir e -1 para descer)
						; NÃO pode estar num registo (processos não partilham registos!)
						
temporizador:				; variável LOCK usada para comunicação da rotina de interrupção 0 com os processos
	LOCK	0

tecla_carregada:			; variável LOCK usada para comunicação do processo teclado com os restantes
	LOCK	0

; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE	0			; o código tem de começar em 0000H
	MOV	SP, SP_inicial		; inicializa SP do programa principal
	MOV	BTE, tab			; inicializa BTE
	MOV	R2, 1			; valor a somar contador (+1 para subir e -1 para descer)
	MOV	[delta_contador], R2; NÃO pode estar num registo (processos não partilham registos!)
	
	EI0					; permite interrupção 0
	EI					; permite interrupções (geral)
						; as interrupções devem ser permitidas antes de criar os processos,
						; para que estes sejam criados já com as flags de interrupção ativas

	CALL	teclado			; cria processo teclado (não chama a rotina!)
	CALL	inversor			; cria processo inversor (não chama a rotina!)
	CALL	duplica			; cria processo duplica (não chama a rotina!)

	MOV	R0, 0			; inicializa contador
evolui:					; programa principal também é um processo!
	MOV	R2, [temporizador]	; bloqueia até haver uma interrupção (já não precisa de YIELD)
	MOV	R2, [delta_contador]; NÃO pode estar num registo (processos não partilham registos!)
	ADD	R0, R2	     	; evolui contador
	MOV	R1, DISPLAYS		; endereço do periférico
	MOVB	[R1], R0	     	; atualiza display
	JMP	evolui			; outra vez. Processo nunca termina


; **********************************************************************
; ROT0 - Rotina que trata da interrupção 0 (apenas assinala a ocorrência)
; **********************************************************************
rot0:
	MOV	[temporizador], R0	; desbloqueia o processo do programa principal
						; o valor que é escrito é irrelevante
	RFE			     	; regressa da interrupção

; **********************************************************************
; TECLADO - Processo que inverte a evolução do contador, pelo teclado
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

	STACK 100H			; espaço reservado para a pilha do processo teclado
SP_teclado:				; valor inicial para o SP do processo teclado

PROCESS SP_teclado
teclado:
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

	MOV	[tecla_carregada], R0	; LOCK: notifica outros processos do valor da coluna detetada
							; e eles que reajam da forma que entenderem

ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD				; sem YIELD, o ciclo é bloqueante
	MOV  R1, LINHA			; testar a linha 4  (R1 tinha sido alterado)
	MOVB [R2], R1			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver
	JMP  espera_tecla		; repete ciclo

; **********************************************************************
; INVERSOR - Processo que inverte a evolução do contador, pelo teclado
;		   Basta carregar na tecla da coluna 1 da última linha (tecla C) para inverter o sentido de contagem
;		   ATENÇÃO: Devido ao ciclo de atraso no programa principal,
;		   um simples toque rápido no teclado pode passar despercebido ao inversor!
; **********************************************************************

	STACK 100H				; espaço reservado para a pilha do processo inversor
SP_inversor:					; valor inicial para o SP do processo inversor

PROCESS SP_inversor				; mesmo que um processo não use pilha, deve defini-la, pois
							; as interrupções usam a pilha do processo corrente
inversor:
	MOV	R2, [tecla_carregada]	; lê LOCK e bloqueia até outro processo lá escrever
							; ao bloquear, o LOCK faz YIELD automático
	CMP	R2, 1				; tecla na coluna 1 da última linh (C)?
	JNZ	inversor				; se não, ignora
	MOV	R4, [delta_contador]	; NÃO pode estar num registo (processos não partilham registos!)
	NEG	R4					; simétrico do R4 (+1 ou -1)
	MOV	[delta_contador], R4	; atualiza na memória
	JMP	inversor

; **********************************************************************
; DUPLICA - Processo que duplica o delta do contador, pelo teclado
;		Basta carregar na tecla da coluna 2 da última linha (tecla D) para fazer duplicar o delta do contador
;		ATENÇÃO: Devido ao ciclo de atraso no programa principal,
;		um simples toque rápido no teclado pode passar despercebido ao inversor!
; **********************************************************************

	STACK 100H				; espaço reservado para a pilha do processo duplica
SP_duplica:					; valor inicial para o SP do processo duplica

PROCESS SP_duplica				; mesmo que um processo não use pilha, deve defini-la, pois
							; as interrupções usam a pilha do processo corrente
duplica:
	MOV	R2, [tecla_carregada]	; lê LOCK e bloqueia até outro processo lá escrever
							; ao bloquear, o LOCK faz YIELD automático
	CMP	R2, 2				; tecla na coluna 2 da última linh (D)?
	JNZ	duplica				; se não, ignora
	MOV	R4, [delta_contador]	; NÃO pode estar num registo (processos não partilham registos!)
	SHL	R4, 1				; duplica o delta
	MOV	[delta_contador], R4	; atualiza na memória
	JMP	duplica



