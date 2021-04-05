ShouldOverrideFileLoad:
    ; Y = Graphics file being loaded
    CPY #$0A ; 0A = Ice/Mire floor file
    BNE .no

    LDA $040C ; Dungeon number
    CMP #$12 ; Ice Palace
    BEQ .yes
    .no
    CLC : RTS
    .yes
    RTS

BgGraphicsLoading:
    ; Instructions overwritten
    STZ $00
    STX $01
    STA $02

    JSR ShouldOverrideFileLoad
    BCS .useSpecialIcePalaceFile
    JML BgGraphicsLoadingResume

.useSpecialIcePalaceFile
    ; We're loading the floor tiles in Ice Palace. Instead of the normal file,
    ; load another one that replaces the bridge tiles with the Bombos medallion

    ;LDA $FFFFFF

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

ReloadingFloors:
    SEP #$30 ; 8 AXY
    LDA $7EC2F8 ; Floor file that has been decompressed
    TAY
    JSR ShouldOverrideFileLoad
    REP #$30 ; 16 AXY
    BCS .replaceWithSpecialIcePalaceFile

    ; Instructions overwritten by hook
    LDX.w #$0000
    LDY.w #$0040

    JML ReloadingFloorsResume

.replaceWithSpecialIcePalaceFile
    ; Block move our hardcoded graphics into the output buffer
    LDX.w #IcePalaceFloorGfx    ; Source
    LDY.w #$0000                ; Target
    LDA.w #$0800                ; Length
    PHB
    ;MVN $7F, IcePalaceFloorGfx>>16
	MVN $B17F ; CHANGE THIS IF YOU MOVE THE GRAPHICS FILE - kkat
    PLB

    ; Pretend that we ran the original routine
    LDX.w #$0800
    LDA.w #$6600
    STA $03

    JML ReloadingFloorsCancel
