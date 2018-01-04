BgGraphicsLoading:
    ; Instructions overwritten
    STZ $00
    STX $01
    STA $02

    ; Y = Graphics file being loaded
    CPY #$0A ; 0A = Ice/Mire floor file
    BNE .useDefaultGraphics

    LDA $040C ; Dungeon number
    CMP #$12 ; Ice Palace
    BEQ .useSpecialIcePalaceFile

.useDefaultGraphics
    JML BgGraphicsLoadingResume

.useSpecialIcePalaceFile
    ; We're loading the floor tiles in Ice Palace. Instead of the normal file,
    ; load another one that replaces the bridge tiles with the Bombos medallion

    LDA $FFFFFF

    LDA.b #IcePalaceFloorGfx>>16
    STA $02
    REP #$20
    LDA.w #IcePalaceFloorGfx
    STA $00
    LDX.b #64*2 ; Tiles to load * 2
-
    ; Unrolled loop to upload half a tile
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    LDA [$00] : STA $2118 : INC $00 : INC $00
    DEX
    BNE -

    SEP #$20
    JML BgGraphicsLoadingCancel

IcePalaceFloorGfx:
    incbin ice_palace_floor.bin