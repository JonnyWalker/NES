
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

    ;TODO: this hack is only safe for TicTacToe
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
