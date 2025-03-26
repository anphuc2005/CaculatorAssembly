.model small
.stack 100h

.data
    msg1 db "==== CALCULATOR ====", 0x0D, 0x0A, "$"
    msg2 db "1. Add", 0x0D, 0x0A, "$"
    msg3 db "2. Subtract", 0x0D, 0x0A, "$"
    msg4 db "3. Multiplication", 0x0D, 0x0A, "$"
    msg5 db "4. Divide", 0x0D, 0x0A, "$"
    msg6 db "5. Exit", 0x0D, 0x0A, "$"
    prompt db "Choose the operation (1-4): $"
    msg_input1 db "Enter first number: $"
    msg_input2 db "Enter second number: $"
    msg_result db "Result: $"
    msg_exit db "Exiting...", 0x0D, 0x0A, "$"
    newline db 0x0D, 0x0A, "$"
    operation db ?

.code
main:
    mov ax, @data
    mov ds, ax

displayMenu:
    mov ah, 09h
    lea dx, msg1
    int 21h
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
    lea dx, prompt
    int 21h

    call getChoice
    cmp operation, '5'
    je quitProgram

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, msg_input1
    int 21h
    call inputDec
    push ax  ; Lýu s? th? nh?t vào stack

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, msg_input2
    int 21h
    call inputDec
    push ax  ; Lýu s? th? hai vào stack

    ; Ch?n phép toán
    pop bx  ; L?y s? th? hai t? stack
    pop ax  ; L?y s? th? nh?t t? stack

    cmp operation, '1'
    je addNumbers
    cmp operation, '2'
    je subtractNumbers
    cmp operation, '3'
    je multiplyNumbers
    cmp operation, '4'
    je divideNumbers
    jmp displayMenu

getChoice:
    mov ah, 01h
    int 21h
    mov operation, al
    ret

addNumbers:
    add ax, bx
    call outputDec
    ;jo overflow
    ;call printResult
    jmp displayMenu

subtractNumbers:
    sub ax, bx
    jo overflow
    call printResult
    jmp displayMenu

multiplyNumbers:
    imul bx
    jo overflow
    call printResult
    jmp displayMenu

divideNumbers:
    cmp bx, 0
    je displayMenu
    cwd
    idiv bx
    call printResult
    jmp displayMenu

overflow:
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp displayMenu

printResult:
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_result
    int 21h
    call outputDec
    lea dx, newline
    mov ah, 09h
    int 21h
    ret

quitProgram:
    lea dx, msg_exit
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h

inputDec proc
    push bx
    push cx
    push dx
    xor bx, bx
    xor cx, cx
    
    mov ah, 1
    int 21h
    cmp al, '-'
    je negative
    cmp al, '0'
    jl inputDec
    cmp al, '9'
    jg inputDec

convert:
    and ax, 000Fh
    push ax
    mov ax, 10
    mul bx
    mov bx, ax
    pop ax
    add bx, ax

    mov ah, 1
    int 21h
    cmp al, 13
    jne convert

    mov ax, bx
    or cx, cx
    je done
    neg ax

done:
    pop dx
    pop cx
    pop bx
    ret

negative:
    mov cx, 1
    int 21h
    jmp convert
inputDec endp

outputDec proc
    push bx
    push cx
    push dx
    cmp ax, 0
    jge convertToStack
    push ax
    mov dl, '-'
    mov ah, 2
    int 21h
    pop ax
    neg ax

convertToStack:
    xor cx, cx
    mov bx, 10

divLoop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne divLoop

    mov ah, 2
printLoop:
    pop dx
    add dl, 30h
    int 21h
    loop printLoop

    pop dx
    pop cx
    pop bx
    ret
outputDec endp

end main