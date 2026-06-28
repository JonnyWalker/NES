;ca65 minesweeper.asm -o t.o -t nes && ld65 -C nes_big_zp.cfg t.o -o minesweeper.nes
.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02 ; 2 * 16KB PRG ROM
.byte $01 ; 1 * 8KB CHR ROM
.byte %00000001 ; mapper and mirroring
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; filler bytes
.segment "ZEROPAGE" ; LSB 0 - FF (if modified cfg file is used)
CURSOR_X: .byte $00 
CURSOR_Y: .byte $00
LEVEL_PTR: .byte $00
; TODO: move to normal memory
; bit-vector: 0=invisible, 1=visible
; at 16x12 tiles: 2 bytes = one row
VISIBLE: .byte $00, $00, $00, $00, $00, $00, $00, $00 
         .byte $00, $00, $00, $00, $00, $00, $00, $00
         .byte $00, $00, $00, $00, $00, $00, $00, $00
.segment "STARTUP"
Reset:
    SEI ; Disables all interrupts
    CLD ; disable decimal mode

    ; Disable sound IRQ (for some reason everthing is broken without this line)
    LDX #$40
    STX $4017

    ; Initialize the stack register
    LDX #$FF
    TXS

;   INX ; #$FF + 1 => #$00
    LDX #$00

    ; Zero out the PPU registers
    STX $2000
    STX $2001

    STX $4010

:
    BIT $2002 ; wait for vblank
    BPL :-

;     ;TXA
    LDA #$00

CLEARMEM:
    STA $0000, X ; $0000 => $00FF
    STA $0100, X ; $0100 => $01FF
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    LDA #$FF
    STA $0200, X ; $0200 => $02FF
    LDA #$00
    INX
    BNE CLEARMEM    
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

    JSR initGame
    JSR drawBoard

    LDA #%10010000 ; enable NMI change background to use second chr set of tiles ($1000)
    STA $2000
    ; Enabling sprites and background for left-most 8 pixels
    ; Enable sprites and background
    LDA #%00011110
    STA $2001

    ; restore name table address to default
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006

GameLoop:
    ; main game code
    JMP GameLoop

    .include "initGame.asm"
    .include "drawBoard.asm"

NMI:
    PHA 
    TXA
    PHA
    TYA
    PHA

    ; copy sprite data from $0200 => PPU memory for display
    LDA #$02 
    STA $4014

    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

PaletteData: ; maxvalue 0x36
  .byte $3F,$20,$16,$0F, $3F,$10,$1A,$0F, $3F,$30,$21,$0f, $3F,$27,$17,$0F  ;background palette data
  .byte $3F,$1A,$27,$18, $3F,$16,$30,$27, $3F,$16,$30,$27, $3F,$0F,$36,$17  ;sprite palette data

SpriteData: ; Y,Tileindex, ATTR, X
  .byte $08, $01, $00, $08 ; Cursor
  .byte $08, $02, $00, $10
  .byte $10, $03, $00, $08
  .byte $10, $04, $00, $10

Level01:
    .byte $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$01,$0a,$01,$00,$00,$00
    .byte $0a,$01,$00,$01,$02,$02,$01,$01,$01,$01,$02,$02,$02,$00,$00,$00
    .byte $01,$01,$00,$01,$0a,$0a,$01,$01,$0a,$01,$01,$0a,$02,$01,$01,$00
    .byte $00,$00,$00,$02,$03,$03,$01,$01,$01,$01,$01,$01,$02,$0a,$01,$00
    .byte $00,$00,$00,$01,$0a,$02,$01,$01,$01,$01,$01,$00,$01,$01,$01,$00
    .byte $00,$00,$00,$01,$01,$02,$0a,$01,$01,$0a,$01,$01,$01,$02,$01,$01
    .byte $00,$00,$00,$00,$00,$01,$01,$01,$01,$02,$02,$02,$0a,$02,$0a,$01
    .byte $00,$00,$00,$00,$00,$01,$01,$01,$00,$02,$0a,$03,$01,$02,$01,$01
    .byte $00,$00,$00,$00,$01,$02,$0a,$01,$01,$03,$0a,$03,$01,$01,$01,$01
    .byte $00,$00,$00,$00,$01,$0a,$02,$01,$01,$0a,$03,$0a,$01,$01,$0a,$01
    .byte $01,$01,$00,$00,$01,$01,$01,$00,$01,$01,$02,$01,$01,$01,$01,$01
    .byte $0a,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

Level02:
    .byte $00,$00,$01,$0a,$01,$00,$00,$00,$00,$01,$02,$02,$01,$01,$0a,$02
    .byte $00,$00,$01,$01,$01,$00,$00,$01,$01,$02,$0a,$0a,$01,$02,$03,$0a
    .byte $00,$00,$00,$00,$00,$00,$00,$01,$0a,$03,$03,$02,$02,$02,$0a,$02
    .byte $00,$00,$01,$01,$01,$00,$01,$02,$03,$0a,$01,$01,$02,$0a,$02,$01
    .byte $00,$00,$01,$0a,$01,$00,$01,$0a,$02,$01,$01,$01,$0a,$02,$01,$00
    .byte $01,$01,$01,$01,$01,$00,$02,$02,$02,$00,$00,$01,$02,$02,$01,$00
    .byte $0a,$01,$00,$00,$00,$00,$01,$0a,$01,$00,$00,$00,$02,$0a,$02,$00
    .byte $01,$01,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$02,$0a,$02,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$01,$01
    .byte $00,$01,$01,$01,$00,$00,$00,$00,$01,$0a,$02,$01,$01,$00,$01,$0a
    .byte $00,$01,$0a,$01,$00,$00,$00,$00,$01,$01,$02,$0a,$01,$00,$01,$01

.segment "VECTORS"
    .word NMI
    .word Reset
    ; 
.segment "CHARS"
    .incbin "tileset.chr"