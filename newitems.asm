;================================================================================
; New Item Handlers
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
; Service Indexes
; 0x00 - 0x04 - chests
; 0xF0 - freestanding heart / powder / mushroom / bonkable
; 0xF1 - freestanding heart 2 / boss heart / npc
; 0xF3 - tablet/pedestal
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
GetAnimatedSpriteGfxFile:
    CMP.b #$0C : BNE +
		LDY.b #$5C : JML GetAnimatedSpriteGfxFile_return
	+
    CMP.b #$23 : BNE +
		LDY.b #$5D : JML GetAnimatedSpriteGfxFile_return
	+
    CMP.b #$48 : BNE +
		LDY.b #$60 : JML GetAnimatedSpriteGfxFile_return
	+

    CMP.b #$24 : !BGE +
		LDY.b #$5B : JML GetAnimatedSpriteGfxFile_return
	+
    CMP.b #$37 : !BGE +
		LDY.b #$5C : JML GetAnimatedSpriteGfxFile_return
	+
    CMP.b #$39 : !BGE +
		LDY.b #$5D : JML GetAnimatedSpriteGfxFile_return
	+
		LDY.b #$32
JML GetAnimatedSpriteGfxFile_return

GetAnimatedSpriteBufferPointer_table:
; Original data:
dw $09C0, $0030, $0060, $0090, $00C0, $0300, $0318, $0330
dw $0348, $0360, $0378, $0390, $0930, $03F0, $0420, $0450

dw $0468, $0600, $0630, $0660, $0690, $06C0, $06F0, $0720 ; disassembly (incorrectly?) says this is $0270
dw $0750, $0768, $0900, $0930, $0960, $0990, $09F0, $0000

dw $00F0, $0A20, $0A50, $0660, $0600, $0618, $0630, $0648
dw $0678, $06D8, $06A8, $0708, $0738, $0768, $0960, $0900

dw $03C0, $0990, $09A8, $09C0, $09D8, $0A08, $0A38, $0600
dw $0630
; New data:
dw $0600, $0630, $0660, $0690 ; 50 Bombs / 70 Arrows / Half Magic / Quarter Magic
dw $06C0, $06F0, $8520 ; +5/+10 Bomb Arrows

;#$4x
dw $0750 ; +10 Arrows
dw $0900 ; Upgrade-Only Silver Arrows
dw $09D8 ; Unused
dw $0930, $0960, $0990, $09C0 ; Lvl 1/2/3/4 Sword (Freestanding)
dw $09F0 ; Null-Item
dw $09C0 ; Clock
dw $0A20 ; Triforce
dw $0A50 ; Power Star

GetAnimatedSpriteBufferPointer:
	;PHB : PHK : PLB
	LDA.b Scrap00 : ADC.l GetAnimatedSpriteBufferPointer_table, X
	;PLB
RTL

macro ProgrammableItemLogic(index)
	LDA.l ProgrammableItemLogicPointer_<index> : BNE ?jump
	LDA.l ProgrammableItemLogicPointer_<index>+1 : BNE ?jump
	LDA.l ProgrammableItemLogicPointer_<index>+2 : BNE ?jump
		BRA ?end
	?jump:
		JSL.l ProgrammableItemLogicJump_<index>
	?end:
endmacro

;--------------------------------------------------------------------------------
;carry clear if pass
;carry set if caught
;incsrc eventdata.asm
ProcessEventItems:
	LDA.b Scrap00 : PHA
	LDA.b Scrap01 : PHA
	LDA.b Scrap02 : PHA
	PHY : PHP
	PHB : LDA.b #$AF : PHA : PLB
		LDA.w ItemReceiptID
		CMP.b #$E0 : BNE +
			REP #$30 ; set 16-bit accumulator & index registers
			LDA.l RNGItem : ASL : TAX
			LDA.l EventDataOffsets, X : !ADD #EventDataTable : STA.b Scrap00

			SEP #$20 ; set 8-bit accumulator
			LDA.b #$AF : STA.b Scrap02

			JSL.l LoadDialogAddressIndirect
			LDA.l RNGItem : INC : STA.l RNGItem

			SEP #$10 ; set 8-bit index registers
                        REP #$20 ; set 16-bit accumulator
			LDA.l GoalItemRequirement : BEQ ++
			LDA.l GoalCounter : INC : STA.l GoalCounter
			CMP.l GoalItemRequirement : BCC ++
			LDA.l TurnInGoalItems : AND.w #$00FF : BNE ++
				JSL.l ActivateGoal
			++
                        SEP #$20 ; set 8-bit accumulator
			LDX.b #$01 : BRA .done
		+
		LDX.b #$00
	.done
	PLB
	PLP : PLY
	PLA : STA.b Scrap02
	PLA : STA.b Scrap01
	PLA : STA.b Scrap00
RTS
;--------------------------------------------------------------------------------
AddReceivedItemExpanded:
        JSR.w ResolveReceipt
        PHB : PHK
JML AddReceivedItem+2

AddReceivedItemExpandedGetItem:
	PHX : PHB

	LDA.w ItemReceiptID
	JSL.l FreeDungeonItemNotice
        JSR ItemBehavior
        SEP #$30

        PLB : PLX
	LDA.w ItemReceiptMethod : CMP.b #$01 ; thing we wrote over
RTL

ItemBehavior:
        REP #$30
        AND #$00FF : ASL :  TAX
        SEP #$20
        JMP.w (ItemReceipts_behavior,X)

        .skip
        RTS

        .blue_boomerang
        LDA.l InventoryTracking : ORA.b #$80
        BRA .store_inventory_tracking

        .red_boomerang
        LDA.l InventoryTracking : ORA.b #$40
        BRA .store_inventory_tracking
        
        .mushroom
        LDA.l InventoryTracking : ORA.b #$28
        BRA .store_inventory_tracking

        .powder
        LDA.l InventoryTracking : ORA.b #$10
        BRA .store_inventory_tracking

        .flute_inactive
        LDA.l InventoryTracking : ORA.b #$02
        BRA .store_inventory_tracking

        .flute_active
        LDA.l InventoryTracking : ORA.b #$01
        BRA .store_inventory_tracking

        .shovel
        LDA.l InventoryTracking : ORA.b #$04
        
        .store_inventory_tracking
        STA.l InventoryTracking
        RTS

        .sword_shield
        SEP #$10
        LDX.b #$01
        JSR .increment_sword
        JSR .increment_shield
        RTS

        .master_sword
        SEP #$10
        LDX.b #$02
        JSR .increment_sword
        RTS

        .tempered_sword
        SEP #$10
        LDX.b #$03
        JSR .increment_sword
        RTS

        .gold_sword
        SEP #$10
        LDX.b #$04
        JSR .increment_sword
        RTS

        .fighter_shield
        SEP #$10
        LDA.w ShopPurchaseFlag : BNE ..shop_shield
                -
                LDX.b #$01
                JSR .increment_shield
                RTS
        ..shop_shield
        LDA.l InventoryTable_properties,X : BIT.b #$02 : BNE -
        RTS

        .red_shield
        SEP #$10
        LDA.w ShopPurchaseFlag : BNE ..shop_shield
                -
                LDX.b #$02
                JSR .increment_shield
                RTS
        ..shop_shield
        LDA.l InventoryTable_properties,X : BIT.b #$02 : BNE -
        RTS

        .mirror_shield
        SEP #$10
        LDX.b #$03
        JSR .increment_shield
        REP #$10
        RTS

        .blue_mail
        SEP #$10
        LDX.b #$01
        JSR .increment_mail
        REP #$10
        RTS

        .red_mail
        SEP #$10
        LDX.b #$02
        JSR .increment_mail
        REP #$10
        RTS

        .fighter_sword
        SEP #$10
        LDX.b #$01
        JSR .increment_sword
        REP #$10
        RTS

        .prog_sword
        SEP #$10
        LDA.l SwordEquipment : INC : TAX
        JSR .increment_sword
        REP #$10
        RTS

        .prog_shield
        SEP #$10
        LDA.l ShieldEquipment : INC : TAX
        JSR .increment_shield
        REP #$10
        RTS

        .prog_mail
        SEP #$10
        LDA.l ArmorEquipment : INC : TAX
        JSR .increment_mail
        REP #$10
        RTS

        .bow
        BIT #$40 : BNE .silversbow
                LDA.b #$01 : STA.l BowEquipment
        RTS

        .silversbow
        LDA.l BowTracking : ORA.b #$40 : STA.l BowTracking
        LDA.l SilverArrowsUseRestriction : BNE +
                LDA.b #03 : STA.l BowEquipment ; set bow to silver
        +
        LDA.b #$01 : STA.l BowEquipment
        RTS

        .dungeon_compass
        REP #$20
        LDA.w DungeonID : CMP.w #$0003 : BCC ..hc_sewers
        TAX
        LDA.l DungeonItemMasks,X : TAY
        ORA.l CompassField : STA.l CompassField
        JMP.w .increment_compass
        ..hc_sewers
        LDA.w #$C000 : TAY
        ORA.l CompassField : STA.l CompassField
        JMP.w .increment_compass


        .dungeon_bigkey
        REP #$20
        LDA.w DungeonID : CMP.w #$0003 : BCC ..hc_sewers
        TAX
        LDA.l DungeonItemMasks,X : ORA.l BigKeyField : STA.l BigKeyField
        JMP.w .increment_bigkey
        ..hc_sewers
        LDA.w #$C000 : ORA.l BigKeyField : STA.l BigKeyField
        JMP.w .increment_bigkey

        .dungeon_map
        REP #$20
        LDA.w DungeonID : CMP.w #$0003 : BCC ..hc_sewers
        TAX
        LDA.l DungeonItemMasks,X : TAY
        ORA.l MapField : STA.l MapField
        JMP.w .increment_map
        ..hc_sewers
        LDA.w #$C000 : TAY
        ORA.l MapField : STA.l MapField
        JMP.w .increment_map

        .bow_and_arrows
        LDA.l BowTracking : BIT.b #$40 : BEQ .no_silvers
        LDA.l SilverArrowsUseRestriction : BNE .no_silvers
                LDA.l CurrentArrows : BEQ +
                        LDA.b #04 : STA.l BowEquipment
                        BRA .store_bow
                +
                LDA.b #$03
                BRA .store_bow
        .no_silvers
        LDA.l CurrentArrows : BEQ +
                LDA.b #02
                BRA .store_bow
        +
        LDA.b #$01
        .store_bow
        STA.l BowEquipment
        RTS

        .silver_bow
        LDA.b #$40 : ORA.l BowTracking : STA.l BowTracking
        LDA.l SilverArrowsUseRestriction : BNE .noequip
                LDA.l SilverArrowsAutoEquip : AND.b #$01 : BEQ .noequip
                LDA.l CurrentArrows : BNE + ; check arrows
                                LDA.b #$03 : BRA ++ ; bow without arrow
                        +
                        LDA.b #$04 ; bow with arrow
                ++
                STA.l BowEquipment
        .noequip
        RTS

        .bombs_50
        LDA.b #50 : STA.l BombCapacity ; upgrade bombs
        LDA.b #50 : STA.l BombsFiller ; fill bombs
        RTS

        .arrows_70
        LDA.b #70 : STA.l ArrowCapacity ; upgrade arrows
        LDA.b #70 : STA.l ArrowsFiller ; fill arrows
        RTS

        .magic_2
        LDA.l MagicConsumption : CMP.b #$02 : !BGE +
                INC : STA.l MagicConsumption ; upgrade magic
        +
        LDA.b #$80 : STA.l MagicFiller ; fill magic
        RTS

        .magic_4
        LDA.b #$02 : STA.l MagicConsumption ; upgrade magic
        LDA.b #$80 : STA.l MagicFiller ; fill magic
        RTS

        .master_sword_safe
        SEP #$10
        LDA.l SwordEquipment : CMP.b #$02 : !BGE + ; skip if we have a better sword
                LDA.b #$02 : STA.l SwordEquipment ; set master sword
        +
        LDX.b #$02
        JSR .increment_sword
        RTS

        .bombs_5
        LDA.l BombCapacity : !ADD.b #$05 : STA.l BombCapacity ; upgrade bombs +5
        LDA.l Upgrade5BombsRefill : STA.l BombsFiller ; fill bombs
        RTS

        .bombs_10
        LDA.l BombCapacity : !ADD.b #$0A : STA.l BombCapacity ; upgrade bombs +10
        LDA.l Upgrade10BombsRefill : STA.l BombsFiller ; fill bombs
        RTS

        .arrows_5
        LDA.l ArrowCapacity : !ADD.b #$05 : STA.l ArrowCapacity ; upgrade arrows +5
        LDA.l Upgrade5ArrowsRefill : STA.l ArrowsFiller ; fill arrows
        RTS

        .arrows_10
        LDA.l ArrowCapacity : !ADD.b #$0A : STA.l ArrowCapacity ; upgrade arrows +10
        LDA.l Upgrade10ArrowsRefill : STA.l ArrowsFiller ; fill arrows
        RTS

        .programmable_1
        %ProgrammableItemLogic(1)
        RTS

        .programmable_2
        %ProgrammableItemLogic(2)
        RTS

        .programmable_3
        %ProgrammableItemLogic(3)
        RTS

        .silver_arrows
        LDA.l BowTracking : ORA.b #$40 : STA.l BowTracking
        LDA.l SilverArrowsUseRestriction : BNE ++
                LDA.l SilverArrowsAutoEquip : AND.b #$01 : BEQ ++
                        LDA.l BowEquipment : BEQ ++ : CMP.b #$03 : !BGE +
                                !ADD.b #$02 : STA.l BowEquipment ; switch to silver bow
                        +
                ++
        LDA.l ArrowMode : BEQ +
                LDA.b #$01 : STA.l ArrowsFiller
        +
        RTS

        .single_arrow
        LDA.l ArrowMode : BEQ +
                LDA.l CurrentArrows : INC : STA.l CurrentArrows ; Should be sole write to this address
                LDA.b #$01 : STA.l UpdateHUDFlag                             ; in retro/rupee bow mode.
        +
        RTS

        .rupoor
        REP #$20 : LDA.l CurrentRupees : !SUB RupoorDeduction : STA.l CurrentRupees : SEP #$20 ; Take 1 rupee
        RTS

        .null
        RTS

        .red_clock
        REP #$20 ; set 16-bit accumulator
        LDA.l ChallengeTimer : !ADD.l RedClockAmount : STA.l ChallengeTimer
        LDA.l ChallengeTimer+2 : ADC.l RedClockAmount+2 : STA.l ChallengeTimer+2
        SEP #$20 ; set 8-bit accumulator
        RTS

        .blue_clock
        REP #$20 ; set 16-bit accumulator
        LDA.l ChallengeTimer : !ADD.l BlueClockAmount : STA.l ChallengeTimer
        LDA.l ChallengeTimer+2 : ADC.l BlueClockAmount+2 : STA.l ChallengeTimer+2
        SEP #$20 ; set 8-bit accumulator
        RTS

        .green_clock
        REP #$20 ; set 16-bit accumulator
        LDA.l ChallengeTimer : !ADD.l GreenClockAmount : STA.l ChallengeTimer
        LDA.l ChallengeTimer+2 : ADC.l GreenClockAmount+2 : STA.l ChallengeTimer+2
        SEP #$20 ; set 8-bit accumulator
        RTS

        .triforce
        JSL.l ActivateGoal
        RTS

        .goal_item
        REP #$20 ; set 16-bit accumulator
        LDA.l GoalItemRequirement : BEQ +
        LDA.l GoalCounter : INC : STA.l GoalCounter
        CMP.w GoalItemRequirement : BCC +
        LDA.l TurnInGoalItems : AND.w #$00FF : BNE +
                JSL.l ActivateGoal
        +
        SEP #$20 ; set 8-bit accumulator
        RTS

        .request_F0
        JSL.l ItemGetServiceRequest_F0
        RTS

        .request_F1
        JSL.l ItemGetServiceRequest_F1
        RTS

        .request_F2
        JSL.l ItemGetServiceRequest_F2
        RTS

        .request_async
        ; JSL.l ItemGetServiceRequest
        RTS

        .free_map
        REP #$20
        LSR
        AND.w #$000F : ASL : TAX
        LDA.w DungeonItemIDMap,X : TAX
        LDA.l DungeonItemMasks,X : TAY
        ORA.l MapField : STA.l MapField
        SEP #$20
        JMP.w .increment_map

        .hc_map
        REP #$20
        LDA.w #$C000 : TAY
        ORA.l MapField : STA.l MapField
        JMP.w .increment_map

        .free_compass
        REP #$20
        LSR
        AND.w #$000F : ASL : TAX
        LDA.w DungeonItemIDMap,X : TAX
        LDA.l DungeonItemMasks,X : TAY
        ORA.l CompassField : STA.l CompassField
        SEP #$20
        JMP.w .increment_compass

        .hc_compass
        REP #$20
        LDA.w #$C000 : TAY
        ORA.l CompassField : STA.l CompassField
        SEP #$20
        JMP.w .increment_compass

        .free_bigkey
        REP #$20
        LSR
        AND.w #$000F : ASL : TAX
        LDA.w DungeonItemIDMap,X : TAX
        LDA.l DungeonItemMasks,X : ORA.l BigKeyField : STA.l BigKeyField
        SEP #$20
        JMP.w .increment_bigkey

        .hc_bigkey
        LDA.b #$C0 : ORA.l BigKeyField+1 : STA.l BigKeyField+1
        JMP.w .increment_bigkey

        .free_smallkey
        REP #$20
        LSR
        AND.w #$000F : TAX
        ASL : CMP.w DungeonID : BEQ .same_dungeon
                LDA.l DungeonKeys,X : INC : STA.l DungeonKeys,X
                RTS
        .same_dungeon
        SEP #$20
        LDA.l CurrentSmallKeys : INC : STA.l CurrentSmallKeys : STA.l DungeonKeys,X
        RTS

        .same_dungeon_hc
        SEP #$20
        LDA.l CurrentSmallKeys : INC : STA.l CurrentSmallKeys
        LDA.l SewerKeys : INC
        STA.l SewerKeys : STA.l HyruleCastleKeys
        RTS

        .hc_smallkey
        LDA.w DungeonID : CMP.b #$03 : BCC .same_dungeon_hc
                LDA.l HyruleCastleKeys : INC : STA.l HyruleCastleKeys
                LDA.l SewerKeys : INC : STA.l SewerKeys
                RTS

        .generic_smallkey
        LDA.l GenericKeys : BEQ .normal
                LDA.l CurrentSmallKeys : INC
                STA.l CurrentGenericKeys : STA.l CurrentSmallKeys
                RTS
        .normal
        LDA.w DungeonID : BMI +
                LDA.l CurrentSmallKeys : INC : STA.l CurrentSmallKeys
                RTS
        +
        RTS

        .increment_sword
        LDA.l HighestSword
        INC : STA.b Scrap04 : CPX.b Scrap04 : BCC + ; don't increment unless we're getting a better sword
                TXA : STA.l HighestSword
        +
        RTS

        .increment_shield
        LDA.l HighestShield
        INC : STA.b Scrap04 : CPX.b Scrap04 : BCC + ; don't increment unless we're getting a better shield
                TXA : STA.l HighestShield
        +
        RTS

        .increment_mail
        LDA.l HighestMail
        INC : STA.b Scrap04 : CPX.b Scrap04 : BCC +   ; don't increment unless we're getting a better mail
                TXA : STA.l HighestMail
        +
        RTS

        .increment_bigkey
        SEP #$20
        LDA.l StatsLocked : BNE +
                LDA.l BigKeysBigChests
                CLC : ADC.b #$10
                STA.l BigKeysBigChests
        +
        RTS

        .increment_map
        SEP #$20
        LDA.l StatsLocked : BNE +
                LDA.l MapsCompasses
                CLC : ADC.b #$10
                STA.l MapsCompasses
                JSL.l MaybeFlagMapTotalPickup
        +
        RTS

        .increment_compass
        SEP #$20
        LDA.l StatsLocked : BNE +
                LDA.l MapsCompasses : INC : AND.b #$0F : TAX
                LDA.l MapsCompasses : AND.b #$F0 : STA.l MapsCompasses
                TXA : ORA.l MapsCompasses : STA.l MapsCompasses
                JSL MaybeFlagCompassTotalPickup
        +
        RTS

        .pendant
        SEP #$20
        LSR
        SEC : SBC.b #$37
        TAX
        LDA.w PendantMasks,X : AND.l PendantsField : BNE +
                LDA.l PendantCounter : INC : STA.l PendantCounter
        +
        RTS

        .dungeon_crystal
        SEP #$20
        LDA.l CrystalCounter : INC : STA.l CrystalCounter
        RTS

        .free_crystal
        REP #$20
        LSR
        AND.w #$000F : TAX
        LDA.w #$0000
        SEC
        -
                ROL
                DEX
        BPL -
        SEP #$20
        TAX
        AND.l CrystalsField : BNE +
                TXA
                ORA.l CrystalsField : STA.l CrystalsField
                LDA.l CrystalCounter : INC : STA.l CrystalCounter
        +
        .done
        RTS

ResolveReceipt:
        PHA : PHX
        PHK : PLB
        JSL.l PreItemGet
        LDA.w ItemReceiptID
        .get_item
        JSL.l AttemptItemSubstitution
        JSR.w HandleBowTracking
        JSR.w ResolveLootID
        .have_item
        STA.w ItemReceiptID
        JSR IncrementItemCounters
        PLX : PLA
        RTS

ResolveLootIDLong:
        PHY
        JSR.w ResolveLootID
        PLY
RTL

ResolveLootID:
; In: A - Loot ID
; Out: A - Resolved Loot ID
; Caller is responsible for running AttemptItemSubstitution prior if applicable.

        PHX : PHB
        PHK : PLB
        .get_item
        TAY
        REP #$30
        AND.w #$00FF : ASL : TAX
        TYA
        JMP.w (ItemReceipts_resolution,X)
        .have_item
        SEP #$30
        PLB : PLX
        RTS

        .skip
        JMP.w .have_item

        .bottles
        SEP #$30
        JSR.w CountBottles : CMP.l BottleLimit : BCC +
                LDA.l BottleLimitReplacement
                JMP.w .get_item
        +
        TYA
        JMP.w .have_item

        .magic
        SEP #$20
        LDA.l MagicConsumption : TAX
        LDA.w .magic_ids,X
        JMP.w .have_item
        ..ids
        db $4E, $4F, $4F

        .prog_sword
        SEP #$20
        LDA.l HighestSword
        CMP.l ProgressiveSwordLimit : BCC +
                LDA.l ProgressiveSwordReplacement
                JMP.w .get_item
        +
        TAX
        LDA.w .prog_sword_ids,X
        JMP.w .have_item
        ..ids
        db $49, $50, $02, $03, $03

        .shields
        SEP #$20
        LDA.l HighestShield
        CMP.l ProgressiveShieldLimit : BCC +
                LDA.l ProgressiveShieldReplacement
                JMP.w .get_item
        +
        TAX
        LDA.w .shields_ids,X
        JMP.w .have_item
        ..ids
        db $04, $05, $06, $06

        .armor
        SEP #$20
        LDA.l HighestMail
        CMP.l ProgressiveArmorLimit : BCC +
                LDA.l ProgressiveArmorReplacement
                JMP.w .get_item
        +
        TAX
        LDA.w .armor_ids,X
        JMP.w .have_item
        ..ids
        db $22, $23, $23


        .gloves
        SEP #$20
        LDA.l GloveEquipment : TAX
        LDA.w .gloves_ids,X
        JMP.w .have_item
        ..ids
        db $1B, $1C, $1C

        .progressive_bow
        ; For non-chest progressive bows we assign the tracking bits to SpriteMetaData,X
        ; (where X is that sprite's slot) so the bit can be set on pickup.
        SEP #$30
        LDA.l BowEquipment : INC : LSR : CMP.l ProgressiveBowLimit : BCC +
                LDA.l ProgressiveBowReplacement
                JMP.w .get_item
        +
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ +
                LDX.w CurrentSpriteSlot
                LDA.b #$10 : STA.w SpriteMetaData,X
        +
        LDA.l BowEquipment : TAX
        LDA.w .bows_ids,X
        JMP.w .get_item

        .progressive_bow_2
        SEP #$30
        LDA.l BowEquipment : INC : LSR : CMP.l ProgressiveBowLimit : BCC +
                LDA.l ProgressiveBowReplacement
                JMP.w .get_item
        +
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ +
                LDX.w CurrentSpriteSlot
                LDA.b #$20 : STA.w SpriteMetaData,X
        +
        LDA.l BowEquipment : TAX
        LDA.w .bows_ids,X
        JMP.w .get_item

        .bows
        ..ids
        db $3A, $3B, $3B, $3B, $3B

        .null_chest
        ; JSL ChestItemServiceRequest
        JMP.w .have_item

        .rng_single
        JSL.l GetRNGItemSingle : STA.l ScratchBufferV+6
        XBA : JSR.w MarkRNGItemSingle
        LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
        LDA.l ScratchBufferV+6 : JMP.w .get_item

        .rng_multi
        JSL.l GetRNGItemMulti : STA.l ScratchBufferV+6
        LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
        LDA.l ScratchBufferV+6 : JMP.w .get_item

;--------------------------------------------------------------------------------
DungeonItemMasks:
    ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
    ; sewers and castle get 2 bits active so that they can share their items elegantly
    dw $C000, $C000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004, $4B8B, $20AB ; last two can be re-used

    ; caves
    dw $9CCE, $0390, $2F82, $AD03, $02E9, $01C9, $06D0, $72A5
    dw $A548, $4873, $01A0, $D8AD, $C902, $D020, $A002, $9802
    dw $E48D, $DA02, $D8AC, $D002, $A215, $BD08, $84E2, $0085
    dw $E3BD, $8584, $A901, $857E, $B902, $857A, $0087, $0A98
    dw $BDAA, $84E2, $0085, $E3BD, $8584, $A901, $857E, $B902
    dw $857A, $0230, $0087, $1FC0, $02D0, $5664, $04A9, $4BC0
    dw $06F0, $1EC0, $0AD0, $02A9, $790F, $7EF3, $798F, $7EF3
    dw $1BC0, $04F0, $1CC0, $07D0, $1B22, $1BEE, $0182, $A201
    dw $C004, $F037, $A20C, $C001, $F038, $A206, $C002, $D039
    dw $8A14, $0007, $0087, $00EE, $2902, $C907, $D007, $A906
    dw $8F04, $F3C7, $C07E, $D022, $A70A, $D000, $A904, $8701
    dw $8000, $C0C9, $F025, $C008, $F032, $C004, $D033, $AE11
    dw $040C, $20C2, $C6BD, $0785, $8700, $E200, $8220, $00B0
    dw $3EC0, $0AD0, $082C, $1003, $A905, $8D02, $0309, $20C0
    dw $44D0


;--------------------------------------------------------------------------------
BottleListExpanded:
    db $16, $2B, $2C, $2D, $3D, $3C, $48

PotionListExpanded:
    db $2E, $2F, $30, $FF, $0E
;--------------------------------------------------------------------------------
HandleBowTracking:
; In: A - Item Receipt ID
        PHA
        CMP.b #$64 : BEQ .prog_one
        CMP.b #$65 : BEQ .prog_two
        CMP.b #$0B : BEQ .vanilla_bow
        CMP.b #$3A : BEQ .vanilla_bow
        CMP.b #$3B : BEQ .vanilla_bow
                PLA
                RTS
        .prog_one
        LDA.b #$10
        BRA .done
        .prog_two
        LDA.b #$20
        BRA .done
        .vanilla_bow
        ; A non-chest progressive bow will always have been resolved to a vanilla bow ID
        ; at this point.
        LDA.w ItemReceiptMethod : CMP.b #$01 : BEQ +
                LDX.w CurrentSpriteSlot
                LDA.w SpriteMetaData,X : BEQ .done
                        BRA .done
        +
        LDA.b #$00
        .done
        ORA.b #$80 : ORA.l BowTracking
        STA.l BowTracking
        PLA
RTS
;--------------------------------------------------------------------------------
;Return BowEquipment but also draw silver arrows if you have the upgrade even if you don't have the bow
CheckHUDSilverArrows:
        LDA.l ArrowMode : BNE .rupee_bow
                LDA.l BowEquipment : TAX : BEQ .nobow
                        JSL.l DrawHUDArrows_normal
                        TXA
                        RTL
        .rupee_bow
        LDA.l BowEquipment : TAX
        JSL.l DrawHUDArrows_rupee_arrows
        TXA
        RTL
        .nobow
        JSL.l DrawHUDArrows_silverscheck
        TXA
        RTL
;--------------------------------------------------------------------------------
DrawHUDArrows:
	.rupee_arrows
	LDA.l CurrentArrows : BEQ .none ; assuming silvers will increment this. if we go with something else, reorder these checks
	TXA : BNE +
        .silverscheck
	LDA.l BowTracking : AND.b #$40 : BNE .silver
	BRA .wooden
	+ CMP.b #03 : !BGE .silver

	.wooden
	LDA.b #$A7 : STA.l HUDTileMapBuffer+$20 ; draw wooden arrow marker
	LDA.b #$20 : STA.l HUDTileMapBuffer+$21
	LDA.b #$A9 : STA.l HUDTileMapBuffer+$22
	LDA.b #$20 : STA.l HUDTileMapBuffer+$23
        .skip
RTL
	.normal
        TXA
        CMP.b #$03 : BCS .silver
        BRA .wooden
	.silver
	LDA.b #$86 : STA.l HUDTileMapBuffer+$20 ; draw silver arrow marker
	LDA.b #$24 : STA.l HUDTileMapBuffer+$21
	LDA.b #$87 : STA.l HUDTileMapBuffer+$22
	LDA.b #$24 : STA.l HUDTileMapBuffer+$23
RTL
	.none
	LDA.b #$7F : STA.l HUDTileMapBuffer+$20 ; draw no arrow marker
	LDA.b #$24 : STA.l HUDTileMapBuffer+$21
	LDA.b #$7F : STA.l HUDTileMapBuffer+$22
	LDA.b #$24 : STA.l HUDTileMapBuffer+$23
RTL
;--------------------------------------------------------------------------------
GetRNGItemSingle:
	PHY
		LDA.l RNGLockIn : CMP.b #$FF : BEQ + : TAX : XBA : LDA.l RNGSingleItemTable, X : RTL : +
		LDX.b #$00
		.single_reroll
			JSL.l GetRandomInt : AND.b #$7F ; select random value
			INX : CPX.b #$7F : BCC + : LDA.b #$00 : BRA +++ : + ; default to 0 if too many attempts
			CMP.l RNGSingleTableSize : !BGE .single_reroll
		+++

		STA.l ScratchBufferV ; put our index value here
		LDX.b #$00
		TAY
		.recheck
			TYA
			JSR.w CheckSingleItem : BEQ .single_unused ; already used
				LDA.l ScratchBufferV : INC ; increment index
				CMP.l RNGSingleTableSize : BCC +++ : LDA.b #$00 : +++ ; rollover index if needed
				STA.l ScratchBufferV ; store index
				INX : TAY : TXA : CMP.l RNGSingleTableSize : BCC .recheck
				LDA.b #$5A ; everything is gone, default to null item - MAKE THIS AN OPTION FOR THIS AND THE OTHER ONE
				BRA .single_done
		.single_unused
			LDA.l ScratchBufferV
		.single_done
			TAX : LDA.l RNGSingleItemTable, X
			XBA : LDA.l ScratchBufferV : STA.l RNGLockIn : XBA
	PLY
RTL
;--------------------------------------------------------------------------------
CheckSingleItem:
	LSR #3 : TAX
	LDA.l RNGItem, X : STA.l ScratchBufferV+2 ; load value to temporary
	PHX
		LDA.l ScratchBufferV : AND.b #$07 : TAX ; load 0-7 part into X
		LDA.l ScratchBufferV+2
		---
		CPX.b #$00 : BEQ +++
			LSR
			DEX
		BRA ---
		+++
	PLX
	AND.b #$01
RTS
;--------------------------------------------------------------------------------
MarkRNGItemSingle:
	LSR #3 : STA.l ScratchBufferV+1 : TAX
	LDA.l RNGItem, X
	STA.l ScratchBufferV+2
	LDA.l ScratchBufferV : AND.b #$07 : TAX ; load 0-7 part into X
	LDA.b #01
	---
	CPX.b #$00 : BEQ +++
		ASL
		DEX
	BRA ---
	+++

	PHA
		LDA.l ScratchBufferV+1 : TAX
	PLA
	ORA.l ScratchBufferV+2
	STA.l RNGItem, X
RTS
;--------------------------------------------------------------------------------
GetRNGItemMulti:
	LDA.l RNGLockIn : CMP.b #$FF : BEQ + : TAX : XBA : LDA.l RNGMultiItemTable, X : RTL : +
	LDX.b #$00
	- ; reroll
		JSL.l GetRandomInt : AND.b #$7F ; select random value
		INX : CPX.b #$7F : BCC + : LDA.b 00 : BRA .done : + ; default to 0 if too many attempts
		CMP.l RNGMultiTableSize : !BGE -
	.done
	STA.l RNGLockIn
	TAX : XBA : LDA.l RNGMultiItemTable, X
RTL
;--------------------------------------------------------------------------------
IncrementItemCounters:
	PHX : PHA
		LDX.b #$00
		-
			LDA.l ItemSubstitutionRules, X
			CMP.b #$FF : BEQ .exit
			CMP.b 1,s : BNE .noMatch
				.match
					PHX
						TXA : LSR #2 : TAX
						LDA.l ItemLimitCounts, X : INC : STA.l ItemLimitCounts, X
					PLX
					BEQ .exit
				.noMatch
					INX #4
		BRA -
	.exit
	PLA : PLX
RTS
;--------------------------------------------------------------------------------
AttemptItemSubstitution:
        PHX : PHA
        LDX.b #$00
        -
                LDA.l ItemSubstitutionRules, X
                CMP.b #$FF : BEQ .exit
                CMP.b 1,S : BNE .noMatch
                        .match
                        PHX
                        TXA : LSR #2 : TAX
                        LDA.l ItemLimitCounts, X
                        PLX
                        CMP.l ItemSubstitutionRules+1, X : BCC +
                                LDA.l ItemSubstitutionRules+2, X : STA.b 1,S
                        +
                        BEQ .exit
                                .noMatch
                                INX #4
        BRA -
        .exit
        PLA : PLX
RTL
;--------------------------------------------------------------------------------
CountBottles:
        PHX
        LDX.b #$00
        LDA.l BottleContentsOne : BEQ + : INX
        + : LDA.l BottleContentsTwo : BEQ + : INX
        + : LDA.l BottleContentsThree : BEQ + : INX
        + : LDA.l BottleContentsFour : BEQ + : INX
        +
        TXA
    PLX
RTS
;--------------------------------------------------------------------------------
ActivateGoal:
        STZ.b GameSubMode
        STZ.b SubSubModule
JML.l StatsFinalPrep
;--------------------------------------------------------------------------------
ChestPrep:
	LDA.b #$01 : STA.w ItemReceiptMethod
        JSL.l IncrementChestCounter
	LDA.l ServerRequestMode : BEQ +
		JSL.l ChestItemServiceRequest
		RTL
	+
    LDY.b Scrap0C ; get item value
	SEC
RTL

;--------------------------------------------------------------------------------
MaybeFlagCompassTotalPickup:
        LDA.l CompassMode : AND.b #$0F : BEQ .done
        LDA.w DungeonID : BMI .done
                LDA.w ItemReceiptID : CMP.b #$25 : BEQ .set_flag
                        REP #$20
                        AND.w #$000F : ASL : TAX
                        LDA.w DungeonItemIDMap,X : CMP.w DungeonID : BNE .done
                .set_flag
                REP #$20
                TYA : ORA.l CompassCountDisplay : STA.l CompassCountDisplay
        .done
RTL

MaybeFlagMapTotalPickup:
        LDA.l MapHUDMode : AND.b #$0F : BEQ .done
        LDA.w DungeonID : BMI .done
                LDA.w ItemReceiptID : CMP.b #$33 : BEQ .set_flag
                        REP #$20
                        AND.w #$000F : ASL : TAX
                        LDA.w DungeonItemIDMap,X : CMP.w DungeonID : BNE .done
                .set_flag
                REP #$20
                TYA : ORA.l MapCountDisplay : STA.l MapCountDisplay
        .done
RTL

;--------------------------------------------------------------------------------
; Set the dungeon item count display flags if we're entering a dungeon and have the
; corresponding dungeon item
MaybeFlagDungeonTotalsEntrance:
        LDX.w DungeonID : BMI .done ; Skip if we're not entering dungeon
                REP #$10
                LDA.l DungeonItemMasks,X : TAY
                LDA.l CompassMode : AND.w #$000F : BEQ .maps ; Skip if we're not showing compass counts
                        JSR.w FlagCompassCount
                .maps
                LDA.l MapHUDMode : AND.w #$000F : BEQ .done
                        LDX.w DungeonID
                        JSR.w FlagMapCount
        .done
RTL
;--------------------------------------------------------------------------------
FlagCompassCount:
        CMP.w #$0002 : BEQ .compass_shown
                LDA.l CompassField : AND.l DungeonItemMasks, X : BEQ .done ; skip if we don't have compass
                        .compass_shown
                        TYA : ORA.l CompassCountDisplay : STA.l CompassCountDisplay
        .done
RTS
;--------------------------------------------------------------------------------
FlagMapCount:
        CMP.w #$0002 : BEQ .mapShown
                LDA.l MapField : AND.l DungeonItemMasks, X : BEQ .done ; skip if we don't have map
                        .mapShown
                        TYA : ORA.l MapCountDisplay : STA.l MapCountDisplay
        .done
RTS

;--------------------------------------------------------------------------------
DungeonItemIDMap: ; Maps lower four bits of our new dungeon items to DungeonID
dw $FFFF
dw $FFFF
dw $001A ; GT
dw $0018 ; TR
dw $0016 ; TT
dw $0014 ; TH
dw $0012 ; IP
dw $0010 ; SW
dw $000E ; MM
dw $000C ; PD
dw $000A ; SP
dw $0008 ; CT
dw $0006 ; DP
dw $0004 ; EP
dw $0002 ; HC
dw $0000 ; Sewers

PendantMasks:
db $04, 01, 02
