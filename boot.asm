BITS 16

start:
    mov ax, 07C0h
    add ax, 288
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h
    mov ds, ax

    ; 设置文本模式为80x25
    mov ax, 0x0003
    int 0x10

    ; 设置光标位置
    call set_cursor_position

    ; 无限循环，接收用户输入并显示
    .input_loop:
        mov ah, 0x00
        int 0x16       ; 等待键盘输入
        cmp al, 0x0D   ; 检查是否为Enter键
        je .newline    ; 如果是Enter键，跳转到换行
        mov ah, 0x0E
        int 0x10       ; 显示字符
        jmp .input_loop

    .newline:
        call move_to_next_line
        jmp .input_loop

move_to_next_line:
    ; 获取当前光标位置
    mov ah, 0x03
    mov bh, 0
    int 0x10
    ; 计算下一行的光标位置
    inc dh          ; 行号加1
    mov dl, 0       ; 列号重置为0
    ; 设置新的光标位置
    mov ah, 0x02
    int 0x10
    ret

set_cursor_position:
    ; 设置光标位置为左上角
    mov ah, 0x02
    mov bh, 0
    mov dh, 0       ; 行
    mov dl, 0       ; 列
    int 0x10
    ret

times 510-($-$$) db 0
dw 0xAA55
