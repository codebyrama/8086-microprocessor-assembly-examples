;Problem 1

.MODEL SMALL

.STACK 100H

.DATA

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH, 2
    MOV DL, '?'
    INT 21h

    
    MOV AH, 1
    INT 21h
    MOV BL,AL
    
    MOV AH,1
    INT 21h
    MOV CL,AL
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21h
    MOV DL, 0AH
    INT 21h
    
    CMP BL,CL
        JB a_first;
        JA b_first;
        JE a_first;
    
    a_first:
        MOV DL,BL
        INT 21h
        MOV DL,CL
        INT 21h
        JMP END;
    
    b_first:
        MOV DL,CL 
        INT 21h
        MOV DL,BL
        INT 21h
        JMP END;
    
    END:
        MOV AH,4CH
        INT 21h
    
    MAIN ENDP
END MAIN