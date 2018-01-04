macro OverwriteVramTile(firstTileIndex, count)
    LDA.w #<firstTileIndex>+512*8*8*4/16
    LDX.b #<count>
    JSR UploadTileToVram
endmacro

GraphicsOverrideHook:
    JSL .resumeOriginalCode

    LDA $0A ; Floor tileset loaded
    CMP #$0A ; Floor tileset index used by Ice and Mire
    BEQ .loadedIceOrMireFloor
    RTL

.loadedIceOrMireFloor
    LDA $040C ; Load dungeon number
    CMP #$12 ; Ice Palace
    BEQ .isInIcePalace
    RTL

.isInIcePalace
    ; We've just loading the floor tiles in Ice Palace.
    ; Replace the bridge tiles with the bombos medallion

    LDA.b #IcePalaceMedallionGfx>>16
    STA $02
    REP #$20
    LDA.w #IcePalaceMedallionGfx
    STA $00

    %OverwriteVramTile($CA, 2)
    %OverwriteVramTile($DA, 2)

    SEP #$20
    RTL

.resumeOriginalCode
    ; Overwritten instructions:
    PHB
    LDA.b #$00
    PHA
    PLB
    LDA.b #$80
    JML GraphicsOverrideResume

; A = VRAM word address to upload to (Actual VRAM address / 2)
; X = Tiles to upload
; $00-$02 = Pointer to graphics data
UploadTileToVram:
    ; TODO: This should probably be optimized with a DMA
    STA $2116
    TXA : ASL #4 : TAX ; X = Amount of words to upload (Tiles to upload * 16)
-   LDA [$00]
    STA $2118
    INC $00
    INC $00
    DEX
    BNE -
    RTS

IcePalaceMedallionGfx:
    incbin ice_bombos_floor.bin