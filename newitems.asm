;================================================================================
; New Item Handlers
;--------------------------------------------------------------------------------
; REMEMBER TO UPDATE THE TABLES IN UTILITIES.ASM!
;--------------------------------------------------------------------------------
; #$4C - Bomb Capacity (50)
; #$4D - Arrow Capacity (70)
; #$4E - 1/2 Magic
; #$4F - 1/4 Magic
; #$50 - Safe Master Sword
; #$51 - Bomb Capacity (+5)
; #$52 - Bomb Capacity (+10)
; #$53 - Arrow Capacity (+5)
; #$54 - Arrow Capacity (+10)
; #$55 - Programmable Item 1
; #$56 - Programmable Item 2
; #$57 - Programmable Item 3
; #$58 - Upgrade-Only Silver Arrows
; #$59 - Rupoor
; #$5A - Null Item
; #$5B - Red Clock
; #$5C - Blue Clock
; #$5D - Green Clock
; #$5E - Progressive Sword
; #$5F - Progressive Shield
; #$60 - Progressive Armor
; #$61 - Progressive Lifting Glove
; #$62 - RNG Pool Item (Single)
; #$63 - RNG Pool Item (Multi)
; #$64 - Progressive Bow
; #$65 - Progressive Bow
; #$6A - Goal Item (Single/Triforce)
; #$6B - Goal Item (Multi/Power Star)
; #$6C - Goal Item (Multi/Triforce Piece)
; #$6D - Server Request F0 (Hearts / Powder / Mushroom / Bonkable)
; #$6E - Server Request F1 (NPC)
; #$6F - Server Request F2 (Tablets / Pedestal)
; #$70 - Maps
; #$80 - Compasses
; #$90 - Big Keys
; #$A0 - Small Keys
; #$FE - Server Request (Asynchronous Chest)
; #$FF - Null Chest
;--------------------------------------------------------------------------------
; Service Indexes
; 0x00 - 0x04 - chests
; 0xF0 - freestanding heart / powder / mushroom / bonkable
; 0xF1 - freestanding heart 2 / boss heart / npc
; 0xF3 - tablet/pedestal
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
;--------------------------------------------------------------------------------
GetAnimatedSpriteBufferPointer_table:
; Original data:
dw $09C0, $0030, $0060, $0090, $00C0, $0300, $0318, $0330
dw $0348, $0360, $0378, $0390, $0930, $03F0, $0420, $0450

dw $0468, $0600, $0630, $0660, $0690, $06C0, $06F0, $0720
dw $0750, $0768, $0900, $0930, $0960, $0990, $09F0, $0000

dw $00F0, $0A20, $0A50, $0660, $0600, $0618, $0630, $0648
dw $0678, $06D8, $06A8, $0708, $0738, $0768, $0960, $0900

dw $03C0, $0990, $09A8, $09C0, $09D8, $0A08, $0A38, $0600
dw $0630
; New data:
dw $0600, $0630, $0660, $0690 ; 50 Bombs / 70 Arrows / Half Magic / Quarter Magic
dw $06C0, $06F0, $0720 ; +5/+10 Bomb Arrows

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
;--------------------------------------------------------------------------------
macro ProgrammableItemLogic(index)
	LDA.l ProgrammableItemLogicPointer_<index> : BNE ?jump
	LDA.l ProgrammableItemLogicPointer_<index>+1 : BNE ?jump
	LDA.l ProgrammableItemLogicPointer_<index>+2 : BNE ?jump
		BRA ?end
	?jump:
		JSL.l ProgrammableItemLogicJump_<index>
	?end:
endmacro

macro ValueShift()
	TAX : LDA.b #$01
	?start:
		CPX #$00 : BEQ ?end
		ASL
		DEX
	BRA ?start : ?end:
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
			CMP.l GoalItemRequirement : !BLT ++
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
AddReceivedItemExpandedGetItem:
	PHX

	LDA.w ItemReceiptID ; check inventory
	JSL.l FreeDungeonItemNotice
	CMP.b #$0B : BNE + ; Bow
		LDA.l BowTracking : AND.b #$40 : BEQ ++
		LDA.l SilverArrowsUseRestriction : BNE ++
			LDA.b #03 : STA.l BowEquipment ; set bow to silver
		++
		JMP .done
	+ CMP.b #$3B : BNE + ; Silver Bow
		LDA.l SilverArrowsUseRestriction : BNE .noequip
		LDA.l SilverArrowsAutoEquip : AND.b #$01 : BEQ .noequip
		LDA.l ArrowsFiller : BNE ++ ; check arrows
			LDA.b #$03 : BRA +++ ; bow without arrow
		++
			LDA.b #$04 ; bow with arrow
		+++
		STA.l BowEquipment
		.noequip
		LDA.l BowTracking : ORA.b #$40 : STA.l BowTracking ; mark silver bow on y-toggle
		JMP .done
	+ CMP.b #$4C : BNE + ; 50 bombs
		LDA.b #50 : STA.l BombCapacity ; upgrade bombs
		LDA.b #50 : STA.l BombsFiller ; fill bombs
		JMP .done
	+ CMP.b #$4D : BNE + ; 70 arrows
		LDA.b #70 : STA.l ArrowCapacity ; upgrade arrows
		LDA.b #70 : STA.l ArrowsFiller ; fill arrows
		JMP .done
	+ CMP.b #$4E : BNE + ; 1/2 magic
		LDA.l MagicConsumption : CMP.b #$02 : !BGE ++
			INC : STA.l MagicConsumption ; upgrade magic
		++
		LDA.b #$80 : STA.l MagicFiller ; fill magic
		JMP .done
	+ CMP.b #$4F : BNE + ; 1/4 magic
		LDA.b #$02 : STA.l MagicConsumption ; upgrade magic
		LDA.b #$80 : STA.l MagicFiller ; fill magic
		JMP .done
	+ CMP.b #$50 : BNE + ; Master Sword (Safe)
		LDA.l SwordEquipment : CMP.b #$02 : !BGE + ; skip if we have a better sword
		LDA.b #$02 : STA.l SwordEquipment ; set master sword
		JMP .done
	+ CMP.b #$51 : BNE + ; +5 Bombs
		LDA.l BombCapacity : !ADD.b #$05 : STA.l BombCapacity ; upgrade bombs +5
		LDA.l Upgrade5BombsRefill : STA.l BombsFiller ; fill bombs
		JMP .done
	+ CMP.b #$52 : BNE + ; +10 Bombs
		LDA.l BombCapacity : !ADD.b #$0A : STA.l BombCapacity ; upgrade bombs +10
		LDA.l Upgrade10BombsRefill : STA.l BombsFiller ; fill bombs
		JMP .done
	+ CMP.b #$53 : BNE + ; +5 Arrows
		LDA.l ArrowCapacity : !ADD.b #$05 : STA.l ArrowCapacity ; upgrade arrows +5
		LDA.l Upgrade5ArrowsRefill : STA.l ArrowsFiller ; fill arrows
		JMP .done
	+ CMP.b #$54 : BNE + ; +10 Arrows
		LDA.l ArrowCapacity : !ADD.b #$0A : STA.l ArrowCapacity ; upgrade arrows +10
		LDA.l Upgrade10ArrowsRefill : STA.l ArrowsFiller ; fill arrows
		JMP .done
	+ CMP.b #$55 : BNE + ; Programmable Object 1
		%ProgrammableItemLogic(1)
		JMP .done
	+ CMP.b #$56 : BNE + ; Programmable Object 2
		%ProgrammableItemLogic(2)
		JMP .done
	+ CMP.b #$57 : BNE + ; Programmable Object 3
		%ProgrammableItemLogic(3)
		JMP .done
	+ CMP.b #$58 : BNE + ; Upgrade-Only Sivler Arrows
		LDA.l SilverArrowsUseRestriction : BNE +++
		LDA.l SilverArrowsAutoEquip : AND.b #$01 : BEQ +++
			LDA.l BowEquipment : BEQ ++ : CMP.b #$03 : !BGE ++
				!ADD.b #$02 : STA.l BowEquipment ; switch to silver bow
			++
		+++
		LDA.l ArrowMode : BEQ ++
			LDA.b #$01 : STA.l ArrowsFiller
		++
	+ CMP.b #$59 : BNE + ; 1 Rupoor
		REP #$20 : LDA.l CurrentRupees : !SUB RupoorDeduction : STA.l CurrentRupees : SEP #$20 ; Take 1 rupee
		JMP .done
	+ CMP.b #$5A : BNE + ; Null Item
		JMP .done
	+ CMP.b #$5B : BNE + ; Red Clock
		REP #$20 ; set 16-bit accumulator
		LDA.l ChallengeTimer : !ADD.l RedClockAmount : STA.l ChallengeTimer
		LDA.l ChallengeTimer+2 : ADC.l RedClockAmount+2 : STA.l ChallengeTimer+2
		SEP #$20 ; set 8-bit accumulator
		JMP .done
	+ CMP.b #$5C : BNE + ; Blue Clock
		REP #$20 ; set 16-bit accumulator
		LDA.l ChallengeTimer : !ADD.l BlueClockAmount : STA.l ChallengeTimer
		LDA.l ChallengeTimer+2 : ADC.l BlueClockAmount+2 : STA.l ChallengeTimer+2
		SEP #$20 ; set 8-bit accumulator
		JMP .done
	+ CMP.b #$5D : BNE + ; Green Clock
		REP #$20 ; set 16-bit accumulator
		LDA.l ChallengeTimer : !ADD.l GreenClockAmount : STA.l ChallengeTimer
		LDA.l ChallengeTimer+2 : ADC.l GreenClockAmount+2 : STA.l ChallengeTimer+2
		SEP #$20 ; set 8-bit accumulator
		JMP .done
	+ CMP.b #$5E : BNE + ; Progressive Sword
		JMP .done
	+ CMP.b #$5F : BNE + ; Progressive Shield
		JMP .done
	+ CMP.b #$60 : BNE + ; Progressive Armor
		JMP .done
	+ CMP.b #$61 : BNE + ; Progressive Lifting Glove
		JMP .done
	+ CMP.b #$62 : BNE + ; RNG Pool Item (Single)
		JMP .done
	+ CMP.b #$63 : BNE + ; RNG Pool Item (Multi)
		JMP .done
	+ CMP.b #$64 : BNE + ; Progressive Bow
		JMP .done
	+ CMP.b #$65 : BNE + ; Progressive Bow
		JMP .done
	+ CMP.b #$6A : BNE + ; Goal Collectable (Single/Triforce)
		JSL.l ActivateGoal
		JMP .done
	+ CMP.b #$6B : BNE + ; Goal Collectable (Multi/Power Star)
		BRA .multi_collect
	+ CMP.b #$6C : BNE + ; Goal Collectable (Multi/Power Star) Alternate Graphic
		.multi_collect
                REP #$20 ; set 16-bit accumulator
		LDA.l GoalItemRequirement : BEQ ++
		LDA.l GoalCounter : INC : STA.l GoalCounter
		CMP.w GoalItemRequirement : !BLT ++
		LDA.l TurnInGoalItems : AND.w #$00FF : BNE ++
				JSL.l ActivateGoal
		++
                SEP #$20 ; set 8-bit accumulator
		JMP .done
	+ CMP.b #$6D : BNE + ; Server Request F0
		JSL.l ItemGetServiceRequest_F0
		JMP .done
	+ CMP.b #$6E : BNE + ; Server Request F1
		JSL.l ItemGetServiceRequest_F1
		JMP .done
	+ CMP.b #$6F : BNE + ; Server Request F2
		JSL.l ItemGetServiceRequest_F2
		JMP .done
	;+ CMP.b #$FE : BNE + ; Server Request (Null Chest)
	;	JSL.l ItemGetServiceRequest
	;	JMP .done
	+ CMP.b #$70 : !BLT + : CMP.b #$80 : !BGE + ; Free Map
		AND.b #$0F : CMP.b #$08 : !BGE ++
			%ValueShift()
			ORA.l MapField : STA.l MapField ; Map 1
			JMP .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA.l MapField+1 : STA.l MapField+1 ; Map 2
		JMP .done
	+ CMP.b #$80 : !BLT + : CMP.b #$90 : !BGE + ; Free Compass
		AND.b #$0F : CMP.b #$08 : !BGE ++
			%ValueShift()
			ORA.l CompassField : STA.l CompassField ; Compass 1
			JMP .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA.l CompassField+1 : STA.l CompassField+1 ; Compass 2
		JMP .done
	+ CMP.b #$90 : !BLT + : CMP.b #$A0 : !BGE + ; Free Big Key
		AND.b #$0F : CMP.b #$08 : !BGE ++
			%ValueShift()
			ORA.l BigKeyField : STA.l BigKeyField ; Big Key 1
			JMP .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA.l BigKeyField+1 : STA.l BigKeyField+1 ; Big Key 2
		JMP .done
	+ CMP.b #$A0 : !BLT + : CMP.b #$B0 : !BGE + ; Free Small Key
		AND.b #$0F : TAX
		LDA.l DungeonKeys, X : INC : STA.l DungeonKeys, X ; Increment Key Count

		CPX.b #$00 : BNE ++
			STA.l HyruleCastleKeys ; copy HC to sewers
		++ : CPX.b #$01 : BNE ++
			STA.l SewerKeys ; copy sewers to HC
		++

		LDA.l GenericKeys : BEQ +
		.generic
			LDA.l CurrentSmallKeys : INC : STA.l CurrentSmallKeys
			JMP .done
		.normal
			TXA : ASL : CMP.w DungeonID : BNE ++
				LDA.l CurrentSmallKeys : INC : STA.l CurrentSmallKeys
			++
			JMP .done
	+
	.done
	PLX
	LDA.w ItemReceiptMethod : CMP.b #$01 ; thing we wrote over
RTL
; #$70 - Maps
; #$80 - Compasses
; #$90 - Big Keys
; #$A0 - Small Keys
;--------------------------------------------------------------------------------
;2B:Bottle Already Filled w/ Red Potion
;2C:Bottle Already Filled w/ Green Potion
;2D:Bottle Already Filled w/ Blue Potion
;3C:Bottle Already Filled w/ Bee
;3D:Bottle Already Filled w/ Fairy
;48:Bottle Already Filled w/ Gold Bee
AddReceivedItemExpanded:
{
	PHA : PHX
		JSL.l PreItemGet

		LDA.w ItemReceiptID ; Item Value
		JSR AttemptItemSubstitution
		STA.w ItemReceiptID

		JSR IncrementItemCounters

		CMP.b #$16 : BNE ++ ; Bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$2B : BNE ++ ; Red Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$2C : BNE ++ ; Green Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$2D : BNE ++ ; Blue Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$3C : BNE ++ ; Bee w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$3D : BNE ++ ; Fairy w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$48 : BNE ++ ; Gold Bee w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$4E : BNE ++ ; Progressive Magic
			LDA.l MagicConsumption : BEQ +++
				LDA.b #$4F : STA.w ItemReceiptID
			+++ : JMP .done
		++ : CMP.b #$5E : BNE ++ ; Progressive Sword
			LDA.l HighestSword : CMP.l ProgressiveSwordLimit : !BLT +
				LDA.l ProgressiveSwordReplacement : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$00 : BNE + ; No Sword
				LDA.b #$49 : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$01 : BNE + ; Fighter Sword
				LDA.b #$50 : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$02 : BNE + ; Master Sword
				LDA.b #$02 : STA.w ItemReceiptID : JMP .done
			+ ; Everything Else
				LDA.b #$03 : STA.w ItemReceiptID : JMP .done
		++ : CMP.b #$5F : BNE ++ ; Progressive Shield
			LDA.l HighestShield : CMP.l ProgressiveShieldLimit : !BLT +
				LDA.l ProgressiveShieldReplacement : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$00 : BNE + ; No Shield
				LDA.b #$04 : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$01 : BNE + ; Fighter Shield
				LDA.b #$05 : STA.w ItemReceiptID : JMP .done
			+ ; Everything Else
				LDA.b #$06 : STA.w ItemReceiptID : JMP .done
		++ : CMP.b #$60 : BNE ++ ; Progressive Armor
			LDA.l HighestMail : CMP.l ProgressiveArmorLimit : !BLT +
				LDA.l ProgressiveArmorReplacement : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$00 : BNE + ; No Armor
				LDA.b #$22 : STA.w ItemReceiptID : JMP .done
			+ ; Everything Else
				LDA.b #$23 : STA.w ItemReceiptID : JMP .done
		++ : CMP.b #$61 : BNE ++ ; Progressive Lifting Glove
			LDA.l GloveEquipment : BNE + ; No Lift
				LDA.b #$1B : STA.w ItemReceiptID : BRA .done
			+ ; Everything Else
				LDA.b #$1C : STA.w ItemReceiptID : BRA .done
		++ : CMP.b #$64 : BNE ++ : -- ; Progressive Bow
			LDA.l BowEquipment : INC : LSR : CMP.l ProgressiveBowLimit : !BLT +
				LDA.l ProgressiveBowReplacement : STA.w ItemReceiptID : JMP .done
			+ : CMP.b #$00 : BNE + ; No Bow
				LDA.b #$3A : STA.w ItemReceiptID : BRA .done
			+ ; Any Bow
				LDA.b #$3B : STA.w ItemReceiptID : BRA .done
		++ : CMP.b #$65 : BNE ++ ; Progressive Bow 2
			LDA.l BowTracking : ORA.b #$20 : STA.l BowTracking
			BRA --
		; ++ : CMP.b #$FE : BNE ++ ; Server Request (Null Chest)
		;	JSL ChestItemServiceRequest
		;	BRA .done
		++ : CMP.b #$62 : BNE ++ ; RNG Item (Single)
			JSL.l GetRNGItemSingle : STA.w ItemReceiptID
			XBA : JSR.w MarkRNGItemSingle
			LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
			BRA .done
		++ : CMP.b #$63 : BNE ++ ; RNG Item (Multi)
			JSL.l GetRNGItemMulti : STA.w ItemReceiptID
			LDA.b #$FF : STA.l RNGLockIn ; clear lock-in
			BRA .done
		++
		.done
	PLX : PLA

    PHB : PHK ; we're skipping the corresponding instructions to grab the data bank
	JML.l AddReceivedItem+2
}
;--------------------------------------------------------------------------------
;DATA AddReceivedItemExpanded
{
.item_masks ; these are dungeon correlations to $7EF364 - $7EF369 so it knows where to store compasses, etc
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
}

ItemReceipts:
	.offset_y  : fillbyte $00   : fill 256
	.offset_x  : fillbyte $00   : fill 256
	.graphics  : fillbyte $00   : fill 256 ; item_graphics_indices
	.width     : fillbyte $00   : fill 256 ; wide_item_flag
	.palette   : fillbyte $00   : fill 256 ; properties
	.target    : fillword $0000 : fill 256*2 ; item_target_addr
	.value     : fillbyte $00   : fill 256 ; item_values


macro ReceiptProps(id, y, x, gfx, width, pal, sram, value)
	pushpc

	org ItemReceipts_offset_y+<id>      : db <y>
	org ItemReceipts_offset_x+<id>      : db <x>
	org ItemReceipts_graphics+<id>      : db <gfx>
	org ItemReceipts_width+<id>         : db <width>
	org ItemReceipts_palette+<id>       : db <pal>
	org ItemReceipts_target+<id>+<id>   : dw <sram>
	org ItemReceipts_value+<id>         : db <value>

	pullpc

endmacro

%ReceiptProps($00, -5, 0, $06, 2, $02, $F359, $01) ; 00 - Fighter sword
%ReceiptProps($01, -5, 4, $18, 0, $FF, $F359, $02) ; 01 - Master sword - TODO gfx value?
%ReceiptProps($02, -5, 4, $18, 0, $05, $F359, $03) ; 02 - Tempered sword - TODO gfx value?
%ReceiptProps($03, -5, 4, $18, 0, $05, $F359, $04) ; 03 - Butter sword - TODO gfx value?
%ReceiptProps($04, -5, 4, $2D, 0, $05, $F35A, $01) ; 04 - Fighter shield
%ReceiptProps($05, -4, 0, $20, 2, $05, $F35A, $02) ; 05 - Fire shield
%ReceiptProps($06, -4, 0, $2E, 2, $05, $F35A, $03) ; 06 - Mirror shield
%ReceiptProps($07, -5, 4, $09, 0, $01, $F345, $01) ; 07 - Fire rod
%ReceiptProps($08, -5, 4, $09, 0, $02, $F346, $01) ; 08 - Ice rod
%ReceiptProps($09, -4, 4, $0A, 0, $01, $F34B, $01) ; 09 - Hammer
%ReceiptProps($0A, -4, 4, $08, 0, $01, $F342, $01) ; 0A - Hookshot
%ReceiptProps($0B, -4, 4, $05, 0, $01, $F340, $01) ; 0B - Bow
%ReceiptProps($0C, -2, 5, $10, 0, $02, $F341, $01) ; 0C - Boomerang
%ReceiptProps($0D, -4, 0, $0B, 2, $02, $F344, $02) ; 0D - Powder
%ReceiptProps($0E, -4, 0, $2C, 2, $02, $F35C, $FF) ; 0E - Bottle refill (bee)
%ReceiptProps($0F, -4, 0, $1B, 2, $04, $F347, $01) ; 0F - Bombos
%ReceiptProps($10, -4, 0, $1A, 2, $04, $F348, $01) ; 10 - Ether
%ReceiptProps($11, -4, 0, $1C, 2, $04, $F349, $01) ; 11 - Quake
%ReceiptProps($12, -4, 0, $14, 2, $01, $F34A, $01) ; 12 - Lamp
%ReceiptProps($13, -4, 4, $19, 0, $01, $F34C, $01) ; 13 - Shovel
%ReceiptProps($14, -4, 0, $0C, 2, $02, $F34C, $02) ; 14 - Flute
%ReceiptProps($15, -4, 4, $07, 0, $01, $F350, $01) ; 15 - Somaria
%ReceiptProps($16, -4, 0, $1D, 2, $01, $F35C, $FF) ; 16 - Bottle
%ReceiptProps($17, -4, 0, $2F, 2, $01, $F36B, $FF) ; 17 - Heart piece
%ReceiptProps($18, -4, 4, $07, 0, $02, $F351, $01) ; 18 - Byrna
%ReceiptProps($19, -4, 0, $15, 2, $01, $F352, $01) ; 19 - Cape
%ReceiptProps($1A, -4, 0, $12, 2, $02, $F353, $02) ; 1A - Mirror
%ReceiptProps($1B, -4, 0, $0D, 2, $01, $F354, $01) ; 1B - Glove
%ReceiptProps($1C, -4, 0, $0D, 2, $04, $F354, $02) ; 1C - Mitts
%ReceiptProps($1D, -4, 0, $0E, 2, $04, $F34E, $01) ; 1D - Book
%ReceiptProps($1E, -4, 0, $11, 2, $02, $F356, $01) ; 1E - Flippers
%ReceiptProps($1F, -4, 0, $17, 2, $01, $F357, $01) ; 1F - Pearl
%ReceiptProps($20, -4, 0, $28, 2, $06, $F37A, $FF) ; 20 - Crystal
%ReceiptProps($21, -4, 0, $27, 2, $01, $F34D, $01) ; 21 - Net
%ReceiptProps($22, -4, 0, $04, 2, $02, $F35B, $FF) ; 22 - Blue mail
%ReceiptProps($23, -5, 0, $04, 2, $01, $F35B, $02) ; 23 - Red mail
%ReceiptProps($24, -4, 4, $0F, 0, $02, $F36F, $FF) ; 24 - Small key
%ReceiptProps($25, -4, 0, $16, 2, $02, $F364, $FF) ; 25 - Compbutt
%ReceiptProps($26, -4, 0, $03, 2, $01, $F36C, $FF) ; 26 - Heart container from 4/4
%ReceiptProps($27, -4, 0, $13, 2, $02, $F375, $FF) ; 27 - Bomb
%ReceiptProps($28, -4, 0, $01, 2, $02, $F375, $FF) ; 28 - 3 bombs
%ReceiptProps($29, -4, 0, $1E, 2, $04, $F344, $FF) ; 29 - Mushroom
%ReceiptProps($2A, -2, 5, $10, 0, $01, $F341, $02) ; 2A - Red boomerang
%ReceiptProps($2B, -4, 0, $00, 2, $01, $F35C, $FF) ; 2B - Full bottle (red)
%ReceiptProps($2C, -4, 0, $00, 2, $04, $F35C, $FF) ; 2C - Full bottle (green)
%ReceiptProps($2D, -4, 0, $00, 2, $02, $F35C, $FF) ; 2D - Full bottle (blue)
%ReceiptProps($2E, -4, 0, $00, 2, $01, $F36D, $FF) ; 2E - Potion refill (red)
%ReceiptProps($2F, -4, 0, $00, 2, $04, $F36E, $FF) ; 2F - Potion refill (green)
%ReceiptProps($30, -4, 0, $00, 2, $02, $F36E, $FF) ; 30 - Potion refill (blue)
%ReceiptProps($31, -4, 0, $30, 2, $02, $F375, $FF) ; 31 - 10 bombs
%ReceiptProps($32, -4, 0, $22, 2, $04, $F366, $FF) ; 32 - Big key
%ReceiptProps($33, -4, 0, $21, 2, $04, $F368, $FF) ; 33 - Map
%ReceiptProps($34, -2, 4, $24, 0, $04, $F360, $FF) ; 34 - 1 rupee
%ReceiptProps($35, -2, 4, $24, 0, $02, $F360, $FB) ; 35 - 5 rupees
%ReceiptProps($36, -2, 4, $24, 0, $01, $F360, $EC) ; 36 - 20 rupees
%ReceiptProps($37, -4, 0, $23, 2, $04, $F374, $FF) ; 37 - Green pendant
%ReceiptProps($38, -4, 0, $23, 2, $01, $F374, $FF) ; 38 - Blue pendant
%ReceiptProps($39, -4, 0, $23, 2, $02, $F374, $FF) ; 39 - Red pendant
%ReceiptProps($3A, -4, 0, $29, 2, $02, $F340, $01) ; 3A - Tossed bow
%ReceiptProps($3B, -4, 0, $2A, 2, $01, $F340, $03) ; 3B - Silvers
%ReceiptProps($3C, -4, 0, $2C, 2, $02, $F35C, $FF) ; 3C - Full bottle (bee)
%ReceiptProps($3D, -4, 0, $2B, 2, $02, $F35C, $FF) ; 3D - Full bottle (fairy)
%ReceiptProps($3E, -4, 0, $03, 2, $01, $F36C, $FF) ; 3E - Boss heart
%ReceiptProps($3F, -4, 0, $03, 2, $01, $F36C, $FF) ; 3F - Sanc heart
%ReceiptProps($40, -4, 0, $34, 2, $04, $F360, $9C) ; 40 - 100 rupees
%ReceiptProps($41, -4, 0, $35, 2, $04, $F360, $CE) ; 41 - 50 rupees
%ReceiptProps($42, -2, 4, $31, 0, $01, $F372, $FF) ; 42 - Heart
%ReceiptProps($43, -2, 4, $33, 0, $02, $F376, $01) ; 43 - Arrow
%ReceiptProps($44, -4, 0, $02, 2, $02, $F376, $0A) ; 44 - 10 arrows
%ReceiptProps($45, -2, 4, $32, 0, $04, $F373, $FF) ; 45 - Small magic
%ReceiptProps($46, -4, 0, $36, 2, $04, $F360, $FF) ; 46 - 300 rupees
%ReceiptProps($47, -4, 0, $37, 2, $04, $F360, $FF) ; 47 - 20 rupees green
%ReceiptProps($48, -4, 0, $2C, 2, $02, $F35C, $FF) ; 48 - Full bottle (good bee)
%ReceiptProps($49, -5, 4, $06, 0, $05, $F359, $01) ; 49 - Tossed fighter sword
%ReceiptProps($4A, -4, 0, $0C, 2, $02, $F34C, $03) ; 4A - Bottle refill (good bee)
%ReceiptProps($4B, -4, 0, $38, 2, $01, $F355, $01) ; 4B - Boots
%ReceiptProps($4C, -4, 0, $39, 2, $04, $F375, $32) ; 4C - Bomb capacity (50)
%ReceiptProps($4D, -4, 0, $3A, 2, $04, $F376, $46) ; 4D - Arrow capacity (70)
%ReceiptProps($4E, -4, 0, $3B, 2, $F9, $F373, $80) ; 4E - 1/2 magic
%ReceiptProps($4F, -4, 0, $3C, 2, $04, $F373, $80) ; 4F - 1/4 magic
%ReceiptProps($50, -5, 4, $18, 0, $05, $F359, $02) ; 50 - Safe master sword - TODO gfx value
%ReceiptProps($51, -4, 0, $3D, 2, $04, $F375, $FF) ; 51 - Bomb capacity (+5)
%ReceiptProps($52, -4, 0, $3E, 2, $04, $F375, $FF) ; 52 - Bomb capacity (+10)
%ReceiptProps($53, -4, 0, $3F, 2, $04, $F376, $FF) ; 53 - Arrow capacity (+5)
%ReceiptProps($54, -4, 0, $40, 2, $04, $F376, $FF) ; 54 - Arrow capacity (+10)
%ReceiptProps($55, -4, 0, $00, 2, $04, $F41A, $FF) ; 55 - Programmable item 1
%ReceiptProps($56, -4, 0, $00, 2, $04, $F41C, $FF) ; 56 - Programmable item 2
%ReceiptProps($57, -4, 0, $00, 2, $04, $F41E, $FF) ; 57 - Programmable item 3
%ReceiptProps($58, -4, 0, $41, 2, $01, $F340, $FF) ; 58 - Upgrade-only silver arrows
%ReceiptProps($59, -4, 4, $24, 0, $03, $F360, $FF) ; 59 - Rupoor
%ReceiptProps($5A, -4, 0, $47, 2, $01, $F36A, $FF) ; 5A - Nothing
%ReceiptProps($5B, -4, 0, $48, 2, $01, $F454, $FF) ; 5B - Red clock
%ReceiptProps($5C, -4, 0, $48, 2, $02, $F454, $FF) ; 5C - Blue clock
%ReceiptProps($5D, -4, 0, $48, 2, $04, $F454, $FF) ; 5D - Green clock
%ReceiptProps($5E, -4, 0, $FE, 2, $FF, $F359, $FF) ; 5E - Progressive sword
%ReceiptProps($5F, -4, 0, $FF, 2, $FF, $F35A, $FF) ; 5F - Progressive shield
%ReceiptProps($60, -4, 0, $FD, 2, $FF, $F35B, $FF) ; 60 - Progressive armor
%ReceiptProps($61, -4, 0, $0D, 2, $FF, $F354, $FF) ; 61 - Progressive glove
%ReceiptProps($62, -4, 0, $FF, 2, $FF, $F36A, $FF) ; 62 - RNG pool item (single)
%ReceiptProps($63, -4, 0, $FF, 2, $FF, $F36A, $FF) ; 63 - RNG pool item (multi)
%ReceiptProps($64, -4, 0, $FF, 2, $00, $F340, $FF) ; 64 - Progressive bow
%ReceiptProps($65, -4, 0, $FF, 2, $00, $F340, $FF) ; 65 - Progressive bow
%ReceiptProps($66, -4, 0, $FF, 2, $00, $F36A, $FF) ; 66 - 
%ReceiptProps($67, -4, 0, $FF, 2, $00, $F36A, $FF) ; 67 - 
%ReceiptProps($68, -4, 0, $FF, 2, $00, $F36A, $FF) ; 68 - 
%ReceiptProps($69, -4, 0, $FF, 2, $00, $F36A, $FF) ; 69 - 
%ReceiptProps($6A, -4, 0, $49, 2, $04, $F36A, $FF) ; 6A - Triforce
%ReceiptProps($6B, -4, 0, $4A, 2, $04, $F36A, $FF) ; 6B - Power star
%ReceiptProps($6C, -4, 0, $49, 2, $04, $F36A, $FF) ; 6C - 
%ReceiptProps($6D, -4, 0, $FF, 2, $00, $F36A, $FF) ; 6D - Server request item
%ReceiptProps($6E, -4, 0, $FF, 2, $00, $F36A, $FF) ; 6E - Server request item (dungeon drop)
%ReceiptProps($6F, -4, 0, $FF, 2, $00, $F36A, $FF) ; 6F - 
%ReceiptProps($70, -4, 0, $21, 2, $04, $F36A, $FF) ; 70 - Map of Light World
%ReceiptProps($71, -4, 0, $21, 2, $04, $F36A, $FF) ; 71 - Map of Dark World
%ReceiptProps($72, -4, 0, $21, 2, $04, $F36A, $FF) ; 72 - Map of Ganon's Tower
%ReceiptProps($73, -4, 0, $21, 2, $04, $F36A, $FF) ; 73 - Map of Turtle Rock
%ReceiptProps($74, -4, 0, $21, 2, $04, $F36A, $FF) ; 74 - Map of Thieves' Town
%ReceiptProps($75, -4, 0, $21, 2, $04, $F36A, $FF) ; 75 - Map of Tower of Hera
%ReceiptProps($76, -4, 0, $21, 2, $04, $F36A, $FF) ; 76 - Map of Ice Palace
%ReceiptProps($77, -4, 0, $21, 2, $04, $F36A, $FF) ; 77 - Map of Skull Woods
%ReceiptProps($78, -4, 0, $21, 2, $04, $F36A, $FF) ; 78 - Map of Misery Mire
%ReceiptProps($79, -4, 0, $21, 2, $04, $F36A, $FF) ; 79 - Map of Dark Palace
%ReceiptProps($7A, -4, 0, $21, 2, $04, $F36A, $FF) ; 7A - Map of Swamp Palace
%ReceiptProps($7B, -4, 0, $21, 2, $04, $F36A, $FF) ; 7B - Map of Agahnim's Tower
%ReceiptProps($7C, -4, 0, $21, 2, $04, $F36A, $FF) ; 7C - Map of Desert Palace
%ReceiptProps($7D, -4, 0, $21, 2, $04, $F36A, $FF) ; 7D - Map of Eastern Palace
%ReceiptProps($7E, -4, 0, $21, 2, $04, $F36A, $FF) ; 7E - Map of Hyrule Castle
%ReceiptProps($7F, -4, 0, $21, 2, $04, $F36A, $FF) ; 7F - Map of Sewers
%ReceiptProps($80, -4, 0, $16, 2, $02, $F36A, $FF) ; 80 - Compass of Light World
%ReceiptProps($81, -4, 0, $16, 2, $02, $F36A, $FF) ; 81 - Compass of Dark World
%ReceiptProps($82, -4, 0, $16, 2, $02, $F36A, $FF) ; 82 - Compass of Ganon's Tower
%ReceiptProps($83, -4, 0, $16, 2, $02, $F36A, $FF) ; 83 - Compass of Turtle Rock
%ReceiptProps($84, -4, 0, $16, 2, $02, $F36A, $FF) ; 84 - Compass of Thieves' Town
%ReceiptProps($85, -4, 0, $16, 2, $02, $F36A, $FF) ; 85 - Compass of Tower of Hera
%ReceiptProps($86, -4, 0, $16, 2, $02, $F36A, $FF) ; 86 - Compass of Ice Palace
%ReceiptProps($87, -4, 0, $16, 2, $02, $F36A, $FF) ; 87 - Compass of Skull Woods
%ReceiptProps($88, -4, 0, $16, 2, $02, $F36A, $FF) ; 88 - Compass of Misery Mire
%ReceiptProps($89, -4, 0, $16, 2, $02, $F36A, $FF) ; 89 - Compass of Dark Palace
%ReceiptProps($8A, -4, 0, $16, 2, $02, $F36A, $FF) ; 8A - Compass of Swamp Palace
%ReceiptProps($8B, -4, 0, $16, 2, $02, $F36A, $FF) ; 8B - Compass of Agahnim's Tower
%ReceiptProps($8C, -4, 0, $16, 2, $02, $F36A, $FF) ; 8C - Compass of Desert Palace
%ReceiptProps($8D, -4, 0, $16, 2, $02, $F36A, $FF) ; 8D - Compass of Eastern Palace
%ReceiptProps($8E, -4, 0, $16, 2, $02, $F36A, $FF) ; 8E - Compass of Hyrule Castle
%ReceiptProps($8F, -4, 0, $16, 2, $02, $F36A, $FF) ; 8F - Compass of Sewers
%ReceiptProps($90, -4, 0, $22, 2, $04, $F36A, $FF) ; 90 - Skull key
%ReceiptProps($91, -4, 0, $22, 2, $04, $F36A, $FF) ; 91 - Reserved
%ReceiptProps($92, -4, 0, $22, 2, $04, $F36A, $FF) ; 92 - Big key of Ganon's Tower
%ReceiptProps($93, -4, 0, $22, 2, $04, $F36A, $FF) ; 93 - Big key of Turtle Rock
%ReceiptProps($94, -4, 0, $22, 2, $04, $F36A, $FF) ; 94 - Big key of Thieves' Town
%ReceiptProps($95, -4, 0, $22, 2, $04, $F36A, $FF) ; 95 - Big key of Tower of Hera
%ReceiptProps($96, -4, 0, $22, 2, $04, $F36A, $FF) ; 96 - Big key of Ice Palace
%ReceiptProps($97, -4, 0, $22, 2, $04, $F36A, $FF) ; 97 - Big key of Skull Woods
%ReceiptProps($98, -4, 0, $22, 2, $04, $F36A, $FF) ; 98 - Big key of Misery Mire
%ReceiptProps($99, -4, 0, $22, 2, $04, $F36A, $FF) ; 99 - Big key of Dark Palace
%ReceiptProps($9A, -4, 0, $22, 2, $04, $F36A, $FF) ; 9A - Big key of Swamp Palace
%ReceiptProps($9B, -4, 0, $22, 2, $04, $F36A, $FF) ; 9B - Big key of Agahnim's Tower
%ReceiptProps($9C, -4, 0, $22, 2, $04, $F36A, $FF) ; 9C - Big key of Desert Palace
%ReceiptProps($9D, -4, 0, $22, 2, $04, $F36A, $FF) ; 9D - Big key of Eastern Palace
%ReceiptProps($9E, -4, 0, $22, 2, $04, $F36A, $FF) ; 9E - Big key of Hyrule Castle
%ReceiptProps($9F, -4, 0, $22, 2, $04, $F36A, $FF) ; 9F - Big key of Sewers
%ReceiptProps($A0, -4, 4, $0F, 0, $04, $F36A, $FF) ; A0 - Small key of Sewers
%ReceiptProps($A1, -4, 4, $0F, 0, $04, $F36A, $FF) ; A1 - Small key of Hyrule Castle
%ReceiptProps($A2, -4, 4, $0F, 0, $04, $F36A, $FF) ; A2 - Small key of Eastern Palace
%ReceiptProps($A3, -4, 4, $0F, 0, $04, $F36A, $FF) ; A3 - Small key of Desert Palace
%ReceiptProps($A4, -4, 4, $0F, 0, $04, $F36A, $FF) ; A4 - Small key of Agahnim's Tower
%ReceiptProps($A5, -4, 4, $0F, 0, $04, $F36A, $FF) ; A5 - Small key of Swamp Palace
%ReceiptProps($A6, -4, 4, $0F, 0, $04, $F36A, $FF) ; A6 - Small key of Dark Palace
%ReceiptProps($A7, -4, 4, $0F, 0, $04, $F36A, $FF) ; A7 - Small key of Misery Mire
%ReceiptProps($A8, -4, 4, $0F, 0, $04, $F36A, $FF) ; A8 - Small key of Skull Woods
%ReceiptProps($A9, -4, 4, $0F, 0, $04, $F36A, $FF) ; A9 - Small key of Ice Palace
%ReceiptProps($AA, -4, 4, $0F, 0, $04, $F36A, $FF) ; AA - Small key of Tower of Hera
%ReceiptProps($AB, -4, 4, $0F, 0, $04, $F36A, $FF) ; AB - Small key of Thieves' Town
%ReceiptProps($AC, -4, 4, $0F, 0, $04, $F36A, $FF) ; AC - Small key of Turtle Rock
%ReceiptProps($AD, -4, 4, $0F, 0, $04, $F36A, $FF) ; AD - Small key of Ganon's Tower
%ReceiptProps($AE, -4, 4, $0F, 0, $04, $F36A, $FF) ; AE - Reserved
%ReceiptProps($AF, -4, 4, $0F, 0, $04, $F36A, $FF) ; AF - Generic small key
%ReceiptProps($B0, -4, 0, $49, 2, $04, $F36A, $FF) ; B0 - 
%ReceiptProps($B1, -4, 0, $49, 2, $04, $F36A, $FF) ; B1 - 
%ReceiptProps($B2, -4, 0, $49, 2, $04, $F36A, $FF) ; B2 - 
%ReceiptProps($B3, -4, 0, $49, 2, $04, $F36A, $FF) ; B3 - 
%ReceiptProps($B4, -4, 0, $49, 2, $04, $F36A, $FF) ; B4 - 
%ReceiptProps($B5, -4, 0, $49, 2, $04, $F36A, $FF) ; B5 - 
%ReceiptProps($B6, -4, 0, $49, 2, $04, $F36A, $FF) ; B6 - 
%ReceiptProps($B7, -4, 0, $49, 2, $04, $F36A, $FF) ; B7 - 
%ReceiptProps($B8, -4, 0, $49, 2, $04, $F36A, $FF) ; B8 - 
%ReceiptProps($B9, -4, 0, $49, 2, $04, $F36A, $FF) ; B9 - 
%ReceiptProps($BA, -4, 0, $49, 2, $04, $F36A, $FF) ; BA - 
%ReceiptProps($BB, -4, 0, $49, 2, $04, $F36A, $FF) ; BB - 
%ReceiptProps($BC, -4, 0, $49, 2, $04, $F36A, $FF) ; BC - 
%ReceiptProps($BD, -4, 0, $49, 2, $04, $F36A, $FF) ; BD - 
%ReceiptProps($BE, -4, 0, $49, 2, $04, $F36A, $FF) ; BE - 
%ReceiptProps($BF, -4, 0, $49, 2, $04, $F36A, $FF) ; BF - 
%ReceiptProps($C0, -4, 0, $49, 2, $04, $F36A, $FF) ; C0 - 
%ReceiptProps($C1, -4, 0, $49, 2, $04, $F36A, $FF) ; C1 - 
%ReceiptProps($C2, -4, 0, $49, 2, $04, $F36A, $FF) ; C2 - 
%ReceiptProps($C3, -4, 0, $49, 2, $04, $F36A, $FF) ; C3 - 
%ReceiptProps($C4, -4, 0, $49, 2, $04, $F36A, $FF) ; C4 - 
%ReceiptProps($C5, -4, 0, $49, 2, $04, $F36A, $FF) ; C5 - 
%ReceiptProps($C6, -4, 0, $49, 2, $04, $F36A, $FF) ; C6 - 
%ReceiptProps($C7, -4, 0, $49, 2, $04, $F36A, $FF) ; C7 - 
%ReceiptProps($C8, -4, 0, $49, 2, $04, $F36A, $FF) ; C8 - 
%ReceiptProps($C9, -4, 0, $49, 2, $04, $F36A, $FF) ; C9 - 
%ReceiptProps($CA, -4, 0, $49, 2, $04, $F36A, $FF) ; CA - 
%ReceiptProps($CB, -4, 0, $49, 2, $04, $F36A, $FF) ; CB - 
%ReceiptProps($CC, -4, 0, $49, 2, $04, $F36A, $FF) ; CC - 
%ReceiptProps($CD, -4, 0, $49, 2, $04, $F36A, $FF) ; CD - 
%ReceiptProps($CE, -4, 0, $49, 2, $04, $F36A, $FF) ; CE - 
%ReceiptProps($CF, -4, 0, $49, 2, $04, $F36A, $FF) ; CF - 
%ReceiptProps($D0, -4, 0, $49, 2, $04, $F36A, $FF) ; D0 - 
%ReceiptProps($D1, -4, 0, $49, 2, $04, $F36A, $FF) ; D1 - 
%ReceiptProps($D2, -4, 0, $49, 2, $04, $F36A, $FF) ; D2 - 
%ReceiptProps($D3, -4, 0, $49, 2, $04, $F36A, $FF) ; D3 - 
%ReceiptProps($D4, -4, 0, $49, 2, $04, $F36A, $FF) ; D4 - 
%ReceiptProps($D5, -4, 0, $49, 2, $04, $F36A, $FF) ; D5 - 
%ReceiptProps($D6, -4, 0, $49, 2, $04, $F36A, $FF) ; D6 - 
%ReceiptProps($D7, -4, 0, $49, 2, $04, $F36A, $FF) ; D7 - 
%ReceiptProps($D8, -4, 0, $49, 2, $04, $F36A, $FF) ; D8 - 
%ReceiptProps($D9, -4, 0, $49, 2, $04, $F36A, $FF) ; D9 - 
%ReceiptProps($DA, -4, 0, $49, 2, $04, $F36A, $FF) ; DA - 
%ReceiptProps($DB, -4, 0, $49, 2, $04, $F36A, $FF) ; DB - 
%ReceiptProps($DC, -4, 0, $49, 2, $04, $F36A, $FF) ; DC - 
%ReceiptProps($DD, -4, 0, $49, 2, $04, $F36A, $FF) ; DD - 
%ReceiptProps($DE, -4, 0, $49, 2, $04, $F36A, $FF) ; DE - 
%ReceiptProps($DF, -4, 0, $49, 2, $04, $F36A, $FF) ; DF - 
%ReceiptProps($E0, -4, 0, $49, 2, $04, $F36A, $FF) ; E0 - 
%ReceiptProps($E1, -4, 0, $49, 2, $04, $F36A, $FF) ; E1 - 
%ReceiptProps($E2, -4, 0, $49, 2, $04, $F36A, $FF) ; E2 - 
%ReceiptProps($E3, -4, 0, $49, 2, $04, $F36A, $FF) ; E3 - 
%ReceiptProps($E4, -4, 0, $49, 2, $04, $F36A, $FF) ; E4 - 
%ReceiptProps($E5, -4, 0, $49, 2, $04, $F36A, $FF) ; E5 - 
%ReceiptProps($E6, -4, 0, $49, 2, $04, $F36A, $FF) ; E6 - 
%ReceiptProps($E7, -4, 0, $49, 2, $04, $F36A, $FF) ; E7 - 
%ReceiptProps($E8, -4, 0, $49, 2, $04, $F36A, $FF) ; E8 - 
%ReceiptProps($E9, -4, 0, $49, 2, $04, $F36A, $FF) ; E9 - 
%ReceiptProps($EA, -4, 0, $49, 2, $04, $F36A, $FF) ; EA - 
%ReceiptProps($EB, -4, 0, $49, 2, $04, $F36A, $FF) ; EB - 
%ReceiptProps($EC, -4, 0, $49, 2, $04, $F36A, $FF) ; EC - 
%ReceiptProps($ED, -4, 0, $49, 2, $04, $F36A, $FF) ; ED - 
%ReceiptProps($EE, -4, 0, $49, 2, $04, $F36A, $FF) ; EE - 
%ReceiptProps($EF, -4, 0, $49, 2, $04, $F36A, $FF) ; EF - 
%ReceiptProps($F0, -4, 0, $49, 2, $04, $F36A, $FF) ; F0 - 
%ReceiptProps($F1, -4, 0, $49, 2, $04, $F36A, $FF) ; F1 - 
%ReceiptProps($F2, -4, 0, $49, 2, $04, $F36A, $FF) ; F2 - 
%ReceiptProps($F3, -4, 0, $49, 2, $04, $F36A, $FF) ; F3 - 
%ReceiptProps($F4, -4, 0, $49, 2, $04, $F36A, $FF) ; F4 - 
%ReceiptProps($F5, -4, 0, $49, 2, $04, $F36A, $FF) ; F5 - 
%ReceiptProps($F6, -4, 0, $49, 2, $04, $F36A, $FF) ; F6 - 
%ReceiptProps($F7, -4, 0, $49, 2, $04, $F36A, $FF) ; F7 - 
%ReceiptProps($F8, -4, 0, $49, 2, $04, $F36A, $FF) ; F8 - 
%ReceiptProps($F9, -4, 0, $49, 2, $04, $F36A, $FF) ; F9 - 
%ReceiptProps($FA, -4, 0, $49, 2, $04, $F36A, $FF) ; FA - 
%ReceiptProps($FB, -4, 0, $49, 2, $04, $F36A, $FF) ; FB - 
%ReceiptProps($FC, -4, 0, $49, 2, $04, $F36A, $FF) ; FC - 
%ReceiptProps($FD, -4, 0, $49, 2, $04, $F36A, $FF) ; FD - 
%ReceiptProps($FE, -4, 0, $49, 2, $04, $F36A, $FF) ; FE - Server request (async)
%ReceiptProps($FF, -4, 0, $49, 2, $04, $F36A, $FF) ; FF - 


;--------------------------------------------------------------------------------
BottleListExpanded:
    db $16, $2B, $2C, $2D, $3D, $3C, $48

PotionListExpanded:
    db $2E, $2F, $30, $FF, $0E
;--------------------------------------------------------------------------------
Link_ReceiveItemAlternatesExpanded:
{
    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1
    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1 ; db -1,  -1,  -1,  -1, $44,  -1,  -1,  -1

    db -1,  -1, $35,  -1,  -1,  -1,  -1,  -1
    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1

    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1
    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1 ; db -1,  -1, $46,  -1,  -1,  -1,  -1,  -1

    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1
    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1

    db -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1
    db -1,  -1,  -1,  -1

	db -1,  -1,  -1,  -1
	db -1 ; Master Sword (Safe)
	db -1,  -1,  -1,  -1 ; +5/+10 Bomb Arrows
	db -1,  -1,  -1 ; 3x Programmable Item
	db -1 ; Upgrade-Only Silver Arrows
	db -1 ; 1 Rupoor
	db -1 ; Null Item
	db -1, -1, -1 ; Red, Blue & Green Clocks
	db -1, -1, -1, -1 ; Progressive Sword, Shield, Armor & Gloves
	db -1, -1 ; RNG Single & Multi
	db -1, -1 ; Progressive Bow
	db -1, -1, -1, -1 ; Unused
	db -1, -1 ; Goal Item Single, Multi & Alt Multi
	db -1, -1, -1, -1 ; Unused
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Free Map
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Free Compass
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Free Big Key
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Free Small Key
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Unused
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Unused
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Unused
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Unused
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ; Unused
}
;--------------------------------------------------------------------------------
.loadAlternate
	PHB : PHK : PLB
		TYA : JSR AttemptItemSubstitution : STA.b Scrap03
		CPY.b Scrap03 : BNE + : LDA.b #$FF : STA.b Scrap03 : +
	PLB
RTL
;--------------------------------------------------------------------------------
;Return BowEquipment but also draw silver arrows if you have the upgrade even if you don't have the bow
CheckHUDSilverArrows:
	LDA.l ArrowMode : BEQ .normal
	.rupee_arrows
		JSL.l DrawHUDArrows
		LDA.l BowEquipment
		RTL
	.normal
	LDA.l BowEquipment : BNE +
		LDA.l BowTracking : AND.b #$40 : BEQ ++
			JSL.l DrawHUDArrows
		++
		LDA.l BowEquipment
	+
RTL
;--------------------------------------------------------------------------------
DrawHUDArrows:
LDA.l ArrowMode : BEQ .normal
	.rupee_arrows

	LDA.l CurrentArrows : BEQ .none ; assuming silvers will increment this. if we go with something else, reorder these checks
	LDA.l BowEquipment : BNE +
	LDA.l BowTracking : AND.b #$40 : BNE .silver
	BRA .wooden
	+ CMP.b #03 : !BGE .silver

	.wooden
	LDA.b #$A7 : STA.l HUDTileMapBuffer+$20 ; draw wooden arrow marker
	LDA.b #$20 : STA.l HUDTileMapBuffer+$21
	LDA.b #$A9 : STA.l HUDTileMapBuffer+$22
	LDA.b #$20 : STA.l HUDTileMapBuffer+$23
RTL
	.normal ; in normal arrow mode this function is only ever called for silvers
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
			INX : CPX.b #$7F : !BLT + : LDA.b #$00 : BRA +++ : + ; default to 0 if too many attempts
			CMP.l RNGSingleTableSize : !BGE .single_reroll
		+++

		STA.w ScratchBufferV ; put our index value here
		LDX.b #$00
		TAY
		.recheck
			TYA
			JSR.w CheckSingleItem : BEQ .single_unused ; already used
				LDA.w ScratchBufferV : INC ; increment index
				CMP.l RNGSingleTableSize : !BLT +++ : LDA.b #$00 : +++ ; rollover index if needed
				STA.w ScratchBufferV ; store index
				INX : TAY : TXA : CMP.l RNGSingleTableSize : !BLT .recheck
				LDA.b #$5A ; everything is gone, default to null item - MAKE THIS AN OPTION FOR THIS AND THE OTHER ONE
				BRA .single_done
		.single_unused
			LDA.w ScratchBufferV
		.single_done
			TAX : LDA.l RNGSingleItemTable, X
			XBA : LDA.w ScratchBufferV : STA.l RNGLockIn : XBA
	PLY
RTL
;--------------------------------------------------------------------------------
CheckSingleItem:
	LSR #3 : TAX
	LDA.l RNGItem, X : STA.w ScratchBufferV+2 ; load value to temporary
	PHX
		LDA.w ScratchBufferV : AND.b #$07 : TAX ; load 0-7 part into X
		LDA.w ScratchBufferV+2
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
	LSR #3 : STA.w ScratchBufferV+1 : TAX
	LDA.l RNGItem, X
	STA.w ScratchBufferV+2
	LDA.w ScratchBufferV : AND.b #$07 : TAX ; load 0-7 part into X
	LDA.b #01
	---
	CPX.b #$00 : BEQ +++
		ASL
		DEX
	BRA ---
	+++

	PHA
		LDA.w ScratchBufferV+1 : TAX
	PLA
	ORA.w ScratchBufferV+2
	STA.l RNGItem, X
RTS
;--------------------------------------------------------------------------------
GetRNGItemMulti:
	LDA.l RNGLockIn : CMP.b #$FF : BEQ + : TAX : XBA : LDA.l RNGMultiItemTable, X : RTL : +
	LDX.b #$00
	- ; reroll
		JSL.l GetRandomInt : AND.b #$7F ; select random value
		INX : CPX.b #$7F : !BLT + : LDA.b 00 : BRA .done : + ; default to 0 if too many attempts
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
                        CMP.l ItemSubstitutionRules+1, X : !BLT +
                                LDA.l ItemSubstitutionRules+2, X : STA.b 1,S
                        +: BEQ .exit
                        .noMatch
                                INX #4
                                BRA -
        .exit
        PLA : PLX
RTS
;--------------------------------------------------------------------------------
CountBottles:
        PHX
        LDX.b #$00
        LDA.l BottleContentsOne : BEQ ++ : INX
        ++ : LDA.l BottleContentsTwo : BEQ ++ : INX
        ++ : LDA.l BottleContentsThree : BEQ ++ : INX
        ++ : LDA.l BottleContentsFour : BEQ ++ : INX
        ++
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
; Set a flag in SRAM if we pick up a compass in its own dungeon with HUD compass
; counts on
MaybeFlagCompassTotalPickup:
        LDA.l CompassMode : AND.b #$0F : BEQ .done
        LDA.w DungeonID : CMP.b #$FF : BEQ .done
        LSR : STA.b Scrap04 : LDA.b #$0F : !SUB Scrap04    ; Compute flag "index"
        CPY.b #$25 : BEQ .setFlag                          ; Set flag if it's a compass for this dungeon
                STA.b Scrap04
                TYA : AND.b #$0F : CMP.b Scrap04 : BNE .done ; Check if compass is for this dungeon
                        .setFlag
                        CMP.b #$08 : !BGE ++
                                %ValueShift()
                                ORA.l CompassCountDisplay : STA.l CompassCountDisplay
                                BRA .done
                        ++
                                !SUB #$08
                                %ValueShift()
                                BIT.b #$C0 : BEQ + : LDA.b #$C0 : + ; Make Hyrule Castle / Sewers Count for Both
                                ORA.l CompassCountDisplay+1 : STA.l CompassCountDisplay+1
        .done
RTL
;--------------------------------------------------------------------------------
; Set the compass count display flag if we're entering a dungeon and alerady have
; that compass
MaybeFlagCompassTotalEntrance:
        LDX.w DungeonID : CPX.b #$FF : BEQ .done         ; Skip if we're not entering dungeon
        LDA.l CompassMode : AND.w #$000F : BEQ .done ; Skip if we're not showing compass counts
        CMP.w #$0002 : BEQ .countShown
                LDA.l CompassField : AND.l DungeonItemMasks, X : BEQ .done ; skip if we don't have compass
                .countShown
                SEP #$20
                TXA : LSR : STA.b Scrap04 : LDA.b #$0F : !SUB Scrap04 ; Compute flag index
                CMP.b #$08 : !BGE ++
                        %ValueShift()
                        ORA.l CompassCountDisplay : STA.l CompassCountDisplay
                        REP #$20
                        BRA .done
                ++
                        !SUB #$08
                        %ValueShift()
                        BIT.b #$C0 : BEQ + : LDA.b #$C0 : + ; Make Hyrule Castle / Sewers Count for Both
                        ORA.l CompassCountDisplay+1 : STA.l CompassCountDisplay+1
                        REP #$20
        .done
RTL
;--------------------------------------------------------------------------------
