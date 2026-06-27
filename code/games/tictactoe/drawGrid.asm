; draws games 3x3 (empty) grid
drawGrid:
    LDA #$21  ; start address of grid
    STA $2006
    LDA #$4B
    STA $2006

    LDX #10   ; number of rows
    LDA #$00 
    LDY #$00  ; index in GridData
PrintGrid:
    ; save index of outer loop
    TXA
    PHA
    LDX #10 ; row index 10-X

PrintRow:
    LDA GridData, Y ; write grid data to ppu memory
    STA $2007
    INY
    DEX
    BNE PrintRow

    ; skip next 22 tiles to start a new row
    ; (grid=10 tiles wide. screen=32 and 32-10=22) 
    LDX #22
    LDA #0
BlankRemainingRow:    
    STA $2007
    DEX
    BNE BlankRemainingRow
    
    PLA
    TAX
    DEX
    BNE PrintGrid
    RTS

GridData: ; grid tile numbers
  .byte $39, $31, $31, $35, $31, $31, $35, $31, $31, $3A
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $33, $31, $31, $32, $31, $31, $32, $31, $31, $36 
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $33, $31, $31, $32, $31, $31, $32, $31, $31, $36 
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $30, $00, $00, $30, $00, $00, $30, $00, $00, $30
  .byte $37, $31, $31, $34, $31, $31, $34, $31, $31, $38 
