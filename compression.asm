;--------------------------------------------------------------------------------
ParadoxCaveGfxFix:
    ; Always upload line unless you're moving into paradox cave (0x0FF) from above (0x0EF)
    LDA $1B : BEQ .uploadLine
    LDX $A0 : CPX #$00FF : BNE .uploadLine
    LDX $A2 : CPX #$00EF : BNE .uploadLine

    ;Ignore uploading four specific lines of tiles to VRAM
    LDX $0118
    ; Line 1
    CPX #$1800 : BEQ .skipMostOfLine
    ; Line 2
    CPX #$1A00 : BEQ .skipMostOfLine
    ; Line 3
    CPX #$1C00 : BEQ .uploadLine
    ; Line 4
    CPX #$1E00 : BEQ .uploadLine

.uploadLine
    LDA.b #$01 : STA $420B

.skipLine
    RTL

.skipMostOfLine
    ; Set line length to 192 bytes (the first 6 8x8 tiles in the line)
    LDX.w #$00C0 : STX $4305
    BRA .uploadLine
;--------------------------------------------------------------------------------
