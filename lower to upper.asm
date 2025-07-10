;Program: Lower case to upper case
.MODEL SMALL
.STACK 100H
.DATA
CR EQU 0DH
LF EQU 0AH
MSG1 DB 'Enter the letter in lower case : $'
MSG2 DB 0DH,0AH,'In upper case it is: '
CHAR DB ?,'$‘
.CODE
MAIN PROC
MOV AX,@DATA 
MOV DS,AX