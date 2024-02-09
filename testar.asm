MOV R1, 0DCCDH 
MOV R2, 7233H
MOV R3, 0 
 
ciclo: 
    AND R1, R2
    JZ fim 
    ADD R3, 1
    SHL R2, 1
    JMP ciclo
 
fim: 
    JMP fim 