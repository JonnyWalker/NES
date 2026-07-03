initGame:
   ; move cursor selector tile to first square
   LDA #$1D
   STA CURSOR_Y

   LDA #$1D
   STA $0200
   LDA #$1D
   STA $0204
   LDA #$25
   STA $0208
   LDA #$25
   STA $020C

   LDA #$00
   STA CURSOR_X

   LDA #$00
   STA $0203
   LDA #$08
   STA $0207
   LDA #$00
   STA $020B
   LDA #$08
   STA $020

   LDA #$01
   STA LEVEL_PTR

   RTS