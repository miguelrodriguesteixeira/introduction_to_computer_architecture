; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos periféricos de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU  1000b  ; linha a testar (4ª linha, 1000b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA EQU 0B000H
MULT EQU 0100b

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV R8, MULT
	MOV R6, LINHA

; corpo principal do programa
começa:
	MOV R7, 0
	MOV R9, 0
	MOV R1, 0
	MOVB [R4], R1 ; coloca o display a 0

ciclo:
   MOVB [R2], R6 ; escreve no periférico de saida qual é a linha
   MOVB R0, [R3]
   MOV R1,R0
   AND R0, R5
   CMP R0, 0
   JNZ converte
   SHR R6,1 ; MUDA DE LINHA
   JZ reset ; passa para a linha 1000b again
   JMP ciclo
	
reset:
	MOV R6, LINHA
	JMP ciclo

adc_l:
	ADD R7, 1
	JMP converte
	
adc_c:
	ADD R9 ,1
	JMP converte

converte:
	SHR R6, 1
	CMP R6, 0
	JNZ adc_l
	SHR R0,1
	CMP R0,0
	JNZ adc_c
	MUL R7, R8
	ADD R7, R9
	JMP escreve
	
escreve:
	;MOV R7, 0
	;MOV R9, 0
	MOV R1, R6
	;SHL R1,4
	;OR R1, R0
	MOVB [R4], R7
	JMP ha_tecla
	
ha_tecla:
	MOVB R0, [R3]
	AND  R0, R5 
	CMP R0, 0
	JNZ ha_tecla
	JMP começa
  
  

   
   
