
; compute the corresponding tile (upper left)
; in the name table of a level pointer value i.
; The level pointer points to the data in the hard 
; coded level (e.g. LEVEL_01: in minesweeper.asm).
;
; Because we can only use 8-Bit values, we have to
; distinguish 4 cases / memory areas in the NT: 
; $2000-$20FF, $2100-$21FF, $2200-$22FF, $2300-$23FF
;
; First set the index register to an index in one of those four
; memory areas by evaluating the value of the level pointer:
; 0-31:$2000, 32-95:$2100, 96-159:$2200, 160-191:$2300
; by subtracting 160, 96, 32 or nothing so the index starts at 0.
;
; Note that one line in the NT is 32 tiles wide:
; move the pointer by j*32 tiles with j = i div 16 to skip rows.
;
; And also note that the first area starts at $2080 because the 
; minesweeper field does NOT start at the top left corner 
; at $2000, but at $2080. Because of that the first
; index region is only 32 bytes wide (0-31), while the other
; regions are 64 bytes wide.
;
; The mem area start must also be hard coded, because we
; have no addressing mode for 16-Bit variables.
; the following Python code describes the computation:
;
;def magic(i): # i is the level index ptr
;    if i>=160:
;        i=i-160
;        start = 0x2300
;    elif i>=96:
;        i=i-96
;        start = 0x2200
;    elif i>=32:
;        i=i-32
;        start = 0x2100
;    else:
;        start = 0x2080
;    # j = number of lines to be skiped (i // 16)
;    j=i>>4 
;    # i: every entry is i*2 tile wide (2x2 meta tile)
;    # j: skip 32 lines for each level pointer line (2x2 meta tile)
;    return hex(start+i*2+j*32)
; 
; The subroutine sets the name table pointer HIGH to: 
; to either $20, $21, $22 or $23
; and the LOW part to i*2+j*32
levelptr_to_NameTableIndex:
    ; TODO: port Python code to assembly :D
    RTS