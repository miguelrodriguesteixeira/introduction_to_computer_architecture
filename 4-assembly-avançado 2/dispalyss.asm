; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO			EQU 8		; linha a testar (4ª linha, 1000b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
COLUNA_ESQUERDA			EQU 1		; tecla na primeira coluna do teclado (tecla C)
COLUNA_DISPARO                   EQU 2		; tecla na segunda coluna do teclado (tecla D)
COLUNA_DIREITA			EQU 4		; tecla na segunda coluna do teclado (tecla E)


DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				EQU 605AH      ; endereço do comando para tocar um som
REPETE_SOM                              EQU 605CH  ;LOOP DE SOM
PARA_SOM                                EQU 6066H;acaba a reprodução de um som

LINHA        		EQU  27        ; linha do boneco (a meio do ecrã))
COLUNA			EQU  30        ; coluna do boneco (a meio do ecrã)

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO			EQU	5000H		; atraso para limitar a velocidade de movimento do boneco


LARGURA		EQU	5			; largura do boneco
COR_AMARELA		EQU	0FFF0H		; cor do pixel: amarelo em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_AZUL		EQU     0F00FH		; cor do pixel: azul em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_VERMELHA		EQU	0FF00H		; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							

DEF_BONECO:					; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		5
	WORD			0,0, COR_AMARELA, 0,0		; # # #   as cores podem ser diferentes
	WORD			0,0, COR_AMARELA, 0,0 
	WORD		COR_AMARELA,0, COR_AMARELA, 0, COR_AMARELA
	WORD		COR_AMARELA,0, COR_AMARELA, 0, COR_AMARELA
	WORD		COR_AMARELA,COR_AMARELA, COR_AMARELA, COR_AMARELA,COR_AMARELA
	 
     


; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
; Mudar para todas as linhas
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5
	linha_um:
	MOV  R6, 1
	teclado_2:
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R6      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	CMP  R0,0
	JZ   shift_left
	CMP  R0,0
	JNZ	sair_teclado
	shift_left:
	MOV	R9,8
	CMP	R6,R9
	JZ      linha_um
	SHL	R6,1
	JMP teclado_2
	sair_teclado:
	POP	R5
	POP	R3
	POP	R2
	RET

