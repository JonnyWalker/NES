; parameter: ASCII value in X
; check STATE
; 0 1 2
; 3 4 5
; 6 7 8
checkAndSetWinner:
    ; dont check if a character will be drawn next frame
    LDA DRAW_CHARATER_NEXT_FRAME
    BEQ DoCheck
    JMP EndCheck 

DoCheck:
    ; dont check if we have a winner
    LDA WINNER
    BEQ StartCheck
    JMP EndCheck
    
StartCheck:
    ; check 
    ; 0 1 2
    ;
    ;
    CPX STATE
    BNE NextCheck0
    CPX STATE+1
    BNE NextCheck0
    CPX STATE+2 
    BNE NextCheck0
    TXA
    STA WINNER
    JMP EndCheck
NextCheck0:
    ; check 
    ; 
    ; 3 4 5
    ;
    CPX STATE+3
    BNE NextCheck1
    CPX STATE+4
    BNE NextCheck1
    CPX STATE+5 
    BNE NextCheck1
    TXA
    STA WINNER
    JMP EndCheck
NextCheck1:
    ; check 
    ; 
    ; 
    ; 6 7 8
    CPX STATE+6
    BNE NextCheck2
    CPX STATE+7
    BNE NextCheck2
    CPX STATE+8 
    BNE NextCheck2
    TXA
    STA WINNER
    JMP EndCheck
NextCheck2:
    ; check 
    ; 0
    ; 3
    ; 6 
    CPX STATE
    BNE NextCheck3
    CPX STATE+3
    BNE NextCheck3
    CPX STATE+6 
    BNE NextCheck3
    TXA
    STA WINNER
    JMP EndCheck
NextCheck3:
    ; check 
    ;   1
    ;   4
    ;   7 
    CPX STATE+1
    BNE NextCheck4
    CPX STATE+4
    BNE NextCheck4
    CPX STATE+7 
    BNE NextCheck4
    TXA
    STA WINNER
    JMP EndCheck
NextCheck4:
    ; check 
    ;     2
    ;     5
    ;     8 
    CPX STATE+2
    BNE NextCheck5
    CPX STATE+5
    BNE NextCheck5
    CPX STATE+8 
    BNE NextCheck5
    TXA
    STA WINNER
    JMP EndCheck
NextCheck5:
    ; check 
    ; 0  
    ;   4 
    ;     8 
    CPX STATE
    BNE NextCheck6
    CPX STATE+4
    BNE NextCheck6
    CPX STATE+8 
    BNE NextCheck6
    TXA
    STA WINNER
    JMP EndCheck
NextCheck6:
    ; check 
    ;     2
    ;   4 
    ; 6    
    CPX STATE+2
    BNE EndCheck
    CPX STATE+4
    BNE EndCheck
    CPX STATE+6 
    BNE EndCheck
    TXA
    STA WINNER
    JMP EndCheck

EndCheck:
    RTS