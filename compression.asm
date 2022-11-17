;--------------------------------------------------------------------------------
ParadoxCaveGfxFix:
    ; Always upload line unless you're moving into paradox cave (0x0FF) from above (0x0EF)
    LDA.b $1B : BEQ .uploadLine
    LDX.b RoomIndex : CPX.w #$00FF : BNE .uploadLine
    LDX.b $A2 : CPX.w #$00EF : BNE .uploadLine

    ;Ignore uploading four specific lines of tiles to VRAM
    LDX.w $0118
    ; Line 1
    CPX.w #$1800 : BEQ .skipMostOfLine
    ; Line 2
    CPX.w #$1A00 : BEQ .skipMostOfLine
    ; Line 3
    CPX.w #$1C00 : BEQ .uploadLine
    ; Line 4
    CPX.w #$1E00 : BEQ .uploadLine

.uploadLine
    LDA.b #$01 : STA.w MDMAEN

.skipLine
    RTL

.skipMostOfLine
    ; Set line length to 192 bytes (the first 6 8x8 tiles in the line)
    LDX.w #$00C0 : STX.w DAS0L
    BRA .uploadLine
;--------------------------------------------------------------------------------
