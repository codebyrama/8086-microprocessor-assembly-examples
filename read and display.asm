; read and display character

.MODEL SMALL

.STACK 100H

.CODE
MAIN PROC
    MOV AH, 2
    MOV DL, '?'
    INT 21H 
    MOV AH, 1
    INT 21H
    MOV BL, AL
    MOV AH, 2
    MOV DL, 0DH ;carriage return
    INT 21H
    MOV AH, 2
    MOV DL, 0AH ;line feed
    INT 21H
    MOV DL, BL
    INT 21H
    MOV AH, 4CH
    INT 21h
    MAIN ENDP
END MAIN
