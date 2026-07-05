nesInit:
; wait for vblank
:
    BIT $2002
    BPL :-

    LDA #$02  ; high byte of sprites
    STA $4014
    NOP
    ; $3F00
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
LoadPalettes:
    LDA PaletteData, X
    STA $2007 ; $3F00, $3F01, $3F02 => $3F1F
    INX
    CPX #$20 ; dezi 32
    BNE LoadPalettes    

    LDX #$00
LoadSprites:
    LDA SpriteData, X
    STA $0200, X
    INX
    CPX #$10
    BNE LoadSprites  
; Clear the nametables- this isn't necessary in most emulators unless
; you turn on random memory power-on mode, but on real hardware
; not doing this means that the background / nametable will have
; random garbage on screen. This clears out nametables starting at
; $2000 and continuing on to $2400 (which is fine because we have
; vertical mirroring on. If we used horizontal, we'd have to do
; this for $2000 and $2800)
    LDX #$00
    LDY #$00
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006
ClearNametable:
    STA $2007
    INX
    BNE ClearNametable
    INY
    CPY #$08
    BNE ClearNametable

    ; Enable interrupts
    CLI

    LDA #0
    STA $2005 ; X position (this also sets the w register)
    STA $2005 ; Y position (this also clears the w register)

    RTS 