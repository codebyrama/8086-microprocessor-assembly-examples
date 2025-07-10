;Problem 4

.MODEL SMALL

.STACK 100H

.DATA

MSG1 DB 0DH,0AH,'ENTER A HEX DIGIT: $'
MSG2 DB 0DH,0AH,'IN DECIMAL IT IS: $'
MSG3 DB 0DH,0AH,'DO YOU WANT TO DO IT AGAIN? $'
MSG4 DB 0DH,0AH,'ILLEGAL CHARACTER - ENTER 0...9 or A...F : $'
MSG5 DB 0DH,0AH,'GO LEARN HEX NO$'

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV BL,0d
    
    START:
        LEA DX,MSG1
        MOV AH,9
        INT 21h
    
    INPUT:
        MOV AH,1
        INT 21h
        MOV CL,AL
        
        CMP CL,'0'
            JB  ERROR;
        CMP CL,'9'
            JBE DISPLAY1;
        CMP CL,'A'
            JB  ERROR;
        CMP CL,'F'
            JBE DISPLAY2;
    
    ERROR:
        INC BL
        CMP BL,3d
        JNB BYE;
        LEA DX,MSG4
        MOV AH,9
        INT 21h
        JMP INPUT
        
    DISPLAY1:
        LEA DX,MSG2
        MOV AH,9
        INT 21h
        MOV DL,CL
        MOV AH,2
        INT 21h
        JMP AGAIN;
        
    DISPLAY2:
        LEA DX,MSG2
        MOV AH,9
        INT 21h
        MOV AH,2
        MOV DL,'1'
        INT 21h
        SUB CL,17d       
        MOV DL,CL
        MOV AH,2
        INT 21h
        JMP AGAIN;
            
    AGAIN:
        LEA DX,MSG3
        MOV AH,9
        INT 21h
        
        MOV AH,1
        INT 21h
        
        CMP AL,'Y'
            JE  START;
        CMP AL,'y'
            JE  START;
        JMP END
     
     BYE:
        LEA DX,MSG5
        MOV AH,9
        INT 21h
        
     END:    
        MOV AH,4CH
        INT 21h
        
    MAIN ENDP
END MAIN