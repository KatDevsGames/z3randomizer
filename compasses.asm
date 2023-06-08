DungeonItemMasks: ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
    dw $C000, $C000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004
;--------------------------------------------------------------------------------
InitDungeonCounts:
        PHB
        LDX.b #$0F
        -
                LDA.l CompassTotalsROM, X : STA.l CompassTotalsWRAM, X
                DEX
        BPL -
        LDX.b #$0F
        -
                LDA.l ChestKeys, X : STA.l MapTotalsWRAM, X
                DEX
        BPL -
        
        LDA.b #$7E
        PHA : PLB
        REP #$30
        LDA.l TotalItemCount
        JSL.l HUDHex4Digit_Long 
        SEP #$20
        LDA.b Scrap04 : TAX : STX.w TotalItemCountTiles+$00
        LDA.b Scrap05 : TAX : STX.w TotalItemCountTiles+$02
        LDA.b Scrap06 : TAX : STX.w TotalItemCountTiles+$04
        LDA.b Scrap07 : TAX : STX.w TotalItemCountTiles+$06
        SEP #$10
        PLB
RTL

