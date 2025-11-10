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

;; VARIABLES
playerX:        dw 40
playerY:        dw 12
appleX:         dw 16
appleY:         dw 8
direction:      db 4
snakeLength:    dw 1

;; LOGIC ------------
setup_game:
    ;; Set up video mode - VGA mode 03h(80x25 text mode, 16 colors)
    mov ax, 0003h
    int 10h

;; Bootsector padding
times 510 - ($-$$) db 0

dw 0AA55h