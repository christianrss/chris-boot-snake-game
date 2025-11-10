;; SETUP ------------
org 7C00h

jmp setup_game

;; CONSTANTS
VIDMEM         equ 0B800h
SCREENW        equ 80
SCREENH        equ 25
WINCOND        equ 10
BGCOLOR        equ 1020h
APPLECOLOR     equ 4020h
SNAKECOLOR     equ 2020h
TIMER          equ 046Ch
SNAKEXARRAY    equ 1000h
SNAKEYARRAY    equ 2000h 
UP             equ 0
DOWN           equ 1
LEFT           equ 2
RIGHT          equ 3
;; VARIABLES
playerX:        dw 40
playerY:        dw 12
appleX:         dw 16
appleY:         dw 8
direction:      db 0
snakeLength:    dw 1

;; LOGIC ------------
setup_game:
    ;; Set up video mode - VGA mode 03h(80x25 text mode, 16 colors)
    mov ax, 0003h
    int 10h

    ;; Set up video memory
    mov ax, VIDMEM
    mov es, ax      ; ES:DI <- video memory (0B800:000 or B8000)

    ;; Set 1st snake segment "head"
    mov ax, [playerX]
    mov word [SNAKEXARRAY], ax
    mov ax, [playerY]
    mov word [SNAKEYARRAY], ax

;; Game loop
game_loop:
    ;; Clear screen very loop iteration
    mov ax, BGCOLOR
    xor di, di
    mov cx, SCREENW*SCREENH
    rep stosw                   ; mov [ES:DI], AX & inc di

    ;; Draw snake
    xor bx, bx                  ; Array index
    mov cx, [snakeLength]       ; Loop counter
    mov ax, SNAKECOLOR
    .snake_loop:
        imul di, [SNAKEYARRAY+bx], SCREENW*2    ; Y position of snake segment, 2 bytes per character
        imul dx, [SNAKEXARRAY+bx], 2            ; X position of snake segment, 2 bytes per character
        add di, dx
        stosw
        inc bx
        inc bx
    loop .snake_loop

    ;; Draw apple
    imul di, [appleY], SCREENW*2
    imul dx, [appleX], 2
    add di, dx
    mov ax, APPLECOLOR
    stosw

    ;; Move snake in current direction
    mov al, [direction]
    cmp al, UP
    je move_up
    cmp al, DOWN
    je move_down
    cmp al, LEFT
    je move_left
    cmp al, RIGHT
    je move_right

    jmp update_snake

    move_up:
        dec word [playerY]      ; Move up 1 row on the screen
        jmp update_snake
    move_down:
        inc word [playerY]      ; Move down 1 row on the screen
        jmp update_snake

    move_left:
        dec word [playerX]     ; Move left 1 column on the screen
        jmp update_snake
    move_right:
        inc word [playerX]     ; Move right 1 column on the screen

    ;; Update snake position from playerX/Y changes
    update_snake:
        ;; Update all snake segments past the "head", iterate back to front
        imul bx, [snakeLength], 2   ; each array element = 2 bytes
        .snake_loop:
            mov ax, [SNAKEXARRAY-2+bx]          ; X value
            mov word [SNAKEXARRAY+bx], ax
            mov ax, [SNAKEYARRAY-2+bx]          ; Y value
            mov word [SNAKEYARRAY+bx], ax

            dec bx                              ; Get previous array elem
            dec bx                              ; Stop at first element "head"
        jnz .snake_loop

    ;; Store updated values to head of snakes in arrays
    mov ax, [playerX]
    mov word [SNAKEXARRAY], ax
    mov ax, [playerY]
    mov word [SNAKEYARRAY], ax



    delay_loop:
        mov bx, [TIMER]
        inc bx
        inc bx
        .delay :
            cmp [TIMER], bx
            jl .delay

jmp game_loop

;; Bootsector padding
times 510 - ($-$$) db 0

dw 0AA55h