; TODO: explain magic +3  and magic -1
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

    ; TODO: compute HI 

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

    RTS