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
CURSOR_TILE_PTR: .byte $00 ; the level tile at the cursor location
LEVEL_NUMBER: .byte $00
; FIXME: unused
; bit-vector: 0=invisible, 1=visible
; at 16x12 tiles: 2 bytes = one row
VISIBLE: .byte $00, $00, $00, $00, $00, $00, $00, $00 
         .byte $00, $00, $00, $00, $00, $00, $00, $00
         .byte $00, $00, $00, $00, $00, $00, $00, $00
buttons: .res 1
.segment "STARTUP"
Reset:
    SEI ; Disable all interrupts
    CLD ; Disable decimal mode

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

    JSR nesInit
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
    JSR readjoy
    JSR handleDPad
    LDA buttons
    BEQ NoInput ; dont waste cpu cycles

    ; those subroutines only compute something new
    ; after a user input
    JSR updateCursor ; also updates level pointer
    JSR levelptr_to_NameTableIndex
NoInput:
    ; asure this code only runs once a frame (e.g. for stick timing)
    ; by waiting for the vblank (next code will be NMI)
:
    BIT $2002 ; wait for vblank 
    BPL :-
    JMP GameLoop

    .include "nesInit.asm"
    .include "initGame.asm"
    .include "drawBoard.asm"
    .include "readJoy.asm"
    .include "handleButton.asm"
    .include "updateCursor.asm"
    .include "computeNTIndex.asm"

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

PaletteData: ; max value 0x36
  ;common color: light gray ($10)
  ;background palette data
  .byte $10,$16,$00,$20 ; red,gray,white: hidden tile, flag 
  .byte $10,$19,$00,$12 ; green,gray,blue:   1-tile, 2-tile, 
  .byte $10,$16,$00,$06 ; red,gray,dark red: 3-tile, 4-tile
  .byte $10,$0f,$00,$16 ; black,gray,red: Mine

   ;sprite palette data
  .byte $10,$27,$1A,$18 ; cursor
  .byte $10,$16,$30,$27
  .byte $10,$16,$30,$27
  .byte $10,$0F,$36,$17 

SpriteData: ; Y,Tileindex, ATTR, X
  .byte $08, $01, $00, $08 ; Cursor
  .byte $08, $02, $00, $10
  .byte $10, $03, $00, $08
  .byte $10, $04, $00, $10

LEVEL_01:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$0a,$02,$02,$0a
    .byte $00,$00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$02,$03,$0a,$02,$01
    .byte $00,$01,$01,$01,$00,$00,$01,$0a,$01,$00,$00,$01,$0a,$02,$01,$00
    .byte $00,$01,$0a,$01,$00,$00,$01,$01,$01,$00,$01,$02,$02,$01,$00,$00
    .byte $01,$02,$01,$01,$00,$00,$00,$00,$00,$00,$01,$0a,$01,$00,$00,$00
    .byte $0a,$01,$00,$00,$00,$01,$01,$02,$01,$01,$01,$01,$01,$01,$01,$01
    .byte $01,$02,$01,$01,$01,$02,$0a,$02,$0a,$02,$01,$01,$00,$01,$0a,$01
    .byte $01,$02,$0a,$01,$01,$0a,$02,$02,$01,$02,$0a,$01,$00,$01,$01,$01
    .byte $01,$0a,$02,$01,$01,$02,$02,$01,$00,$01,$01,$01,$00,$00,$00,$00
    .byte $01,$01,$01,$00,$00,$01,$0a,$01,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00
LEVEL_01_COLOR:
    .byte $00,$00,$00,$00,$00,$44,$75,$d5
    .byte $40,$50,$00,$d5,$11,$44,$7e,$15
    .byte $54,$57,$00,$05,$01,$d5,$15,$00
    .byte $57,$50,$54,$75,$75,$55,$45,$75
    .byte $d5,$57,$5d,$55,$45,$57,$04,$05
    .byte $05,$01,$44,$57,$00,$00,$00,$00
LEVEL_02:
    .byte $00,$00,$00,$00,$01,$0a,$02,$02,$0a,$01,$00,$00,$00,$00,$01,$01
    .byte $00,$00,$00,$00,$01,$02,$0a,$02,$01,$01,$00,$00,$01,$01,$02,$0a
    .byte $00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$00,$01,$0a,$02,$01
    .byte $01,$01,$00,$00,$00,$01,$02,$02,$01,$00,$01,$01,$02,$01,$01,$00
    .byte $0a,$01,$00,$00,$00,$01,$0a,$0a,$01,$01,$02,$0a,$01,$00,$00,$00
    .byte $01,$02,$01,$01,$00,$02,$03,$03,$01,$01,$0a,$02,$01,$00,$00,$00
    .byte $00,$01,$0a,$01,$00,$01,$0a,$01,$00,$01,$01,$02,$01,$01,$00,$00
    .byte $01,$02,$01,$01,$00,$01,$01,$01,$00,$00,$00,$01,$0a,$01,$00,$00
    .byte $0a,$01,$00,$00,$00,$00,$00,$01,$01,$01,$00,$01,$01,$01,$00,$00
    .byte $01,$01,$00,$00,$00,$00,$01,$02,$0a,$01,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$01,$01,$01,$01,$0a,$02,$01,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$01,$0a,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00
LEVEL_02_COLOR:
    .byte $00,$00,$5d,$75,$57,$00,$50,$d5
    .byte $50,$00,$44,$55,$10,$50,$5d,$15
    .byte $57,$50,$44,$af,$55,$7d,$11,$00
    .byte $54,$57,$44,$57,$04,$45,$75,$00
    .byte $57,$00,$00,$54,$75,$04,$05,$00
    .byte $00,$44,$75,$5d,$15,$00,$00,$00

.segment "VECTORS"
    .word NMI
    .word Reset
    ; 
.segment "CHARS"
    .incbin "tileset.chr"