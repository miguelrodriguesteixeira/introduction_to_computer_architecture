; ********************************************************************
; * IST-UL
; * Modulo:    lab2-1.asm
; * Descri��o: Exemplos de instru��es simples no PEPE-16.
; ********************************************************************
    MOV R1, 5678H   ; constante de 16 bits (dois bytes)
    ROR R1, 8       ; roda at� o byte mudar de s�tio
    MOV R2, 45H     ; constante de 8 bits (um byte)
    ADD R1, R2      ; exemplo de adi��o
    MOV R3, R1      ; guarda resultado em R3
    MOV R6, 8       ; para um ciclo de 8 itera��es
ciclo:
    SHL R1, 1       ; desloca 1 bit para a esquerda
    SUB R6, 1       ; decrementa contador e afeta bits de estado
    JNZ ciclo       ; salta se ainda n�o tiver chegado a 0
    SHL R3, 8       ; deslocamento de 8 bits para a esquerda
    SUB R1, R3      ; D� sempre 0. Compare como obteve R1 e R3
fim:
    JMP fim         ; forma expedita de "terminar"

