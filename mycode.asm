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
    msg_result db "Your result is: $"
    msg_exit db "Quitting your program....", 0x0D, 0x0A, "$"
    newline db 0x0D, 0x0A, "$"
    num1 db ?
    num2 db ?
    result db ?
    operation db ?

.code
main:
    mov ax, @data
    mov ds, ax

displayMenu:
    ; Hi?n th? menu
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

    ; Nh?p l?a ch?n ph�p to�n
    lea dx, prompt
    int 21h
    call getChoice
    

    cmp operation, '5'
    je quitProgram
    
    ; Xuong dong
    lea dx, newline
    mov ah, 09h
    int 21h

    ; Nh?p s? th? nh?t
    lea dx, msg_input1
    int 21h
    call getNumber
    mov num1, al  ; L�u s? th? nh?t
    
    ; Xuong dong
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Nh?p s? th? hai
    lea dx, msg_input2
    int 21h
    call getNumber
    mov num2, al  ; L�u s? th? hai   
    
    lea dx, newline
    mov ah, 09h
    int 21h

    ; X? l? c�c ph�p to�n
    cmp operation, '1'
    je addNumbers
    cmp operation, '2'
    je subtractNumbers
    cmp operation, '3'
    je multiplyNumbers
    cmp operation, '4'
    je divideNumbers

    jmp displayMenu  ; N?u kh�ng h?p l?, quay l?i menu

    getChoice:
        mov ah, 01h
        int 21h
        mov operation, al
        ret
    
    getNumber:
        mov ah, 01h
        int 21h
        cmp al, 0Dh  ; Ki hieu enter
        je getNumber  ; Nhap lai
        sub al, '0'
        ret
    
    addNumbers:
        mov al, num1
        add al, num2
        mov result, al
        call printResult
        jmp displayMenu
    
    subtractNumbers:
        mov al, num1
        sub al, num2
        mov result, al
        call printResult
        jmp displayMenu
    
    multiplyNumbers:
        mov al, num1
        mov bl, num2
        mul bl  ; AL = AL * BL
        mov result, al
        call printResult
        jmp displayMenu
    
    divideNumbers:
        mov al, num1
        mov ah, 0    ; X�a AH �? tr�nh l?i chia
        mov bl, num2
        cmp bl, 0
        je displayMenu  ; Tr�nh chia cho 0
        div bl         ; AL = AL / BL (th��ng s?), AH = d�
        mov result, al
        call printResult
        jmp displayMenu
    
    printResult:
        ; Xu?ng d?ng
        lea dx, newline
        mov ah, 09h
        int 21h
    
        ; In th�ng b�o k?t qu?
        lea dx, msg_result
        int 21h
    
        ; In k?t qu? (s? ��n gi?n, 0-9)
        mov dl, result
        add dl, '0'  ; Chuy?n sang ASCII
        mov ah, 02h
        int 21h
    
        ; Xu?ng d?ng
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
