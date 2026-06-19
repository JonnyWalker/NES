; Draw X, O or nothing at row of register x and y
drawCharacter:

    LDY #$00       ; location index in Location table
DrawLoop:
    CPY #$00
    BEQ COLUMN0_X_CHECK
    CPY #$08
    BEQ COLUMN1_X_CHECK
    CPY #$10
    BEQ COLUMN2_X_CHECK
    CPY #$18
    BEQ COLUMN3_X_CHECK
    CPY #$20
    BEQ COLUMN4_X_CHECK
    CPY #$28
    BEQ COLUMN5_X_CHECK
    CPY #$30
    BEQ COLUMN6_X_CHECK
    CPY #$38
    BEQ COLUMN7_X_CHECK
    CPY #$40
    BEQ COLUMN8_X_CHECK
    JMP EndDraw ; full row has been drawn
COLUMN0_X_CHECK:
    LDA STATE
    AND #%01000000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN1_X_CHECK:
    LDA STATE
    AND #%00010000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN2_X_CHECK:
    LDA STATE
    AND #%00000100 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN3_X_CHECK:
    LDA STATE+1
    AND #%01000000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN4_X_CHECK:
    LDA STATE+1
    AND #%00010000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN5_X_CHECK:
    LDA STATE+1
    AND #%00000100 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN6_X_CHECK:
    LDA STATE+2
    AND #%01000000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN7_X_CHECK:
    LDA STATE+2
    AND #%00010000 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
COLUMN8_X_CHECK:
    LDA STATE+2
    AND #%00000100 ; check for X
    BEQ NO_X_DRAW
    JMP DRAW_X
NO_X_DRAW:
    JMP NO_X
DRAW_X:
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX X_Tiles ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX X_Tiles+1 ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX X_Tiles+2 ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX X_Tiles+3 ; tile number
    JSR DrawTileAtIndex

    JMP DrawLoop ; dont check for o or nothing
NO_X:
    CPY #$00
    BEQ COLUMN0_O_CHECK
    CPY #$08
    BEQ COLUMN1_O_CHECK
    CPY #$10
    BEQ COLUMN2_O_CHECK
    CPY #$18
    BEQ COLUMN3_O_CHECK
    CPY #$20
    BEQ COLUMN4_O_CHECK
    CPY #$28
    BEQ COLUMN5_O_CHECK
    CPY #$30
    BEQ COLUMN6_O_CHECK
    CPY #$38
    BEQ COLUMN7_O_CHECK
    CPY #$40
    BEQ COLUMN8_O_CHECK
    JMP EndDraw ; full row has been drawn
COLUMN0_O_CHECK:
    LDA STATE
    AND #%10000000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN1_O_CHECK:
    LDA STATE
    AND #%00100000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN2_O_CHECK:
    LDA STATE
    AND #%00001000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN3_O_CHECK:
    LDA STATE+1
    AND #%10000000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN4_O_CHECK:
    LDA STATE+1
    AND #%00100000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN5_O_CHECK:
    LDA STATE+1
    AND #%00001000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN6_O_CHECK:
    LDA STATE+2
    AND #%10000000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN7_O_CHECK:
    LDA STATE+2
    AND #%00100000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
COLUMN8_O_CHECK:
    LDA STATE+2
    AND #%00001000 ; check for O
    BEQ NO_O_DRAW
    JMP DRAW_O
NO_O_DRAW:
    JMP NO_O
DRAW_O:   
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX O_Tiles ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX O_Tiles+1 ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX O_Tiles+2 ; tile number
    JSR DrawTileAtIndex

    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_HI
    LDA Location, Y
    INY
    STA NAME_TABLE_INDEX_LO
    LDX O_Tiles+3 ; tile number
    JSR DrawTileAtIndex
    JMP DrawLoop ; dont check nothing
NO_O: ; nothing case
    INY
    INY 
    INY
    INY
    INY
    INY
    INY
    INY
    JMP DrawLoop
EndDraw:

    ;LDA #$2
    ;STA METATILE_H
    ;STA METATILE_W
    

    ;JSR DrawMetatile


    ; Calculate Byte index für Row X. It is (X-1)



    ;LDA #$20
    ;LDX #4
    ;LDY #8
    ;JSR DrawMetatile


;    LDA #$20
;    LDX #7
;    LDY #8
;    JSR DrawMetatile
;    LDY #4
;    JSR DrawMetatile
;
;    LDY #8
;    JSR DrawMetatile
;
    ;LDY #16
    ;JSR DrawMetatile
;
    ;LDX #16
    ;JSR DrawMetatile

    rts

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
