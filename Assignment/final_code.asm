.MODEL HUGE ; Defines a huge memory model for the program.
.STACK 1000H ; Allocates 4096 bytes (1000H) for the stack.

.DATA ; Begins the data segment to define variables and constants.
    ; Carriage return and line feed for formatting output.
    CRLF    DB 007,0DH, 0AH, "$"
    
    ; Messages for user prompts during data entry.
    MSG1    DB 007,0DH, 0AH, "Data Entry:$"
    MSG2    DB 0DH, 0AH, "Enter the number of Items (n) = $"
    MSG3    DB 0DH, 0AH, "Enter the name of the Item = $"
    MSG4    DB 0DH, 0AH, "Enter the Price of the Item = $"
    
    ; Messages for displaying data before and after sorting.
    MSG5    DB 0DH, 0AH, "Unsorted Data$"
    MSG6    DB 0DH, 0AH, "The Price of $"
    MSG7    DB " is == $"
    MSG8    DB 0DH, 0AH, "Sorted Data$"
    
    ; Messages for displaying Promt for searching.
    MSG9    DB 0DH, 0AH, "Enter the Price above which you want to search = $"
    MSG10   DB 007, 0DH, 0AH, "Searched List $"
    
    ; Arrays for storing data.
    NUMBER   DW 256 DUP(?)    ; Array to store input numbers as strings.
    N_NUM    DW ?             ; Variable to store the actual number of items after conversion from string.
    ITEM    DB 256 DUP(?)     ; Array to store item names.
    PRICE    DW 256 DUP(?)    ; Array to store item prices.
    POSI    DW 256 DUP(?)     ; Array to store positions of items in the ITEM array.
    S_NUM    DW ?             ; Variable to store the actual number of Price that we want to search.

.CODE                         ; Begins the code segment to define the program's instructions.
MAIN PROC                     ; Start of the main procedure.
    ; Initialize DS and ES with the data segment address for data access.
    MOV AX, @DATA             ; Load the address of the data segment into AX.
    MOV DS, AX                ; Move the data segment address into DS.
    MOV ES, AX                ; Also move the data segment address into ES if needed for extra data access.
    
    ; Display the data entry prompt.
    LEA DX, MSG1              ; Load the offset address of MSG1 into DX.
    MOV AH, 9                 ; Set AH to 9, the Print String function in DOS interrupt.
    INT 21H                   ; Call DOS interrupt 21H to print the string pointed to by DX.
    
    ; Input the number of items.
    LEA DX, MSG2              ; Load the offset address of MSG2 into DX for the prompt.
    MOV AH, 9                 ; Set AH to 9 for the Print String function.
    INT 21H                   ; Call DOS interrupt to print the prompt.
        
    ; Read the input string into the NUMBER array.
    LEA DI, NUMBER            ; Load the offset address of the NUMBER array into DI.
    CALL READ_STR             ; Call the READ_STR procedure to read the input string.
    MOV CX, BX                ; Copy the number of characters read into CX.
    
    ; Convert the input string to a number and store it in N_NUM.
    LEA SI, NUMBER            ; Load the offset address of the NUMBER array into SI.
    CALL STR2NUM              ; Call the STR2NUM procedure to convert the string to a number.
    MOV N_NUM, BX             ; Store the converted number into N_NUM.
    
    ; Input the list of items and their prices.
    MOV CX, BX                ; Set CX to the number of items to be entered.
    XOR SI, SI                ; Clear SI to use as an index for the ITEM array.
    XOR DI, DI                ; Clear DI to use as an index for the POSI array.
    XOR BX, BX                ; Clear BX to use for position tracking within the ITEM array.
    
    LIST_INPUT:               ; Label for the beginning of the loop to input item names and prices.
        ; Prompt for entering the name of the item.
        LEA DX, MSG3          ; Load the offset of the message into DX (prompt).
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the prompt.
                
        ; Input the name of the item.
        LEA DI, ITEM          ; Load the offset of the ITEM array into DI.
        ADD DI, BX            ; Move DI to the current position in the ITEM array.
        PUSH BX               ; Save BX (current position).
        CALL READ_STR         ; Call READ_STR procedure to read the string.
        MOV AX, BX            ; Move BX (current position) to AX.
        POP BX                ; Restore BX (previous position).
        ADD BX, AX            ; Update BX to point to the next position.
        INC BX                ; Increment BX for null terminator.
        
        ; Save the start position of the next name in POSI array.
        MOV POSI[SI+2], BX
        
        ; Prompt for entering the price of the item.
        LEA DX, MSG4          ; Load the offset of the message into DX (prompt).
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the prompt.
                
        ; Input the price of the item.
        PUSH BX               ; Save BX (current position).
        LEA DI, NUMBER        ; Load the offset of the NUMBER array into DI.
        CALL READ_STR         ; Call READ_STR procedure to read the string.
        PUSH CX               ; Save CX (number of characters read).
        MOV CX, BX            ; Move BX (number of characters read) to CX.
        PUSH SI               ; Save SI (current index in POSI array).
        LEA SI, NUMBER        ; Load the offset of the NUMBER array into SI.
        CALL STR2NUM          ; Call STR2NUM procedure to convert the string to a number.
        POP SI                ; Restore SI (current index in POSI array).
        MOV PRICE[SI], BX     ; Store the price in the PRICE array.
        POP CX                ; Restore CX (number of characters read).
        POP BX                ; Restore BX (current position).
        
        ; Move to the next item.
        ADD SI, 2             ; Move to the next position in the POSI array.
        LOOP LIST_INPUT       ; Repeat for the remaining items.
    
    ; Display the unsorted list of items and their prices.
    MOV CX, N_NUM             ; Set CX to the number of items to display.
    XOR SI, SI                ; Clear SI to use as an index for the ITEM array.
    XOR BX, BX                ; Clear BX to use as an index for the POSI array.
    LEA DX, CRLF              ; Load the offset of the newline and carriage return into DX.
    MOV AH, 9                 ; Set AH to 9 for the Print String function.
    INT 21H                   ; Call DOS interrupt to print the newline and carriage return.
    LEA DX, MSG5              ; Load the offset of the unsorted data message into DX.
    INT 21H                   ; Call DOS interrupt to print the unsorted data message.
        
    LIST_OUTPUT:              ; Label for the beginning of the loop to output the unsorted list.
        ; Display the promt for name of the item.
        LEA DX, MSG6          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
        
        ; Display the name of the item.
        LEA SI, ITEM          ; Load the offset of the ITEM array into SI.
        ADD SI, POSI[BX]      ; Move SI to the start position of the current item name.
        PUSH BX               ; Save BX (current item index).
        PUSH CX               ; Save CX (number of items).
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP CX                ; Restore CX (number of items).
        POP BX                ; Restore BX (current item index).
        
        ; Display the promt for price of the item.
        LEA DX, MSG7          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
                
        ; Display the price.
        MOV AX, PRICE[BX]     ; Load the price of the current item into AX.
        PUSH CX               ; Save CX (number of items).
        PUSH SI               ; Save SI (offset of the string buffer).
        PUSH BX               ; Save BX (current item index).
        CALL NUM2STR          ; Call NUM2STR procedure to convert the number to a string.
        MOV BX, 10            ; Load BX with 10 (base for conversion).
        LEA SI, NUMBER        ; Load the offset of the NUMBER array into SI.
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP BX                ; Restore BX (current item index).
        POP SI                ; Restore SI (offset of the string buffer).
        POP CX                ; Restore CX (number of items).
        
        ; Move to the next item.
        ADD BX, 2             ; Move to the next item (increment by 2 as each POSI entry is a WORD).
        LOOP LIST_OUTPUT      ; Repeat for the remaining items.
    
    ; Bubble sort algorithm to sort the list of items by price.
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    XOR SI, SI
    XOR DI, DI
        
    ; Bubble sorting algorithm to sort the list of items by price.
    BUBBLE_SORT:
        MOV AX, PRICE[SI]   ; Load the price at the current position into AX.
        MOV BX, PRICE[SI+2] ; Load the price at the next position into BX.
        CMP AX, BX          ; Compare the two prices.
        JG EXCHANGE         ; If the price at the current position is greater, jump to exchange.
    
    BUBBLE_PASS:
        ADD SI, 2           ; Move to the next position in the PRICE array.
        MOV BX, N_NUM       ; Load the total number of items into BX.
        SUB BX, 1           ; Subtract 1 from BX to get the index of the last item.
        INC DX              ; Increment DX to move to the next element.
        CMP DX, BX          ; Compare DX with the index of the last item.
        JE BUBBLE_END       ; If they are equal, we've reached the end of the array.
        JMP BUBBLE_SORT     ; Otherwise, continue with the next pair of items.
    
    EXCHANGE:
        XCHG AX, BX         ; Exchange the data between AX and BX.
        MOV PRICE[SI], AX   ; Store the new price at the current position.
        MOV PRICE[SI+2], BX ; Store the new price at the next position.
        MOV AX, POSI[SI]    ; Load the position of the current item into AX.
        MOV BX, POSI[SI+2]  ; Load the position of the next item into BX.
        XCHG AX, BX         ; Exchange the positions.
        MOV POSI[SI], AX    ; Store the new position of the current item.
        MOV POSI[SI+2], BX  ; Store the new position of the next item.
        JMP BUBBLE_PASS     ; Jump back to continue the sorting process.
    
    BUBBLE_END:
        CWD                 ; Reset DX for the next pass.
        MOV SI, 0           ; Reset SI to the start of the PRICE array.
        MOV BX, N_NUM       ; Load the total number of items into BX.
        SUB BX, 1           ; Subtract 1 from BX for the loop condition.
        INC CX              ; Increment CX to move to the next item.
        CMP CX, BX          ; Compare CX with BX.
        JNE BUBBLE_SORT     ; If not equal, start the next pass of the bubble sort.
    
    ; Display the sorted list of items and their prices.
    MOV CX, N_NUM           ; Set CX to the number of items to display.
    XOR SI, SI              ; Clear SI to use as an index for the ITEM array.
    XOR BX, BX              ; Clear BX to use as an index for the POSI array.
    LEA DX, CRLF            ; Load the offset of the newline and carriage return into DX.
    MOV AH, 9               ; Set AH to 9 for the Print String function.
    INT 21H                 ; Call DOS interrupt to print the newline and carriage return.
    LEA DX, MSG8            ; Load the offset of the sorted data message into DX.
    INT 21H                 ; Call DOS interrupt to print the sorted data message.
        
    LIST_OUTPUT2:
        ; Display the promt for name of the item.
        LEA DX, MSG6          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
                
        ; Display the name of the item.
        LEA SI, ITEM          ; Load the offset of the ITEM array into SI.
        ADD SI, POSI[BX]      ; Move SI to the start position of the current item name.
        PUSH BX               ; Save BX (current item index).
        PUSH CX               ; Save CX (number of items).
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP CX                ; Restore CX (number of items).
        POP BX                ; Restore BX (current item index).
        
        ; Display the promt for price of the item.
        LEA DX, MSG7          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
        
        ; Display the price.
        MOV AX, PRICE[BX]     ; Load the price of the current item into AX.
        PUSH CX               ; Save CX (number of items).
        PUSH SI               ; Save SI (offset of the string buffer).
        PUSH BX               ; Save BX (current item index).
        CALL NUM2STR          ; Call NUM2STR procedure to convert the number to a string.
        MOV BX, 10            ; Load BX with 10 (base for conversion).
        LEA SI, NUMBER        ; Load the offset of the NUMBER array into SI.
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP BX                ; Restore BX (current item index).
        POP SI                ; Restore SI (offset of the string buffer).
        POP CX                ; Restore CX (number of items).
        
        ; Move to the next item.
        ADD BX, 2             ; Move to the next item (increment by 2 as each POSI entry is a WORD).
        LOOP LIST_OUTPUT2      ; Repeat for the remaining items.
        
    ; Searching the items name with price more than Entered price 
    LEA DX, CRLF            ; Load the offset of the newline and carriage return into DX.
    MOV AH, 9               ; Set AH to 9 for the Print String function.
    INT 21H                 ; Call DOS interrupt to print the newline and carriage return.
    ; Display the Search Start prompt.
    LEA DX, MSG9          ; Load the offset of the message into DX.
    MOV AH, 9             ; Set AH to 9 for the Print String function.
    INT 21H               ; Call DOS interrupt to print the message.    
    ; Input the Price to search
    ; Read the input string into the NUMBER array.
    LEA DI, NUMBER            ; Load the offset address of the NUMBER array into DI.
    CALL READ_STR             ; Call the READ_STR procedure to read the input string.
    MOV CX, BX                ; Copy the number of characters read into CX.
    
    ; Convert the input string to a number and store it in N_NUM.
    LEA SI, NUMBER            ; Load the offset address of the NUMBER array into SI.
    CALL STR2NUM              ; Call the STR2NUM procedure to convert the string to a number.
    MOV S_NUM, BX             ; Store the converted number into N_NUM.
    
    ; Searching Algorithm
    XOR CX, CX              ; Clear CX to use as an index for the ITEM array.
    XOR AX, AX              ; Clear AX to use as an index for the POSI array.
    XOR SI, SI              ; Clear SI to use as an index for the ITEM array.
    MOV DX, 0
    SEARCH:
        MOV DX, PRICE[SI]   ; Load the price into DX.
        ADD SI, 2           ; Move to the next price.
        INC AX              ; Increment the position index.
        CMP DX, BX          ; Compare the price with the search value.
        JNG SEARCH          ; If the price is not greater, continue searching.
    SUB SI, 2               ; Adjust SI to point to the found price.
    MOV BX, SI              ; Move the found index to BX.
    MOV CX, N_NUM           ; Load the total number of items into CX.
    DEC AX                  ; Decrement AX since we incremented it one time too many.
    SUB CX, AX              ; Calculate the remaining number of items.
    XOR SI, SI              ; Clear SI to use as an index for the ITEM array.
    
    LEA DX, MSG10          ; Load the offset of the message into DX.
    MOV AH, 9             ; Set AH to 9 for the Print String function.
    INT 21H               ; Call DOS interrupt to print the message.    
    LIST_OUTPUT3:
        ; Display the promt for name of the item.
        LEA DX, MSG6          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
                
        ; Display the name of the item.
        LEA SI, ITEM          ; Load the offset of the ITEM array into SI.
        ADD SI, POSI[BX]      ; Move SI to the start position of the current item name.
        PUSH BX               ; Save BX (current item index).
        PUSH CX               ; Save CX (number of items).
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP CX                ; Restore CX (number of items).
        POP BX                ; Restore BX (current item index).
        
        ; Display the promt for price of the item.
        LEA DX, MSG7          ; Load the offset of the message into DX.
        MOV AH, 9             ; Set AH to 9 for the Print String function.
        INT 21H               ; Call DOS interrupt to print the message.
        
        ; Display the price.
        MOV AX, PRICE[BX]     ; Load the price of the current item into AX.
        PUSH CX               ; Save CX (number of items).
        PUSH SI               ; Save SI (offset of the string buffer).
        PUSH BX               ; Save BX (current item index).
        CALL NUM2STR          ; Call NUM2STR procedure to convert the number to a string.
        MOV BX, 10            ; Load BX with 10 (base for conversion).
        LEA SI, NUMBER        ; Load the offset of the NUMBER array into SI.
        CALL DISP_STR         ; Call DISP_STR procedure to display the string.
        POP BX                ; Restore BX (current item index).
        POP SI                ; Restore SI (offset of the string buffer).
        POP CX                ; Restore CX (number of items).
        
        ; Move to the next item.
        ADD BX, 2             ; Move to the next item (increment by 2 as each POSI entry is a WORD).
        LOOP LIST_OUTPUT3     ; Repeat for the remaining items. 
    
    ; Terminate the program.
    MOV AH, 4CH                 ; Set AH to 4CH, the terminate program function.
    INT 21H                     ; Call DOS interrupt to terminate the program.
    
MAIN ENDP                   ; End of the main procedure.

READ_STR PROC NEAR
; Read and store a string from standard input
; Input: DI - offset of the string buffer
; Output: DI - offset of the string after reading
; BX - number of characters read

    PUSH AX                 ; Save AX register onto the stack
    PUSH DI                 ; Save DI register onto the stack
    CLD                     ; Clear the direction flag to process from left to right
    XOR BX, BX              ; Clear BX register (set BX to 0)
    MOV AH, 01h             ; Set AH to 01h for "Read Character with Echo" function
                            ; (reads a character from standard input with echo)

READ_LOOP:
    INT 21H                 ; Call DOS interrupt to read a character from standard input (keyboard)
    
    ; Check if the read character is carriage return (Enter key)
    CMP AL, 0DH    
    JE END_READ_LOOP        ; If AL (the read character) is 0DH (carriage return), exit the loop
    
    ; If the read character is backspace
    CMP AL, 08H     
    JNE NOT_BACKSPACE       ; If AL is not 08H (backspace), continue to the next part of the code
    
    ; Handling backspace:
    DEC DI                  ; Decrement DI to move back one position in the string buffer
    DEC BX                  ; Decrement BX to reflect the removal of a character
    JMP READ_LOOP           ; Continue reading characters

NOT_BACKSPACE:
    STOSB                   ; Store the character in AL into the memory location pointed by DI
    INC BX                  ; Increment BX to count the number of characters read
    JMP READ_LOOP           ; Continue reading characters

END_READ_LOOP:
    STOSB                   ; Store the terminating enter character (0DH) at the end of the string
    POP DI                  ; Restore DI register from the stack
    POP AX                  ; Restore AX register from the stack
    RET                     ; Return from the procedure

READ_STR ENDP

DISP_STR PROC
; Display a null-terminated string
; Input: SI - offset of the string buffer

    PUSH AX                 ; Save AX register onto the stack
    PUSH BX                 ; Save BX register onto the stack
    PUSH CX                 ; Save CX register onto the stack
    PUSH DX                 ; Save DX register onto the stack
    PUSH SI                 ; Save SI register onto the stack
    MOV AH, 2               ; Set AH to 2 for "Display Character" function (writes a character to standard output)

TOP:
    LODSB                   ; Load the byte from the memory location addressed by SI into AL, and increment SI
    MOV DL, AL              ; Move the character from AL to DL for displaying

    CMP DL, 0DH             ; Compare DL with carriage return (0DH)
    JE P_EXIT               ; If DL is 0DH (end of string), exit the loop

    INT 21H                 ; Call DOS interrupt to display the character in DL

    JMP TOP                 ; Continue looping to display the next character

P_EXIT:
    POP SI                  ; Restore SI register from the stack
    POP DX                  ; Restore DX register from the stack
    POP CX                  ; Restore CX register from the stack
    POP BX                  ; Restore BX register from the stack
    POP AX                  ; Restore AX register from the stack
    RET                     ; Return from the procedure

DISP_STR ENDP

STR2NUM PROC
; Convert a string of ASCII characters representing a number into its numerical value
; Input: SI - offset of the string buffer
; Output: BX - numerical value of the string

    XOR BX, BX              ; Clear BX to use it for storing the numerical value
    PUSH DX                 ; Save DX register on the stack for later use
    XOR DX, DX              ; Clear DX to use it for intermediate calculations

CONVERT_LOOP:
    MOV DL, [SI]            ; Load the current character from the string into DL
    TEST DL, DL             ; Test if the current character is the null terminator (end of string)
    JZ END_CONVERT          ; If it is, jump to the end of the loop

    SUB DL, '0'             ; Convert ASCII character to its numerical value (e.g., '3' to 3)
    MOV AX, BX              ; Move the current total in BX to AX for multiplication
    MOV BX, 10              ; Set BX to 10, the base of decimal numbers
    PUSH DX                 ; Save DX register onto the stack
    MUL BX                  ; Multiply AX by 10 (shift left by one decimal place)
    POP DX                  ; Get DX from stack
    ADD AX, DX              ; Add the numerical value of the current character to AX
    MOV BX, AX              ; Move the new total back to BX
    INC SI                  ; Increment SI to point to the next character in the string
    LOOP CONVERT_LOOP       ; Repeat the loop until CX becomes zero

END_CONVERT:
    POP DX                  ; Restore the original value of DX from the stack
    RET                     ; Return from the procedure with the result in BX

STR2NUM ENDP

NUM2STR PROC
; Convert a number to its string representation
; Input: AX - numeric value to convert
;        DI - offset of the buffer to store the string
; Output: BX - number of characters in the string

    PUSH CX             ; Save CX register onto the stack
    PUSH DX             ; Save DX register onto the stack
    XOR CX, CX          ; Clear CX register for character count
    MOV BX, 10          ; Set BX to 10 for division
    
    ; Move the address of the buffer to store the string into DI
    MOV DI, OFFSET NUMBER  
    
CONVERT_LOOP2:
    XOR DX, DX          ; Clear DX register for division
    DIV BX              ; Divide AX by 10, quotient in AX, remainder in DX
    ADD DL, '0'         ; Convert the remainder to ASCII
    PUSH DX             ; Push the ASCII character onto the stack
    INC CX              ; Increment character count
    TEST AX, AX         ; Check if quotient is zero
    JNZ CONVERT_LOOP2   ; If not zero, continue the loop
    
    ; Pop characters from stack to buffer in reverse order
POP_LOOP:
    POP AX              ; Pop the ASCII character from the stack
    MOV [DI], AL        ; Store the character in the buffer
    INC DI              ; Move to the next position in the buffer
    LOOP POP_LOOP       ; Repeat until all characters are stored
    
    ; Save the number of characters in BX
    MOV BX, CX
    
    ; Append carriage return (0DH) to the end of the string
    MOV BYTE PTR [DI], 0DH  ; Store carriage return (0DH) at the end of the string
    INC DI                  ; Move to the next position in the buffer
    
    POP DX              ; Restore DX register from the stack
    POP CX              ; Restore CX register from the stack
    RET                 ; Return from the procedure
NUM2STR ENDP

END MAIN