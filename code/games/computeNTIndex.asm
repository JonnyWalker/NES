; TODO: explain magic +3 
; compute name table index from sprite x and y
; 32 columns, 8 pixel each tile
; NameTable Index  
; = ((Y+3)//8)*32+(X//8)
; = ((Y+3)>>3)<<5+(X>>3)
; = ((Y+3)<<2)+(X>>3)
; = (X>>3)+((Y+3)<<2)
; tictactoe.asm: CURSOR_X,CURSOR_Y
; drawTileAtIndex.asm: NAME_TABLE_INDEX_LO, NAME_TABLE_INDEX_HI
spriteXY_To_NameTableIndex:
    ; other subroutines use this zp variables
    LDA #$00
    STA NAME_TABLE_INDEX_LO
    LDA #$00
    STA NAME_TABLE_INDEX_HI

    ; compute HI (first part) by "shifting" Bit 7 and 6
    LDA CURSOR_Y
    AND #%11000000
    LSR
    LSR
    LSR 
    LSR 
    LSR 
    LSR
    ORA #$20
    STA NAME_TABLE_INDEX_HI

    ; compute LOW
    LDA CURSOR_X
    LSR
    LSR 
    LSR
    STA NAME_TABLE_INDEX_LO

    LDA CURSOR_Y
    CLC
    ADC #$03
    ASL
    ASL 
    CLC
    ADC NAME_TABLE_INDEX_LO
    STA NAME_TABLE_INDEX_LO

    ; second part of HI computation
    LDA NAME_TABLE_INDEX_HI
    ADC #$00
    STA NAME_TABLE_INDEX_HI

    RTS