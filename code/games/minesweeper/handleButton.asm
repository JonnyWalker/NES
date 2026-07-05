.segment "ZEROPAGE"
; frame counter; Only one input per click
STICKYINPUT: .byte $00 
.segment "STARTUP"
STICKY_TIME = $08 ; arbitrary number of frames to wait for next input
RIGHTMOST_CURSOR = $F0
LEFTMOST_CURSOR = $00
LOWEST_CURSOR = $CD
HIGHEST_CURSOR = $1D
MINE_VALUE = $0a
MINE_TILE_VALUE = $54      ; upper left of 2x2 meta tile
INVISIBLE_TILE_VALUE = $50 ; upper left of 2x2 meta tile
FLAG_TILE_VALUE = $52      ; upper left of 2x2 meta tile

handleDPad:
    LDA buttons
    BEQ NoDPadHandled   ; If no button pressed reset Sticky time

    LDX STICKYINPUT     ; Handle next button when sticky time is over
    BEQ DPAD_HANDLER
    DEX                 ; dec stick time
    STX STICKYINPUT
    JMP EndDPAD
    
DPAD_HANDLER:
    AND #%00000100
    BNE MOVE_DOWN
    
    LDA buttons
    AND #%00001000
    BNE MOVE_UP 

    LDA buttons
    AND #%00000001
    BNE MOVE_RIGHT

    LDA buttons
    AND #%00000010
    BNE MOVE_LEFT
    JMP EndDPAD

MOVE_DOWN:
    ; only move down if not at lowest row of grid
    LDA CURSOR_Y
    CMP #(LOWEST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_Y
    CLC
    ADC #$10
    STA CURSOR_Y
    LDA CURSOR_TILE_PTR
    CLC 
    ADC #$10
    STA CURSOR_TILE_PTR
    
    JMP DPadHandled

MOVE_UP:
    ; only move up if not at highest row of grid
    LDA CURSOR_Y
    CMP #(HIGHEST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_Y
    SEC
    SBC #$10
    STA CURSOR_Y
    LDA CURSOR_TILE_PTR
    SEC 
    SBC #$10
    STA CURSOR_TILE_PTR

    JMP DPadHandled

MOVE_RIGHT:
    ; only move right if not at the most right column of grid
    LDA CURSOR_X
    CMP #(RIGHTMOST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_X
    CLC
    ADC #$10
    STA CURSOR_X
    LDA CURSOR_TILE_PTR
    ClC 
    ADC #$01
    STA CURSOR_TILE_PTR

    JMP DPadHandled

MOVE_LEFT:
    ; only move left if not at the most left column of grid
    LDA CURSOR_X
    CMP #(LEFTMOST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_X
    SEC
    SBC #$10
    STA CURSOR_X
    LDA CURSOR_TILE_PTR
    SEC 
    SBC #$01
    STA CURSOR_TILE_PTR
    
    JMP DPadHandled

NoDPadHandled:
    ; Reset Sticky Time.
    LDX #$00
    STX STICKYINPUT
    JMP EndDPAD
    
DPadHandled:
    ; Increase Sticky Time.
    LDX #(STICKY_TIME)
    STX STICKYINPUT
EndDPAD:    
    RTS

; assume inside NMI
handleButton:
    LDA buttons
    BEQ NoButtonHandled ; If no button pressed reset Sticky time

    LDX STICKYINPUT     ; Handle next button when sticky time is over
    BEQ BUTTON_HANDLER
    JMP EndBUTTON

BUTTON_HANDLER:   
    LDA buttons
    AND #%10000000
    BNE A_BUTTON

    LDA buttons
    AND #%01000000
    BNE B_BUTTON

    JMP EndBUTTON

A_BUTTON:
    JSR handleAButton
    JMP ButtonHandled

B_BUTTON:
    JSR handleBButton
    JMP ButtonHandled

NoButtonHandled:
    ; Reset Sticky Time.
    LDX #$00
    STX STICKYINPUT
    JMP EndBUTTON
    
ButtonHandled:
    ; Increase Sticky Time.
    LDX #(STICKY_TIME)
    STX STICKYINPUT
EndBUTTON:
    RTS

handleAButton:
    ; reveal empty tile
    LDY CURSOR_TILE_PTR
    JSR _levelTileToA
    CMP #$00
    BEQ drawEmpty
    
    ; check if cursor is on mine tile
    LDY CURSOR_TILE_PTR
    JSR _levelTileToA
    CMP #(MINE_VALUE)
    BEQ drawMineExplode

    RTS
drawMineExplode:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA #$56
    STA $2007
    LDA #$57
    STA $2007

    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20
    STA $2006   
    LDA #$66
    STA $2007
    LDA #$67
    STA $2007  
    RTS

drawEmpty:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA #$5A
    STA $2007
    LDA #$5B
    STA $2007

    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20
    STA $2006   
    LDA #$6A
    STA $2007
    LDA #$6B
    STA $2007  
    RTS

handleBButton:
    ; check if flag 
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA $2007
    CMP #(FLAG_TILE_VALUE)
    BEQ removeFlag

    ; check if not visible 
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA $2007

    CMP #(INVISIBLE_TILE_VALUE)
    BEQ drawFlag

    RTS

drawFlag:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA #$52
    STA $2007
    LDA #$53
    STA $2007

    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20
    STA $2006   
    LDA #$62
    STA $2007
    LDA #$63
    STA $2007  
    RTS

removeFlag:
    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    STA $2006
    LDA #$50
    STA $2007
    LDA #$51
    STA $2007

    LDA NAME_TABLE_INDEX_HI
    STA $2006
    LDA NAME_TABLE_INDEX_LO
    CLC
    ADC #$20
    STA $2006   
    LDA #$60
    STA $2007
    LDA #$61
    STA $2007  
    RTS
