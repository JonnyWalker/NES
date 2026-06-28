initGame:
   ; move cursor selector tile to first square
    LDA #$55
    STA CURSOR_Y
    
    LDA #$55
    STA $0200
    LDA #$55
    STA $0204
    LDA #$5D
    STA $0208
    LDA #$5D
    STA $020C

    LDA #$60
    STA CURSOR_X

    LDA #$60
    STA $0203
    LDA #$68
    STA $0207
    LDA #$60
    STA $020B
    LDA #$68
    STA $020F

    LDA #$01
    STA LEVEL_PTR

    ; move cursor selector tile to first square
    LDA #$1D
    STA CURSOR_Y
    
    LDA #$1D
    STA $0200
    LDA #$1D
    STA $0204
    LDA #$25
    STA $0208
    LDA #$25
    STA $020C

    LDA #$00
    STA CURSOR_X

    LDA #$00
    STA $0203
    LDA #$08
    STA $0207
    LDA #$00
    STA $020B
    LDA #$08
    STA $020F

    RTS