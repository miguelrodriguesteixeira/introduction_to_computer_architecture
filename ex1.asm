; ********************************************************************
; MT
; ********************************************************************

N EQU 5     ; definição do N
MOV R0,0    ; soma para 0
MOV R1,N    ; iteracao do N

maisUm: 
    CMP R1,0    ; se a iteracao for (<=0) salta para o fim
    JLE fim
    ADD R0, R1
    SUB R1, 1
    JMP maisUm

fim:
    JMP fim ; termina o programa