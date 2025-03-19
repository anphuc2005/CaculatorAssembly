.model small
.stack 100h

.data
    msg1 db "==== CALCULATOR ====", 0x0D, 0x0A, "$"
    msg2 db "1. Add", 0x0D, 0x0A, "$"
    msg3 db "2. Subtract", 0x0D, 0x0A, "$"
    msg4 db "3. Multiplication", 0x0D, 0x0A, "$"
    msg5 db "4. Divide", 0x0D, 0x0A, "$"
    msg6 db "5. Exit", 0x0D, 0x0A, "$"
    prompt db "Choose the operation to solve (1-4): $"
    msg_input1 db "Enter your first number : $"
    msg_input2 db "Enter your second number : $"
    newline db 0x0D, 0x0A, "$"
    msg_exit db "Quitting your program....", 0x0D, 0x0A, "$"
    num1 db ?
    num2 db ?
    operation db ?

.code
main:
    ; Set up the data segment
    mov ax, @data
    mov ds, ax

    ; Display the calculator menu
    displayMenu:
        ; Print header
        mov ah, 09h
        lea dx, msg1
        int 21h

        ; Print options
        lea dx, msg2
        int 21h
        lea dx, msg3
        int 21h
        lea dx, msg4
        int 21h
        lea dx, msg5
        int 21h
        lea dx, msg6
        int 21h

        ; Prompt for operation choice
        lea dx, prompt
        int 21h
        call getChoice

        ; Check if the user wants to exit
        cmp operation, '5'
        je quitProgram

        ; Get first number
        lea dx, msg_input1
        int 21h
        call getNumber
        mov al, num1 ; Store num1 in AL

        ; Get second number
        lea dx, msg_input2
        int 21h
        call getNumber
        mov bl, num2 ; Store num2 in BL

        ; Here you can add your operations later
        ; Just go back to the menu for now
        jmp displayMenu

    getChoice:
        ; Get user choice for the operation
        mov ah, 01h
        int 21h
        mov operation, al ; Store the operation choice in variable
        ret

    getNumber:
        ; Get user input for a number (single digit input for simplicity)
        mov ah, 01h
        int 21h
        sub al, '0'   ; Convert ASCII to integer
        mov num1, al  ; Store input in num1 (for first number)
        ret

    quitProgram:
        lea dx, msg_exit
        mov ah, 09h
        int 21h
        ; Exit the program
        mov ah, 4Ch
        int 21h
