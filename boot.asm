BITS 16

start:
    mov ax, 07C0h
    add ax, 288
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h
    mov ds, ax

    ; �����ı�ģʽΪ80x25
    mov ax, 0x0003
    int 0x10

    ; ���ù��λ��
    call set_cursor_position

    ; ����ѭ���������û����벢��ʾ
    .input_loop:
        mov ah, 0x00
        int 0x16       ; �ȴ���������
        cmp al, 0x0D   ; ����Ƿ�ΪEnter��
        je .newline    ; �����Enter������ת������
        mov ah, 0x0E
        int 0x10       ; ��ʾ�ַ�
        jmp .input_loop

    .newline:
        call move_to_next_line
        jmp .input_loop

move_to_next_line:
    ; ��ȡ��ǰ���λ��
    mov ah, 0x03
    mov bh, 0
    int 0x10
    ; ������һ�еĹ��λ��
    inc dh          ; �кż�1
    mov dl, 0       ; �к�����Ϊ0
    ; �����µĹ��λ��
    mov ah, 0x02
    int 0x10
    ret

set_cursor_position:
    ; ���ù��λ��Ϊ���Ͻ�
    mov ah, 0x02
    mov bh, 0
    mov dh, 0       ; ��
    mov dl, 0       ; ��
    int 0x10
    ret

times 510-($-$$) db 0
dw 0xAA55
