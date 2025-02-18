[org 0x0100]

jmp start

snakeheadpos: dw 1922
snaketailpos: dw 0
applepos: dw 2000
applecount: db 0
gameend: db 0
snakedirection: db 0;1 for up,2 for down,3 for left and 4 for right
snakesize: db 1
randNum: dw 0;
snakebuffer: dw 1922,0,0,0,0,0,0
    borders:
        push ax
        push cx
        push es
        push di

        mov ax, 0xb800
        mov es, ax
        xor di, di

        ; Draw top border
        mov cx, 80
    draw_top_border:
        mov al, 0x5f
        mov ah, 0x11
        rep stosw

        ; Draw bottom border
        mov di, 3840
        mov cx, 80
    draw_bottom_border:
        mov al, 0x5f
        mov ah, 0x11
        rep stosw
        

        ; Draw left and right borders
        mov di, 0
        mov cx, 25
	leftborders:
        mov al, 0x5f
        mov ah, 0x11
        stosw
		sub di,2
        add di, 160
		loop leftborders
		
		
		mov cx,25
		mov di,158
	rightborders:
        mov al, 0x5f
        mov ah, 0x11
        stosw
		sub di,2
        add di, 160
        loop rightborders

        pop di
        pop es
        pop cx
        pop ax
        ret

    gameboard:
        call borders

        push ax
        push es
        push di

        mov ax, 0xb800
        mov es, ax
        mov di, 1922
        mov al, 'O'
        mov ah, 0x0F
        stosw

        mov di, 2000
        mov ah, 0x8C
        mov al, 'X'
        stosw

        pop di
        pop es
        pop ax
        ret
		
	GenRandNum:
    push cx
    push ax
    push dx;

    MOV AH, 00h ; interrupts to get system time
    INT 1AH ; CX:DX now hold number of clock ticks since midnight
    mov ax, dx
    xor dx, dx
    mov cx, 4000;
    div cx ; here dx contains the remainder of the division - from 0 to 9

    add dl, '0' ; to ascii from '0' to '9' 

    mov word[randNum],dx;


     pop dx;
     pop ax;
     pop cx;
     ret	
		
	
	applecheck:
	push ax
	
	mov ax,[snakeheadpos]
	cmp ax,[applepos]
	jne endapplecheck
	
	call GenRandNum
	
	mov ax,[randNum]
	mov word[applepos],ax
	
	call printapple
	
	endapplecheck:
	pop ax
	ret
	
	
	 moveindirection:
	 cmp byte[snakedirection],1
	 je upmove
	 
	 cmp byte[snakedirection],2
	 je downmove
	
	 cmp byte[snakedirection],3
	 je leftmove
	 
	 cmp byte[snakedirection],4
	 je rightmove
	 
	 jmp checkkeys
	 
	 upmove:
	 sub word[snakeheadpos],160
	 jmp checkkeys
	 
	 downmove:
	 add word[snakeheadpos],160
	 jmp checkkeys
	 
	 leftmove:
	 sub word[snakeheadpos],2
	 jmp checkkeys
		
	 rightmove:
	 add word[snakeheadpos],2
		
    checkkeys:
        push ax
		push bx;checks if any key is detected, if not loop restarts
        mov ah, 0
        int 0x16
		
		mov bx,0
		
		cmp ah, 0x01
		je escape

        cmp ah, 0x48
        je up

        cmp ah, 0x4b
        je left

        cmp ah, 0x4d
        je right

        cmp ah, 0x50
        je down

		jmp endkeys
		
	escape:
	mov byte[gameend],1
	jmp endkeys
	
    up:
        mov ax, [snakeheadpos]
        sub ax, 160
        mov [snakeheadpos], ax
		mov byte[snakedirection],1
		mov bx,1
		call clearscn
		call updatelocationhead
		call applecheck
        jmp endkeys

    left:
        mov ax, [snakeheadpos]
        sub ax, 2
        mov [snakeheadpos], ax
		mov byte[snakedirection],3
		mov bx,1
		call clearscn
		call updatelocationhead
		call applecheck
        jmp endkeys

    right:
        mov ax, [snakeheadpos]
        add ax, 2
        mov [snakeheadpos], ax
		mov byte[snakedirection],4
		mov bx,1
		call clearscn
		call updatelocationhead
		call applecheck
        jmp endkeys

    down:
        mov ax, [snakeheadpos]
        add ax, 160
        mov [snakeheadpos], ax
		mov byte[snakedirection],2
		mov bx,1
		call clearscn
		call updatelocationhead
		call applecheck

    endkeys:
	    pop bx
        pop ax
        ret
		
	clearscn:
	push ax
	push cx
	push es
	push di
	
	mov ax,0xb800
	mov es,ax
	
	mov di,0
	mov cx,2000
	mov ax,0x0720
	rep stosw
	
	call borders
	call printapple
	pop di
	pop es
	pop cx
	pop ax
ret


    printapple:
    push ax
	push es
	push di
	
	mov ax,0xb800
	mov es,ax
	mov di,[applepos]
	
	mov ah, 0x8C
    mov al, 'X'
	
	stosw
	
	pop di
	pop es
	pop ax
	ret
	
    updatelocationhead:
        push ax
        push bx
        push es
        push di

        mov ax, 0xb800
        mov es, ax
        mov di, [snakeheadpos]
        mov al, 'O'
        mov ah, 0x0f
        mov word[es:di],ax
        pop di
        pop es
        pop bx
        pop ax
        ret
	 
	 
 
    start:
	    call clearscn
        call gameboard
		mov word[snakeheadpos],1922
		mov word[applepos],2000
		mov byte[snakedirection],4
		

    gameloop:
        call checkkeys
		cmp byte[gameend],1
        jne gameloop

    end:
        mov ax, 0x4c00
        int 0x21