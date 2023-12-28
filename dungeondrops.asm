;================================================================================
; Dungeon & Boss Drop Fixes
;--------------------------------------------------------------------------------
SpawnDungeonPrize:
        PHX : PHB
        TAX
        LDA.b $06,S : STA.b ScrapBuffer72 ; Store current RoomTag index
        TXA
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.w ItemReceiptID
        TAX
        LDA.b #$29 : LDY.b #$06

        JSL.l AddAncillaLong
        BCS .failed_spawn
                LDA.w ItemReceiptID
                STA.w AncillaGet,X : STA.w SpriteID,X
                JSR.w AddDungeonPrizeAncilla
                LDX.b ScrapBuffer72 : STZ.b RoomTag,X
        .failed_spawn
        PLB : PLX
RTL

AddDungeonPrizeAncilla:
        LDY.w ItemReceiptID
        STZ.w AncillaVelocityY,X
        STZ.w AncillaVelocityX,X
        STZ.w AncillaGeneral,X
        STZ.w $0385,X
        STZ.w $0C54,X

        LDA.b #$D0 : STA.w AncillaVelocityZ,X
        LDA.b #$80 : STA.w AncillaZCoord,X
        LDA.b #$09 : STA.w AncillaTimer,X
        LDA.b #$00 : STA.w $0394,X
        LDA.w AncillaGet,X : STA.w ItemReceiptID
        LDA.w DungeonID : CMP.b #$14 : BNE .not_hera
                LDA.b LinkAbsoluteY+1 : AND.b #$FE
                INC A
                STA.b Scrap01
                STZ.b Scrap00
                LDA.b LinkAbsoluteX+1 : AND.b #$FE
                INC A
                STA.b Scrap03
                STZ.b Scrap02
                BRA .set_coords_exit
        .not_hera
        TYA : ASL : TAY
        REP #$20
        LDA.w #$0078
        CLC : ADC.b BG2V
        STA.b Scrap00
        LDA.w #$0078
        CLC : ADC.b BG2H
        STA.b Scrap02
        SEP #$20

        .set_coords_exit
        LDA.b Scrap00 : STA.w AncillaCoordYLow,X
        LDA.b Scrap01 : STA.w AncillaCoordYHigh,X
        LDA.b Scrap02 : STA.w AncillaCoordXLow,X
        LDA.b Scrap03 : STA.w AncillaCoordXHigh,X
RTS

PrepPrizeTile:
        PHA : PHX : PHY
        LDA.w AncillaGet, X
        JSL.l AttemptItemSubstitution
        JSL.l ResolveLootIDLong
        STA.w SpriteID,X
        JSL.l TransferItemReceiptToBuffer_using_ReceiptID
        PLY : PLX : PLA
RTL

SetItemPose:
        PHA
        LDA.w DungeonID : BMI .one_handed
        LDA.w RoomItemsTaken : BIT.b #$80 : BNE +
                .one_handed
                PLA
                JML $8799F2
        +
        JSR.w CrystalOrPendantBehavior : BCC .one_handed
        .two_handed
        PLA
JML $8799EE ; cool pose

SetPrizeCoords:
        PHX : PHY
        STZ.b Scrap03
        LDA.w ItemReceiptMethod : CMP.b #$03 : BEQ +
                .regular_coords
                PLY : PLX
                LDY.w AncillaGet,X
                RTL
        +
        JSR.w CrystalOrPendantBehavior : BCC .regular_coords
        PLY : PLX
        LDY.b #$20 ; Treat as crystal
RTL

SetCutsceneFlag:
; Out: c - Cutscene flag $02 if set, $01 if unset.
        PHX
        LDY.b #$01 ; wrote over
        LDA.w DungeonID : BMI .no_cutscene
        LDA.w RoomItemsTaken : BIT #$80 : BNE .dungeon_prize
                .no_cutscene
                SEP #$30
                PLX
                CLC
                RTL
        .dungeon_prize
        LDA.w ItemReceiptMethod : CMP.b #$03 : BCC .no_cutscene
                JSR.w SetDungeonCompleted
                LDA.w ItemReceiptID
                REP #$30
                AND.w #$00FF : ASL : TAX
                LDA.l InventoryTable_properties,X : BIT.w #$0080 : BEQ .no_cutscene
                        SEP #$31
                        PLX
RTL

AnimatePrizeCutscene:
        LDA.w ItemReceiptMethod : CMP.b #$03 : BNE +
                JSR.w CrystalOrPendantBehavior : BCC +
                        LDA.w DungeonID : BMI +
                        LDA.w RoomItemsTaken : BIT #$80 : BEQ +
                                SEC
                                RTL
        +
        CLC
RTL

PrizeDropSparkle:
        LDA.w AncillaID,X : CMP.b #$29 : BNE .no_sparkle
                JSR.w CrystalOrPendantBehavior : BCC .no_sparkle
                        SEC
                        RTL
        .no_sparkle
        CLC
RTL

HandleDropSFX:
        LDA.w RoomItemsTaken : BIT #$80 : BEQ .no_sound
                JSR.w CrystalOrPendantBehavior : BCC .no_sound
                        SEC
                        RTL
        .no_sound
        CLC
RTL

HandleCrystalsField:
        TAX
        LDA.w ItemReceiptID : CMP.b #$20 : BNE .not_crystal
                TXA
                STA.l CrystalsField
                RTL
        .not_crystal
RTL

MaybeKeepLootID:
        PHA
        LDA.w DungeonID : BMI .no_prize
        LDA.w RoomItemsTaken : BIT #$80 : BNE .prize
                .no_prize
                STZ.w ItemReceiptID
                STZ.w ItemReceiptPose
                PLA
                RTL
        .prize
        STZ.w ItemReceiptPose
        PLA
RTL

CheckSpawnPrize:
; In: A - DungeonID
; Out: c - Spawn prize if set
        REP #$20
        LDX.w DungeonID
        LDA.l DungeonItemMasks,X : AND.l DungeonsCompleted : BEQ .spawn
                SEP #$20
                CLC
                RTL
        .spawn
        SEP #$21
RTL

CheckDungeonCompletion:
        LDX.w DungeonID
        REP #$20
        LDA.l DungeonItemMasks,X : AND.l DungeonsCompleted
        SEP #$20
RTL

PendantMusicCheck:
; In: A - Item receipt ID
        PHX
        TAY
        LDA.w ItemReceiptMethod : CMP.b #$03 : BNE .dont_wait
                TYA
                REP #$30
                AND.w #$00FF : ASL : TAX
                LDA.l InventoryTable_properties,X : BIT.w #$0080 : BNE .dont_wait
                        SEP #$31
                        PLX
                        RTL
        .dont_wait
        SEP #$30
        PLX
        CLC
RTL

PrepPrizeOAMCoordinates:
        PHX : PHY
        LDY.w AncillaLayer,X

        LDA.w $F67F,Y : STA.b $65
        STZ.b $64

        LDA.w AncillaCoordYLow,X : STA.b Scrap00
        LDA.w AncillaCoordYHigh,X : STA.b Scrap01
        LDA.w AncillaCoordXLow,X : STA.b Scrap02
        LDA.w AncillaCoordXHigh,X : STA.b Scrap03

        REP #$20
        LDA.b Scrap00
        SEC : SBC.w $0122
        STA.b Scrap00

        LDA.b Scrap02
        SEC : SBC.w $011E
        STA.b Scrap02
        STA.b Scrap04

        REP #$20
        LDA.w $029E,X
        AND.w #$00FF
        STA.b $72

        LDA.b $00
        STA.b $06
        SEC
        SBC.b $72
        STA.b $00

        SEP #$20
        TXY
        LDA.w AncillaGet,X : TAX
        LDA.l SpriteProperties_chest_width,X : BNE .wide
                TYX
                LDA.w AncillaID,X : CMP.b #$3E : BEQ .rising_crystal
                        REP #$20
                        LDA.b Scrap00
                        CLC : ADC.w #$0008
                        STA.b Scrap08
                        LDA.b Scrap02
                        CLC : ADC.w #$0004
                        STA.b Scrap02 : STA.b Scrap0A
                        BRA .wide
                .rising_crystal
                REP #$20
                LDA.b Scrap00
                CLC : ADC.w #$0008 : STA.b Scrap08
                LDA.b Scrap02 : STA.b Scrap0A
        .wide
        SEP #$20
        PLY : PLX
RTL

PrepPrizeShadow:
        PHX
        LDA.w ItemReceiptID : TAX
        LDA.l SpriteProperties_standing_width,X : BNE .wide
                LDA.b Scrap02
                SEC : SBC.b #$04
                STA.b Scrap02
        .wide
        LDA.b #$20 : STA.b Scrap04 ; What we wrote over
        PLX
RTL

CheckPoseItemCoordinates:
        PHX
        LDA.w ItemReceiptPose : BEQ .done
                   BIT.b #$02 : BEQ .done
                LDA.w AncillaGet,X : TAX
                LDA.l SpriteProperties_chest_width,X : BNE .done
                        LDA.b Scrap02
                        CLC : ADC.b #$04
                        STA.b Scrap02
        .done
        PLX
        LDA.w AncillaGet,X
        TAX
RTL

CrystalOrPendantBehavior:
; Out: c - Crystal Behavior if set, pendant if unset
        PHA : PHX
        LDA.w AncillaGet,X
        REP #$31
        AND.w #$00FF : ASL : TAX
        LDA.l InventoryTable_properties,X : BIT.w #$0080 : BNE .crystal_behavior
                SEP #$30
                PLX : PLA
                RTS
        .crystal_behavior
        SEP #$31
        PLX : PLA
RTS

CheckDungeonWorld:
; Maintain vanilla door opening behavior with dungeon prizes
        TXA : CMP.b #$05 : BCS .dark_world
                REP #$02
                RTL
        .dark_world
        SEP #$02
RTL

SetDungeonCompleted:
        LDX.w DungeonID : BMI +
                REP #$20
                LDA.l DungeonItemMasks, X : ORA.l DungeonsCompleted : STA.l DungeonsCompleted
                SEP #$20
        +
RTS
