.segment "ZEROPAGE"

NAME_TABLE_INDEX_HI: .byte $00
NAME_TABLE_INDEX_LO: .byte $00

.segment "STARTUP"

; Parameter: Tile Number in X, Index in zero page variables
DrawTileAtIndex:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    TXA
    STA $2007
    RTS