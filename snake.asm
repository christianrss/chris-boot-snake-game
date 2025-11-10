;; SETUP ------------
org 7C00h

jmp setup_game

;; CONSTANTS

;; VARIABLES

;; LOGIC ------------
setup_game:

;; Bootsector padding
times 510 - ($-$$) db 0

dw 0AA55h