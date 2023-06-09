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
; #$FE - Server Request (Asychronous Chest)
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

dw $0468, $0600, $0630, $0660, $0690, $06C0, $06F0, $0720 ; disassembly (incorrectly?) says this is $0270
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
; This is a temporary measure for Fish to have consistent addresses
org $A08800

.y_offsets
    db -5, -5, -5, -5, -5, -4, -4, -5
    db -5, -4, -4, -4, -2, -4, -4, -4

    db -4, -4, -4, -4, -4, -4, -4, -4
    db -4, -4, -4, -4, -4, -4, -4, -4

    db -4, -4, -4, -5, -4, -4, -4, -4
    db -4, -4, -2, -4, -4, -4, -4, -4

    db -4, -4, -4, -4, -2, -2, -2, -4
    db -4, -4, -4, -4, -4, -4, -4, -4

    db -4, -4, -2, -2, -4, -2, -4, -4
    db -4, -5, -4, -4
	;new
	db -4, -4, -4, -4
	db -5 ; Master Sword (Safe)
	db -4, -4, -4, -4 ; +5/+10 Bomb Arrows
	db -4, -4, -4 ; 3x Programmable Item
	db -4 ; Upgrade-Only Sivler Arrows
	db -4 ; 1 Rupoor
	db -4 ; Null Item
	db -4, -4, -4 ; Red, Blue & Green Clocks
	db -4, -4, -4, -4 ; Progressive Sword, Shield, Armor & Gloves
	db -4, -4 ; RNG Single & Multi
	db -4, -4 ; Progressive Bow x2
	db -4, -4, -4, -4 ; Unused
	db -4, -4, -4 ; Goal Item Single, Multi & Alt Multi
	db -4, -4, -4 ; Unused
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Free Map
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Free Compass
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Free Big Key
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Free Small Key
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Unused
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Unused
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Unused
	db -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4 ; Unused

.x_offsets
    db  4,  4,  4,  4,  4,  0,  0,  4
    db  4,  4,  4,  4,  5,  0,  0,  0

    db  0,  0,  0,  4,  0,  4,  0,  0
    db  4,  0,  0,  0,  0,  0,  0,  0

    db  0,  0,  0,  0,  4,  0,  0,  0
    db  0,  0,  5,  0,  0,  0,  0,  0

    db  0,  0,  0,  0,  4,  4,  4,  0
    db  0,  0,  0,  0,  0,  0,  0,  0

    db  0,  0,  4,  4,  0,  4,  0,  0
    db  0,  4,  0,  0
	;new
	db  0,  0,  0,  0
	db  4 ; Master Sword (Safe)
	db  0,  0,  0,  0 ; +5/+10 Bomb Arrows
	db  0,  0,  0 ; 3x Programmable Item
	db  0 ; Upgrade-Only Sivler Arrows
	db  4 ; 1 Rupoor
	db  0 ; Null Item
	db  0, 0, 0 ; Red, Blue & Green Clocks
	db  0, 0, 0, 0 ; Progressive Sword, Shield, Armor & Gloves
	db  0, 0 ; RNG Single & Multi
	db  0, 0 ; Progressive Bow x2
	db  0, 0, 0, 0 ; Unused
	db  0, 0, 0 ; Goal Item Single, Multi & Alt Multi
	db  0, 0, 0 ; Unused
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Free Map
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Free Compass
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Free Big Key
	;db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; *EVENT*
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Free Small Key
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Unused
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Unused
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Unused
	db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Unused

.item_graphics_indices
    db $06, $18, $18, $18, $2D, $20, $2E, $09
    db $09, $0A, $08, $05, $10, $0B, $2C, $1B

    db $1A, $1C, $14, $19, $0C, $07, $1D, $2F
    db $07, $15, $12, $0D, $0D, $0E, $11, $17

    db $28, $27, $04, $04, $0F, $16, $03, $13
    db $01, $1E, $10, $00, $00, $00, $00, $00

    db $00, $30, $22, $21, $24, $24, $24, $23
    db $23, $23, $29, $2A, $2C, $2B, $03, $03

    db $34, $35, $31, $33, $02, $32, $36, $37
    db $2C, $06, $0C, $38
	;new
	db $39, $3A, $3B, $3C
	;5x
	db $18 ; Master Sword (Safe)
	db $3D, $3E, $3F, $40 ; +5/+10 Bomb Arrows
	db $00, $00, $00 ; 3x Programmable Item
	db $41 ; Upgrade-Only Sivler Arrows
	db $24 ; 1 Rupoor
	db $47 ; Null Item
	db $48, $48, $48 ; Red, Blue & Green Clocks
	db $FF, $FF, $04, $0D ; Progressive Sword, Shield, Armor & Gloves
	db $FF, $FF ; RNG Single & Multi
	db $FF, $FF ; Progressive Bow x2
	db $FF, $FF, $FF, $FF ; Unused
	db $49, $4A, $49 ; Goal Item Single, Multi & Alt Multi
	db $FF, $FF, $FF ; Unused
	db $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21 ; Free Map
	db $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16 ; Free Compass
	db $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22 ; Free Big Key
	db $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F ; Free Small Key
	;db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; *EVENT*
	;db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; *EVENT*
	;db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; *EVENT*
	;db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; *EVENT*

	db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; Unused
	db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; Unused
	db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; Unused
	db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49 ; Unused

.wide_item_flag
    db $00, $00, $00, $00, $00, $02, $02, $00
    db $00, $00, $00, $00, $00, $02, $02, $02

    db $02, $02, $02, $00, $02, $00, $02, $02
    db $00, $02, $02, $02, $02, $02, $02, $02

    db $02, $02, $02, $02, $00, $02, $02, $02
    db $02, $02, $00, $02, $02, $02, $02, $02

    db $02, $02, $02, $02, $00, $00, $00, $02
    db $02, $02, $02, $02, $02, $02, $02, $02

    db $02, $02, $00, $00, $02, $00, $02, $02
    db $02, $00, $02, $02
	;new
	db $02, $02, $02, $02
	db $00 ; Master Sword (Safe)
	db $02, $02, $02, $02 ; +5/+10 Bomb Arrows
	db $02, $02, $02 ; 3x Programmable Item
	db $02 ; Upgrade-Only Sivler Arrows
	db $00 ; 1 Rupoor
	db $02 ; Null Item
	db $02, $02, $02 ; Red, Blue & Green Clocks
	db $02, $02, $02, $02 ; Progressive Sword, Shield, Armor & Gloves
	db $02, $02 ; RNG Single & Multi
	db $02, $02 ; Progressive Bow x2
	db $02, $02, $02, $02 ; Unused
	db $02, $02, $02 ; Goal Item Single, Multi & Alt Multi
	db $02, $02, $02 ; Unused
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Free Map
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Free Compass
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Free Big Key
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; Free Small Key

	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Unused
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Unused
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Unused
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Unused
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02 ; Unused

.properties
    db  5, -1,  5,  5,  5,  5,  5,  1
    db  2,  1,  1,  1,  2,  2,  2,  4

    db  4,  4,  1,  1,  2,  1,  1,  1
    db  2,  1,  2,  1,  4,  4,  2,  1

    db  6,  1,  2,  1,  2,  2,  1,  2
    db  2,  4,  1,  1,  4,  2,  1,  4

    db  2,  2,  4,  4,  4,  2,  1,  4
    db  1,  2,  2,  1,  2,  2,  1,  1

    db  4,  4,  1,  2,  2,  4,  4,  4
    db  2,  5,  2,  1
	;new
	db  4,  4,  4,  4
	db  5 ; Master Sword (Safe)
	db  4,  4,  4,  4 ; +5/+10 Bomb Arrows
	db  4,  4,  4 ; 3x Programmable Item
	db  1 ; Upgrade-Only Sivler Arrows
	db  3 ; 1 Rupoor
	db  1 ; Null Item
	db  1, 2, 4 ; Red, Blue & Green Clocks
	db  $FF, $FF, $FF, $FF ; Progressive Sword, Shield, Armor & Gloves
	db  $FF, $FF ; RNG Single & Multi
	db  0, 0 ; Progressive Bow
	db  0, 0, 0, 0 ; Unused
	db  4, 4, 4 ; Goal Item Single, Multi & Alt Multi
	db  0, 0, 0 ; Unused
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Free Map
	db  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 ; Free Compass
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Free Big Key
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Free Small Key
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Unused
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Unused
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Unused
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Unused
	db  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ; Unused

; \item Target SRAM addresses for items you receive
.item_target_addr
    dw $F359, $F359, $F359, $F359, $F35A, $F35A, $F35A, $F345
    dw $F346, $F34B, $F342, $F340, $F341, $F344, $F35C, $F347

    dw $F348, $F349, $F34A, $F34C, $F34C, $F350, $F35C, $F36B
    dw $F351, $F352, $F353, $F354, $F354, $F34E, $F356, $F357

    dw $F37A, $F34D, $F35B, $F35B, $F36F, $F364, $F36C, $F375
    dw $F375, $F344, $F341, $F35C, $F35C, $F35C, $F36D, $F36E

    dw $F36E, $F375, $F366, $F368, $F360, $F360, $F360, $F374
    dw $F374, $F374, $F340, $F340, $F35C, $F35C, $F36C, $F36C

    dw $F360, $F360, $F372, $F376, $F376, $F373, $F360, $F360
    dw $F35C, $F359, $F34C, $F355
	;new
	dw $F375, $F376, $F373, $F373
	dw $F359 ; Master Sword (Safe)
	dw $F375, $F375, $F376, $F376 ; +5/+10 Bomb Arrows
	dw $F41A, $F41C, $F41E ; 3x Programmable Item
	dw $F340 ; Upgrade-Only Silver Arrows
	dw $F360 ; 1 Rupoor
	dw $F36A ; Null Item
	dw $F454, $F454, $F454 ; Red, Blue & Green Clocks
	dw $F359, $F35A, $F35B, $F354 ; Progressive Sword, Shield, Armor & Gloves
	dw $F36A, $F36A ; RNG Single & Multi
	dw $F340, $F340 ; Progressive Bow x2
	dw $F36A, $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A ; Goal Item Single, Multi & Alt Multi
	dw $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Free Map
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Free Compass
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Free Big Key
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Free Small Key
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Unused
	dw $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A, $F36A ; Unused
}

; DATA Values to write to the above SRAM locations.
{
.item_values
    db $01, $02, $03, $04, $01, $02, $03, $01
    db $01, $01, $01, $01, $01, $02, $FF, $01

    db $01, $01, $01, $01, $02, $01, $FF, $FF
    db $01, $01, $02, $01, $02, $01, $01, $01

    db $FF, $01, $FF, $02, $FF, $FF, $FF, $FF
    db $FF, $FF, $02, $FF, $FF, $FF, $FF, $FF

    db $FF, $FF, $FF, $FF, $FF, $FB, $EC, $FF
    db $FF, $FF, $01, $03, $FF, $FF, $FF, $FF

    db $9C, $CE, $FF, $01, $0A, $FF, $FF, $FF
    db $FF, $01, $03, $01
	;new
	db $32, $46, $80, $80
	db $02 ; Master Sword (Safe)
	db $FF, $FF, $FF, $FF ; +5/+10 Bomb Arrows
	db $FF, $FF, $FF ; 3x Programmable Item
	db $FF ; Upgrade-Only Sivler Arrows
	db $FF ; 1 Rupoor
	db $FF ; Null Item
	db $FF, $FF, $FF ; Red, Blue & Green Clocks
	db $FF, $FF, $FF, $FF ; Progressive Sword, Shield, Armor & Gloves
	db $FF, $FF ; RNG Single & Multi
	db $FF, $FF ; Progressive Bow
	db $FF, $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF ; Goal Item Single, Multi & Alt Multi
	db $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Free Map
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Free Compass
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Free Big Key
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Free Small Key
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; Unused

    ;0x00 - Sewer Passage
    ;0x02 - Hyrule Castle
    ;0x04 - Eastern Palace
    ;0x06 - Desert Palace
    ;0x08 - Hyrule Castle 2
    ;0x0A - Swamp Palace
    ;0x0C - Dark Palace
    ;0x0E - Misery Mire
    ;0x10 - Skull Woods
    ;0x12 - Ice Palace
    ;0x14 - Tower of Hera
    ;0x16 - Gargoyle's Domain
    ;0x18 - Turtle Rock
    ;0x1A - Ganon's Tower

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
                CMP.b 1,s : BNE .noMatch
                        .match
                        PHX
                        TXA : LSR #2 : TAX
                        LDA.l ItemLimitCounts, X
                        PLX
                        CMP.l ItemSubstitutionRules+1, X : !BLT +
                                LDA.l ItemSubstitutionRules+2, X : STA.b 1,s
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
; Set the dungeon item count display flags if we're entering a dungeon and have the
; corresponding dungeon item
MaybeFlagDungeonTotalsEntrance:
        LDX.w DungeonID : CPX.b #$FF : BEQ .done ; Skip if we're not entering dungeon
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
        CMP.w #$0002 : BEQ .compassShown
                LDA.l CompassField : AND.l DungeonItemMasks, X : BEQ .done ; skip if we don't have compass
                .compassShown
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
RTS
;--------------------------------------------------------------------------------
FlagMapCount:
        CMP.w #$0002 : BEQ .mapShown
                LDA.l MapField : AND.l DungeonItemMasks, X : BEQ .done ; skip if we don't have map
                .mapShown
                SEP #$20
                TXA : LSR : STA.b Scrap04 : LDA.b #$0F : !SUB Scrap04 ; Compute flag index
                CMP.b #$08 : !BGE ++
                        %ValueShift()
                        ORA.l MapCountDisplay : STA.l MapCountDisplay
                        REP #$20
                        BRA .done
                ++
                        !SUB #$08
                        %ValueShift()
                        BIT.b #$C0 : BEQ + : LDA.b #$C0 : + ; Make Hyrule Castle / Sewers Count for Both
                        ORA.l MapCountDisplay+1 : STA.l MapCountDisplay+1
                        REP #$20
        .done
RTS
;--------------------------------------------------------------------------------
MaybeFlagMapTotalPickup:
        LDA.l MapHUDMode : AND.b #$0F : BEQ .done
        LDA.w DungeonID : CMP.b #$FF : BEQ .done
        LSR : STA.b Scrap04 : LDA.b #$0F : !SUB Scrap04 ; Compute flag "index"
        CPY.b #$33 : BEQ .setFlag                       ; Set flag if it's a compass for this dungeon
                STA.b Scrap04
                TYA : AND.b #$0F : CMP.b Scrap04 : BNE .done ; Check if map is for this dungeon
                        .setFlag
                        CMP.b #$08 : !BGE ++
                                %ValueShift()
                                ORA.l MapCountDisplay : STA.l MapCountDisplay
                                BRA .done
                        ++
                                !SUB #$08
                                %ValueShift()
                                BIT.b #$C0 : BEQ + : LDA.b #$C0 : + ; Make Hyrule Castle / Sewers Count for Both
                                ORA.l MapCountDisplay+1 : STA.l MapCountDisplay+1
        .done
RTL
;--------------------------------------------------------------------------------

