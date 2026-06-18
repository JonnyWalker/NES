STICKY_TIME = $20 ; arbitrary value
RIGHTMOST_CURSOR = $90
LEFTMOST_CURSOR = $60
LOWEST_CURSOR = $85
HIGHEST_CURSOR = $55

handleButton:
    LDA buttons
    BEQ NoButtonHandled ; If no button pressed reset Sticky time

    LDX STICKYINPUT     ; Handle next button when sticky time is over
    BEQ BUTTONHANDLER
    DEX                 ; dec stick time
    STX STICKYINPUT
    JMP EndButton
    
BUTTONHANDLER:
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

    LDA buttons
    AND #%10000000
    BNE A_BUTTON
    JMP EndButton

MOVE_DOWN:
    ; only move down if not at lowest row of grid
    LDA CURSOR_Y
    CMP #(LOWEST_CURSOR)
    BEQ ButtonHandled

    LDA CURSOR_Y
    CLC
    ADC #$18
    STA CURSOR_Y
    JMP ButtonHandled

MOVE_UP:
    ; only move up if not at highest row of grid
    LDA CURSOR_Y
    CMP #(HIGHEST_CURSOR)
    BEQ ButtonHandled

    LDA CURSOR_Y
    SEC
    SBC #$18
    STA CURSOR_Y
    JMP ButtonHandled

MOVE_RIGHT:
    ; only move right if not at the most right column of grid
    LDA CURSOR_X
    CMP #(RIGHTMOST_CURSOR)
    BEQ ButtonHandled

    LDA CURSOR_X
    CLC
    ADC #$18
    STA CURSOR_X
    JMP ButtonHandled

MOVE_LEFT:
    ; only move left if not at the most left column of grid
    LDA CURSOR_X
    CMP #(LEFTMOST_CURSOR)
    BEQ ButtonHandled

    LDA CURSOR_X
    SEC
    SBC #$18
    STA CURSOR_X
    JMP ButtonHandled

A_BUTTON:
    LDA CURSOR_PLAETTE
    BEQ SwitchToPalette01
    LDA #$00
    STA CURSOR_PLAETTE
    JMP ButtonHandled

SwitchToPalette01:
    LDA #$01
    STA CURSOR_PLAETTE
    JMP ButtonHandled

NoButtonHandled:
    ; Reset Sticky Time.
    LDX #$00
    STX STICKYINPUT
    JMP EndButton
    
ButtonHandled:
    ; Increase Sticky Time.
    LDX #(STICKY_TIME)
    STX STICKYINPUT
EndButton:    
    RTS
