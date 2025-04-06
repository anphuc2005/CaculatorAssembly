.model small
.stack 100h
.data
    msg1 db "==== CALCULATOR ====", 0x0D, 0x0A, "$"
    msg2 db "1. Add", 0x0D, 0x0A, "$"
    msg3 db "2. Subtract", 0x0D, 0x0A, "$"
    msg4 db "3. Multiplication", 0x0D, 0x0A, "$"
    msg5 db "4. Divide", 0x0D, 0x0A, "$"
    msg6 db "5. Power", 0x0D, 0x0A, "$"
    msg7 db "6. Modulus (Remainder)", 0x0D, 0x0A, "$"
    msg8 db "7. Exit", 0x0D, 0x0A, "$"
    prompt db "Choose the operation (1-7): $"
    msg_input1 db "Enter first number (base for power) : $"
    msg_input2 db "Enter second number (exponent for power) : $"
    msg_result db "Result: $"
    msg_exit db "Exiting...", 0x0D, 0x0A, "$"
    msg_div_zero db "Error: Cannot divide by zero! Please enter a non-zero number: $"
    msg_continue db "Press any key to continue...$"
    newline db 0x0D, 0x0A, "$"
    operation db ?
.code
main:
    mov ax, @data
    mov ds, ax
displayMenu:
    ;Hien thi messenger
    call clearScreen
    mov ah, 09h
    lea dx, msg1 ; Goi den messenger do
    int 21h      ; Cau lenh in ra man hinh
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
    lea dx, msg7
    int 21h
    lea dx, msg8
    int 21h
    lea dx, prompt
    int 21h
    ; Goi ham getChoice de lay lua chon
    call getChoice
    cmp operation, '7'
    je quitProgram
    ; Giong endl trong c++
    lea dx, newline
    mov ah, 09h
    int 21h
    ; Luu so co nhieu chu so vao trong stack
    lea dx, msg_input1
    int 21h
    call inputDec
    push ax  ; Luu so dau vao trong stack
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
getSecondNumber:
    ; In ra messenger input2 va goi den de luu so co nhieu chu so
    lea dx, msg_input2
    mov ah, 09h
    int 21h
    call inputDec
    
    ; Kiem tra neu chon phep chia hoac modulo thi xem so 2 co bang 0
    cmp operation, '4'
    je checkDivZero
    cmp operation, '6'
    je checkDivZero
    jmp continueOperation
    
checkDivZero:
    cmp ax, 0
    jne continueOperation
    ; Yeu cau nhap lai
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_div_zero
    int 21h
    jmp getSecondNumber
    
continueOperation:
    push ax  ; Luu so thu 2 da nhap vao stack
    ; Select operation
    pop bx  ; Lay so thu 2 ra khoi stack
    pop ax  ; Lay so thu 1 ra khoi stack
    
    cmp operation, '1'
    je addNumbers
    cmp operation, '2'
    je subtractNumbers
    cmp operation, '3'
    je multiplyNumbers
    cmp operation, '4'
    je divideNumbers
    cmp operation, '5'   
    je powerNumbers
    cmp operation, '6'   
    je modulusNumbers
    jmp displayMenu
    
clearScreen proc
    push ax
    push bx
    push cx
    push dx
    
    mov ax, 0600h  ; AH=6 (scroll), AL=0 (full screen)
    mov bh, 07h    ; Normal attribute (black background, white text)
    mov cx, 0000h  ; Upper left corner (0,0)
    mov dx, 184Fh  ; Lower right corner (24,79)
    int 10h        ; Call BIOS video service
    
    ; Reset cursor position to top left
    mov ah, 02h    ; Set cursor position
    mov bh, 0      ; Page number
    mov dx, 0000h  ; Row 0, Column 0
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clearScreen endp

getChoice:
    mov ah, 01h
    int 21h
    mov operation, al
    ret
    
addNumbers:
    add ax, bx
    call printResult
    call waitForKey
    jmp displayMenu
    
subtractNumbers:
    sub ax, bx
    call printResult
    call waitForKey
    jmp displayMenu
    
multiplyNumbers:
    imul bx
    call printResult
    call waitForKey
    jmp displayMenu
    
divideNumbers:
    cwd
    idiv bx
    call printResult
    call waitForKey
    jmp displayMenu
    
powerNumbers:
    call calculatePower
    call printResult
    call waitForKey
    jmp displayMenu
    
modulusNumbers:
    cwd
    idiv bx
    mov ax, dx     
    call printResult
    call waitForKey
    jmp displayMenu
    
waitForKey:
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_continue
    int 21h
    
    mov ah, 01h   
    int 21h
    ret
    
printResult:
    push ax   
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_result
    int 21h
    pop ax    ;Khoi phuc lai thanh ghi AX cho lan su dung tiep
    call outputDec
    lea dx, newline
    mov ah, 09h
    int 21h
    ret
    
calculatePower:
    push cx     ; Luu thanh ghi cx va dx
    push dx
    
    mov cx, bx  ; Truyen gia tri so thu 2 (mu cua luy thua) tu thanh ghi bx vao cx
    cmp cx, 0
    je powerZero
    
    cmp cx, 1   ; Kiem tra truong hop mu = 1
    je powerDone
    
    dec cx      ; Giam so mu di 1 don vi
    mov dx, ax  ; Luu gia tri da nhan vao dx
    
powerLoop:
    cmp cx, 0
    je powerDone
    imul dx     ; AX = AX * DX
    dec cx
    jmp powerLoop
    
powerZero:
    mov ax, 1   ; Neu mu = 0 thi in ra 1
    
powerDone:
    pop dx      ; Giai phong du lieu thanh ghi
    pop cx
    ret
    
quitProgram:
    lea dx, msg_exit
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h
; Doan nay la cach luu so nguyen lon, Phuc voi Hai copy tren mang, khong hieu    
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
    mov ah, 2
    int 21h         
    loop printLoop
    pop dx
    pop cx
    pop bx
    ret
outputDec endp
end main