drawBoard:


    LDA #$20
    STA $2006
    LDA #$80
    STA $2006
    
    LDY #$00
drawAll:
    LDX #$00
drawTileTop:
    JSR _levelTileToA
    CMP #$01
    BEQ _1Top
    JSR _drawHiddenTop
    JMP drawTileTopEnd
_1Top:
    JSR _draw1Top
    JMP drawTileTopEnd
drawTileTopEnd:
    INX
    INY
    CPX #$10
    BNE drawTileTop

    ; read line again
    TYA
    SEC
    SBC #$10
    TAY

    LDX #$00
drawTileBottom:
    JSR _levelTileToA
    CMP #$01
    BEQ _1Bottom
    JSR _drawHiddenBottom
    JMP drawTileBottomEnd
_1Bottom:
    JSR _draw1Bottom
    JMP drawTileBottomEnd
drawTileBottomEnd:   
    INX
    INY
    CPX #$10
    BNE drawTileBottom

    ; check if all lines have been drawn
    CPY #$C0
    BEQ EndOfDraw
    JMP drawAll
EndOfDraw:
    RTS


; assumes Y is the pointer
_levelTileToA:
    LDA LEVEL_PTR
    CMP #$01
    BEQ Level1
    CMP #$02
    BEQ Level2
Level1:
    LDA Level01, Y
    RTS
Level2:
    LDA Level02, Y
    RTS

_drawHiddenTop:
    LDA #$50
    STA $2007
    LDA #$51
    STA $2007 
    RTS

_drawHiddenBottom:
    LDA #$60
    STA $2007
    LDA #$61
    STA $2007
    RTS

_draw1Top:
    LDA #$30
    STA $2007
    LDA #$31
    STA $2007 
    RTS

_draw1Bottom:
    LDA #$40
    STA $2007
    LDA #$41
    STA $2007
    RTS
