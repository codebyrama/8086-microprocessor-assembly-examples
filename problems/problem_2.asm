;Problem 2

.MODEL SMALL

.STACK 100H

.DATA

.CODE
MAIN PROC
    MOV AH,2
    MOV CL,80H
    MOV BL,0
    
    DISPLAY:
        MOV DL,CL
        INT 21H
        MOV DL,' '
        INT 21H
        INC CL
        INC BL
        CMP CL,0FFH
        JB TEN;
        JMP END;
    
    TEN:
        CMP BL,0AH
        JNE DISPLAY;
        MOV BL,0
        MOV DL,0DH
        INT 21H
        MOV DL,0AH
        INT 21H
        JMP DISPLAY; 
        
    END:
        MOV AH,4CH
        INT 21h
    
    MAIN ENDP
END MAIN  MOV DL,CL 
        INT 21h
        MOV DL,BL
        INT 21h
        JMP END;
    
    END:
        MOV AH,4CH
        INT 21h
    
    MAIN ENDP
END MAIN