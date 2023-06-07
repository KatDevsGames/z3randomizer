DungeonItemMasks: ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
    dw $C000, $C000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004
;--------------------------------------------------------------------------------
InitDungeonCounts:
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
RTL

