drawWinner:
    LDA #$20
    STA $2006
    LDA #$E9
    STA $2006
    LDA #$1D ; T
    STA $2007
    LDA #$11 ; H
    STA $2007
    LDA #$0E ; E
    STA $2007
    LDA #$00
    STA $2007
    LDA #$20 ; W
    STA $2007
    LDA #$12 ; I
    STA $2007
    LDA #$17 ; N
    STA $2007
    LDA #$17 ; N
    STA $2007
    LDA #$0E ; E
    STA $2007
    LDA #$1B ; R
    STA $2007
    LDA #$00
    STA $2007
    LDA #$12 ; I
    STA $2007
    LDA #$1C ; S
    STA $2007
    LDA #$00 
    STA $2007
    
    LDX WINNER
    CPX #(X_ASCII_VALUE)
    BEQ WinnerX
    LDA #$18
    STA $2007
    JMP EndWinner
WinnerX:
    LDA #$21
    STA $2007
EndWinner:   
    RTS 