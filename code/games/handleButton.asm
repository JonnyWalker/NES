STICKY_TIME = $20 ; arbitrary number of frames to wait for next input
RIGHTMOST_CURSOR = $90
LEFTMOST_CURSOR = $60
LOWEST_CURSOR = $85
HIGHEST_CURSOR = $55

handleDPad:
    LDA buttons
    BEQ NoDPadHandled ; If no button pressed reset Sticky time

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
    ADC #$18
    STA CURSOR_Y
    
    JMP DPadHandled

MOVE_UP:
    ; only move up if not at highest row of grid
    LDA CURSOR_Y
    CMP #(HIGHEST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_Y
    SEC
    SBC #$18
    STA CURSOR_Y
    JMP DPadHandled

MOVE_RIGHT:
    ; only move right if not at the most right column of grid
    LDA CURSOR_X
    CMP #(RIGHTMOST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_X
    CLC
    ADC #$18
    STA CURSOR_X
    JMP DPadHandled

MOVE_LEFT:
    ; only move left if not at the most left column of grid
    LDA CURSOR_X
    CMP #(LEFTMOST_CURSOR)
    BEQ DPadHandled

    LDA CURSOR_X
    SEC
    SBC #$18
    STA CURSOR_X
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
    JMP EndBUTTON

A_BUTTON:
    ; game logic: only draw on empty tiles
    LDX STATE_POINTER
    LDA STATE, X
    ; skip when state is not $00 (which means empty)
    BNE EndBUTTON

    LDA #$01
    STA DRAW_CHARATER_NEXT_FRAME

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
    JMP EndBUTTON
    
ButtonHandled:
    ; Increase Sticky Time.
    LDX #(STICKY_TIME)
    STX STICKYINPUT
EndBUTTON:
    RTS
