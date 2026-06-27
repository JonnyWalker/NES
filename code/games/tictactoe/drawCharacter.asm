
changeCharacterAtNT2X:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA X_Tiles+0
    STA $2007
    LDA X_Tiles+1
    STA $2007

    ;TODO: this hack is only safe for TicTacToe (may cause an overflow in other cases)
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20 
    STA NAME_TABLE_INDEX_LO
        
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA X_Tiles+2
    STA $2007
    LDA X_Tiles+3
    STA $2007   

    ; restore name table address to default
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006

    RTS


changeCharacterAtNT2O:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA O_Tiles+0
    STA $2007
    LDA O_Tiles+1
    STA $2007

    ; TODO: this hack is only safe for TicTacToe
    ; overflow possible for other games
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20 
    STA NAME_TABLE_INDEX_LO
        
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA O_Tiles+2
    STA $2007
    LDA O_Tiles+3
    STA $2007   

    ; restore name table address to default
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006

    RTS

X_Tiles:
   .byte $28, $29, $2A, $2B

O_Tiles:
   .byte $2C, $2D, $2E, $2F