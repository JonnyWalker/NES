initGame:
    ; move selector tile to first square
    LDA #$55
    STA CURSOR_Y
    LDA #$60
    STA CURSOR_X
    LDA #$00
    STA CURSOR_PLAETTE

    ; set game state to empty
    LDA #$00
    STA STATE
    STA STATE+1
    STA STATE+2
    STA STATE+3
    STA STATE+4
    STA STATE+5
    STA STATE+6
    STA STATE+7
    STA STATE+8
    STA STATE_POINTER

    ; draw empty grid
    LDX #$00
EmptyLoop:
    LDA Location, X
    STA $2006
    LDA Location+1, X
    STA $2006
    LDA #$00
    STA $2007
    INX
    INX
    CPX #(8*9)
    BNE EmptyLoop
    RTS

Location: ; HI-Byte, LO-Byte for register $2006
   .byte $21, $6C, $21, $6D, $21, $8C, $21, $8D ; left top
   .byte $21, $6F, $21, $70, $21, $8F, $21, $90 ; middle top
   .byte $21, $72, $21, $73, $21, $92, $21, $93 ; right top

   .byte $21, $CC, $21, $CD, $21, $EC, $21, $ED ; left middle
   .byte $21, $CF, $21, $D0, $21, $EF, $21, $F0 ; middle middle
   .byte $21, $D2, $21, $D3, $21, $F2, $21, $F3 ; right middle

   .byte $22, $2C, $22, $2D, $22, $4C, $22, $4D ; left bottom
   .byte $22, $2F, $22, $30, $22, $4F, $22, $50 ; middle bottom
   .byte $22, $32, $22, $33, $22, $52, $22, $53 ; right bottom
