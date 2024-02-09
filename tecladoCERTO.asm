; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descri��o: Exemplifica o acesso a um teclado.
; *            L� uma linha do teclado, verificando se h� alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos perif�ricos de 8 bits
; *       atrav�s da instru��o MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATEN��O: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto n�o altera o valor de 16 bits e permite distinguir n�meros de identificadores
DISPLAYS   EQU 0A000H  ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    EQU 0C000H  ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    EQU 0E000H  ; endere�o das colunas do teclado (perif�rico PIN)
LINHA      EQU  1000b  ; linha a testar (4� linha, 1000b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA EQU 0B000H
MULT EQU 0100b

; **********************************************************************
; * C�digo
; **********************************************************************
PLACE      0
inicio:		
; inicializa��es
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R4, DISPLAYS  ; endere�o do perif�rico dos displays
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV R8, MULT
	MOV R6, LINHA

; corpo principal do programa
come�a:
	MOV R7, 0
	MOV R9, 0
	MOV R1, 0
	MOVB [R4], R1 ; coloca o display a 0

ciclo:
   MOVB [R2], R6 ; escreve no perif�rico de saida qual � a linha
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
	JMP come�a
  
  

   
   
