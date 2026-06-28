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
    CMP #$02
    BEQ _2Top
    CMP #$03
    BEQ _3Top
    CMP #$04
    BEQ _4Top
    CMP #$0A
    BEQ _MineTop
    JSR _drawHiddenTop
    JMP drawTileTopEnd
_1Top:
    JSR _draw1Top
    JMP drawTileTopEnd
_2Top:
    JSR _draw2Top
    JMP drawTileTopEnd
_3Top:
    JSR _draw3Top
    JMP drawTileTopEnd
_4Top:
    JSR _draw4Top
    JMP drawTileTopEnd
_MineTop:
    JSR _drawMineTop
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
    CMP #$02
    BEQ _2Bottom
    CMP #$03
    BEQ _3Bottom
    CMP #$04
    BEQ _4Bottom
    CMP #$0A
    BEQ _MineBottom
    JSR _drawHiddenBottom
    JMP drawTileBottomEnd
_1Bottom:
    JSR _draw1Bottom
    JMP drawTileBottomEnd
_2Bottom:
    JSR _draw2Bottom
    JMP drawTileBottomEnd
_3Bottom:
    JSR _draw3Bottom
    JMP drawTileBottomEnd
_4Bottom:
    JSR _draw4Bottom
    JMP drawTileBottomEnd
_MineBottom:
    JSR _drawMineBottom
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
    ; TODO: check VISIBEL bit array at pos Y
    ; return empty tile if the tile is not visible
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

_drawMineTop:
    LDA #$54
    STA $2007
    LDA #$55
    STA $2007 
    RTS

_drawMineBottom:
    LDA #$64
    STA $2007
    LDA #$65
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

_draw2Top:
    LDA #$32
    STA $2007
    LDA #$33
    STA $2007 
    RTS

_draw2Bottom:
    LDA #$42
    STA $2007
    LDA #$43
    STA $2007
    RTS

_draw3Top:
    LDA #$34
    STA $2007
    LDA #$35
    STA $2007 
    RTS

_draw3Bottom:
    LDA #$44
    STA $2007
    LDA #$45
    STA $2007
    RTS

_draw4Top:
    LDA #$36
    STA $2007
    LDA #$37
    STA $2007 
    RTS

_draw4Bottom:
    LDA #$46
    STA $2007
    LDA #$47
    STA $2007
    RTS