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
; #$6D- Server Request
; #$6E - Server Request (Dungeon Drop)
; #$70 - Maps
; #$80 - Compasses
; #$90 - Big Keys
; #$A0 - Small Keys
;--------------------------------------------------------------------------------
;GetAnimatedSpriteGfxFile:
;    LDY.b #$32
;    CMP.b #$39 : BCS +      ; If tile index >= 0x39, use sprite file 0x32 (Blank file)
;
;    LDY.b #$5D
;
;    CMP.b #$23 : BEQ +      ; If tile index is 0x23 (Pendant)...
;    CMP.b #$37 : BCS +      ; ...or tile index >= 0x37, use sprite file 0x5D (Pendant, Boots, 20 Rupees)
;
;    LDY.b #$5C
;
;    CMP.b #$0C : BEQ +      ; If tile index is 0x0C (Flute)...
;    CMP.b #$24 : BCS +      ; ...or tile index >= 24, use sprite file 0x5C (Rupees, Crystal, Heart Piece ... ...)
;
;    ; Otherwise, use sprite file 0x5B (Medallions, Mirror, Flippers, Lantern, Compass...)
;    LDY.b #$5B
;+
;JML GetAnimatedSpriteGfxFile_return
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
	LDA.b $00 : ADC.l GetAnimatedSpriteBufferPointer_table, X
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
!CHALLENGE_TIMER = "$7EF454"
!GOAL_COUNTER = "$7EF418"
!INVENTORY_SWAP_2 = "$7EF38E"
;--------------------------------------------------------------------------------
;carry clear if pass
;carry set if caught
;incsrc eventdata.asm
ProcessEventItems:
	;STA $FFFFFF
	LDA $00 : PHA
	LDA $01 : PHA
	LDA $02 : PHA
	PHY : PHP
	PHB : LDA.b #$AF : PHA : PLB
		LDA $02D8
		CMP.b #$E0 : BNE +
			REP #$30 ; set 16-bit accumulator & index registers
			LDA $7EF450 : ASL : TAX
			LDA.l EventDataOffsets, X : !ADD #EventDataTable : STA $00

			SEP #$20 ; set 8-bit accumulator
			LDA.b #$AF : STA $02

			JSL.l LoadDialogAddressIndirect
			LDA $7EF450 : INC : STA $7EF450

			SEP #$10 ; set 8-bit index registers

			LDA GoalItemRequirement : BEQ ++
			LDA !GOAL_COUNTER : INC : STA !GOAL_COUNTER
			CMP GoalItemRequirement : !BLT ++ 
			LDA TurnInGoalItems : BNE ++
				JSL.l ActivateGoal 
			++

			LDX.b #$01 : BRA .done
		+
		LDX.b #$00
	.done
	PLB
	PLP : PLY
	PLA : STA $02
	PLA : STA $01
	PLA : STA $00
RTS
;--------------------------------------------------------------------------------
AddReceivedItemExpandedGetItem:
	PHX

	;JSR.w ProcessEventItems : CPX.b #$00 : BEQ ++
	;	;JSL.l Main_ShowTextMessage_Alt
	;	LDA !GOAL_COUNTER : INC : STA !GOAL_COUNTER
	;	LDA.b #$01 : STA $7F50XX
	;	BRL .done
	;++
	;STA $FFFFFF
	LDA $02D8 ; check inventory
	JSL.l FreeDungeonItemNotice
	CMP.b #$0B : BNE + ; Bow
		LDA !INVENTORY_SWAP_2 : AND.b #$40 : BEQ ++
		LDA.l SilverArrowsUseRestriction : BNE ++
			LDA.b #03 : STA $7EF340 ; set bow to silver
		++
		BRL .done
	+ CMP.b #$3B : BNE + ; Silver Bow
		LDA $7EF376 : BNE ++ ; check arrows
			LDA.b #$03 : BRA +++ ; bow without arrow
		++
			LDA.b #$04 ; bow with arrow
		+++
		STA $7EF340
		LDA !INVENTORY_SWAP_2 : ORA #$40 : STA !INVENTORY_SWAP_2 ; mark silver bow on y-toggle
		BRL .done
	+ CMP.b #$4C : BNE + ; 50 bombs
		;LDA.b #$07 : STA $7EF370 ; upgrade bombs
		LDA.b #50 : !SUB.l StartingMaxBombs : STA $7EF370 ; upgrade bombs
		LDA.b #50 : STA $7EF375 ; fill bombs
		BRL .done
	+ CMP.b #$4D : BNE + ; 70 arrows
		;LDA #$07 : STA $7EF371 ; upgrade arrows
		LDA.b #70 : !SUB.l StartingMaxArrows : STA $7EF371 ; upgrade arrows
		LDA.b #70 : STA $7EF376 ; fill arrows
		BRL .done
	+ CMP.b #$4E : BNE + ; 1/2 magic
		LDA $7EF37B : CMP #$02 : !BGE ++
			INC : STA $7EF37B ; upgrade magic
		++
		LDA.b #$80 : STA $7EF373 ; fill magic
		BRL .done
	+ CMP.b #$4F : BNE + ; 1/4 magic
		LDA.b #$02 : STA $7EF37B ; upgrade magic
		LDA.b #$80 : STA $7EF373 ; fill magic
		BRL .done
	+ CMP.b #$50 : BNE + ; Master Sword (Safe)
		LDA $7EF359 : CMP.b #$02 : !BGE + ; skip if we have a better sword
		LDA.b #$02 : STA $7EF359 ; set master sword
		BRL .done
	+ CMP.b #$51 : BNE + ; +5 Bombs
		LDA $7EF370 : !ADD.b #$05 : STA $7EF370 ; upgrade bombs +5
		LDA.l Upgrade5BombsRefill : STA $7EF375 ; fill bombs
		BRL .done
	+ CMP.b #$52 : BNE + ; +10 Bombs
		LDA $7EF370 : !ADD.b #$0A : STA $7EF370 ; upgrade bombs +10
		LDA.l Upgrade10BombsRefill : STA $7EF375 ; fill bombs
		BRL .done
	+ CMP.b #$53 : BNE + ; +5 Arrows
		LDA $7EF371 : !ADD.b #$05 : STA $7EF371 ; upgrade arrows +5
		LDA.l Upgrade5ArrowsRefill : STA $7EF376 ; fill arrows
		BRL .done
	+ CMP.b #$54 : BNE + ; +10 Arrows
		LDA $7EF371 : !ADD.b #$0A : STA $7EF371 ; upgrade arrows +10
		LDA.l Upgrade10ArrowsRefill : STA $7EF376 ; fill arrows
		BRL .done
	+ CMP.b #$55 : BNE + ; Programmable Object 1
		%ProgrammableItemLogic(1)
		BRL .done
	+ CMP.b #$56 : BNE + ; Programmable Object 2
		%ProgrammableItemLogic(2)
		BRL .done
	+ CMP.b #$57 : BNE + ; Programmable Object 3
		%ProgrammableItemLogic(3)
		BRL .done
	+ CMP.b #$58 : BNE + ; Upgrade-Only Sivler Arrows
		LDA.l SilverArrowsUseRestriction : BNE +++
		LDA.l SilverArrowsAutoEquip : AND.b #$01 : BEQ +++
			LDA $7EF340 : BEQ ++ : CMP.b #$03 : !BGE ++
				!ADD.b #$02 : STA $7EF340 ; switch to silver bow
			++
		+++
		LDA.l ArrowMode : BEQ ++
			LDA.b #$01 : STA $7EF376
		++
	+ CMP.b #$59 : BNE + ; 1 Rupoor
		REP #$20 : LDA $7EF360 : !SUB RupoorDeduction : STA $7EF360 : SEP #$20 ; Take 1 rupee
		BRL .done
	+ CMP.b #$5A : BNE + ; Null Item
		BRL .done
	+ CMP.b #$5B : BNE + ; Red Clock
		REP #$20 ; set 16-bit accumulator
		LDA !CHALLENGE_TIMER : !ADD.l RedClockAmount : STA !CHALLENGE_TIMER
		LDA !CHALLENGE_TIMER+2 : ADC.l RedClockAmount+2 : STA !CHALLENGE_TIMER+2
		SEP #$20 ; set 8-bit accumulator
		BRL .done
	+ CMP.b #$5C : BNE + ; Blue Clock
		REP #$20 ; set 16-bit accumulator
		LDA !CHALLENGE_TIMER : !ADD.l BlueClockAmount : STA !CHALLENGE_TIMER
		LDA !CHALLENGE_TIMER+2 : ADC.l BlueClockAmount+2 : STA !CHALLENGE_TIMER+2
		SEP #$20 ; set 8-bit accumulator
		BRL .done
	+ CMP.b #$5D : BNE + ; Green Clock
		REP #$20 ; set 16-bit accumulator
		LDA !CHALLENGE_TIMER : !ADD.l GreenClockAmount : STA !CHALLENGE_TIMER
		LDA !CHALLENGE_TIMER+2 : ADC.l GreenClockAmount+2 : STA !CHALLENGE_TIMER+2
		SEP #$20 ; set 8-bit accumulator
		BRL .done
	+ CMP.b #$5E : BNE + ; Progressive Sword
		BRL .done
	+ CMP.b #$5F : BNE + ; Progressive Shield
		BRL .done
	+ CMP.b #$60 : BNE + ; Progressive Armor
		BRL .done
	+ CMP.b #$61 : BNE + ; Progressive Lifting Glove
		BRL .done
	+ CMP.b #$62 : BNE + ; RNG Pool Item (Single)
		BRL .done
	+ CMP.b #$63 : BNE + ; RNG Pool Item (Multi)
		BRL .done
	+ CMP.b #$64 : BNE + ; Progressive Bow
		BRL .done
	+ CMP.b #$65 : BNE + ; Progressive Bow
		BRL .done
	+ CMP.b #$6A : BNE + ; Goal Collectable (Single/Triforce)
		JSL.l ActivateGoal
		BRL .done
	+ CMP.b #$6B : BNE + ; Goal Collectable (Multi/Power Star)
		BRA .multi_collect
	+ CMP.b #$6C : BNE + ; Goal Collectable (Multi/Power Star) Alternate Graphic
		.multi_collect
		LDA GoalItemRequirement : BEQ ++
		LDA !GOAL_COUNTER : INC : STA !GOAL_COUNTER
		CMP GoalItemRequirement : !BLT ++
		LDA TurnInGoalItems : BNE ++
				JSL.l ActivateGoal
		++
		BRL .done
	+ CMP.b #$6D : BNE + ; Server Request
		JSL ItemGetServiceRequest
		BRL .done
	+ CMP.b #$6E : BNE + ; Server Request (Dungeon Drop)
		JSL ItemGetServiceRequest
		BRL .done
	+ CMP.b #$70 : !BLT + : CMP.b #$80 : !BGE + ; Free Map
		AND #$0F : CMP #$08 : !BGE ++
			%ValueShift()
			ORA $7EF368 : STA $7EF368 ; Map 1
			BRL .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA $7EF369 : STA $7EF369 ; Map 2
		BRL .done
	+ CMP.b #$80 : !BLT + : CMP.b #$90 : !BGE + ; Free Compass
		AND #$0F : CMP #$08 : !BGE ++
			%ValueShift()
			ORA $7EF364 : STA $7EF364 ; Compass 1
			BRL .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA $7EF365 : STA $7EF365 ; Compass 2
		BRL .done
	+ CMP.b #$90 : !BLT + : CMP.b #$A0 : !BGE + ; Free Big Key
		AND #$0F : CMP #$08 : !BGE ++
			%ValueShift()
			ORA $7EF366 : STA $7EF366 ; Big Key 1
			BRL .done
		++
			!SUB #$08
			%ValueShift()
			BIT.b #$C0 : BEQ +++ : LDA.b #$C0 : +++ ; Make Hyrule Castle / Sewers Count for Both
			ORA $7EF367 : STA $7EF367 ; Big Key 2
		BRL .done
	+ CMP.b #$A0 : !BLT + : CMP.b #$B0 : !BGE + ; Free Small Key
		AND #$0F : TAX
		LDA $7EF37C, X : INC : STA $7EF37C, X ; Increment Key Count

		CPX.b #$00 : BNE ++
			STA $7EF37D ; copy HC to sewers
		++ : CPX.b #$01 : BNE ++
			STA $7EF37C ; copy sewers to HC
		++

		LDA.l GenericKeys : BEQ +
		.generic
			LDA $7EF36F : INC : STA $7EF36F
			BRL .done
		.normal
			TXA : ASL : CMP $040C : BNE ++
				LDA $7EF36F : INC : STA $7EF36F
			++
			BRL .done
	+
	.done
	PLX
	LDA $02E9 : CMP.b #$01 ; thing we wrote over
RTL
; #$70 - Maps
; #$80 - Compasses
; #$90 - Big Keys
; #$A0 - Small Keys
;--------------------------------------------------------------------------------
!PROGRESSIVE_SHIELD = "$7EF416" ; ss-- ----
!RNG_ITEM = "$7EF450"
!SCRATCH_AREA = "$7F5020"
!SINGLE_INDEX_TEMP = "$7F5020"
!SINGLE_INDEX_OFFSET_TEMP = "$7F5021"
!SINGLE_INDEX_BITMASK_TEMP = "$7F5022"
!LOCK_IN = "$7F5090"
!ITEM_BUSY = "$7F5091"
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

		LDA $02D8 ; Item Value
		JSR AttemptItemSubstitution
		STA $02D8

		JSR IncrementItemCounters

		CMP.b #$16 : BNE ++ ; Bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$2B : BNE ++ ; Red Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$2C : BNE ++ ; Green Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$2D : BNE ++ ; Blue Potion w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$3C : BNE ++ ; Bee w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$3D : BNE ++ ; Fairy w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$48 : BNE ++ ; Gold Bee w/bottle
			JSR.w CountBottles : CMP.l BottleLimit : !BLT +++
				LDA.l BottleLimitReplacement : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$4E : BNE ++ ; Progressive Magic
			LDA $7EF37B : BEQ +++
				LDA.b #$4F : STA $02D8
			+++ : BRL .done
		++ : CMP.b #$5E : BNE ++ ; Progressive Sword
			LDA $7EF359 : CMP.l ProgressiveSwordLimit : !BLT +
				LDA.l ProgressiveSwordReplacement : STA $02D8 : BRL .done
			+ : CMP.b #$00 : BNE + ; No Sword
				LDA.b #$49 : STA $02D8 : BRL .done
			+ : CMP.b #$01 : BNE + ; Fighter Sword
				LDA.b #$50 : STA $02D8 : BRL .done
			+ : CMP.b #$02 : BNE + ; Master Sword
				LDA.b #$02 : STA $02D8 : BRL .done
			+ ; Everything Else
				LDA.b #$03 : STA $02D8 : BRL .done
		++ : CMP.b #$5F : BNE ++ ; Progressive Shield
			LDA !PROGRESSIVE_SHIELD : LSR #6 : CMP.l ProgressiveShieldLimit : !BLT +
				LDA.l ProgressiveShieldReplacement : STA $02D8 : BRL .done
			+
			LDA !PROGRESSIVE_SHIELD : AND.b #$C0 : BNE + ; No Shield
				LDA.b #$04 : STA $02D8
				LDA !PROGRESSIVE_SHIELD : !ADD.b #$40 : STA !PROGRESSIVE_SHIELD : BRL .done
			+ : CMP.b #$40 : BNE + ; Fighter Shield
				LDA.b #$05 : STA $02D8
				LDA !PROGRESSIVE_SHIELD : !ADD.b #$40 : STA !PROGRESSIVE_SHIELD : BRL .done
			+ ; Everything Else
				LDA.b #$06 : STA $02D8
				LDA !PROGRESSIVE_SHIELD : !ADD.b #$40 : STA !PROGRESSIVE_SHIELD : BRL .done
		++ : CMP.b #$60 : BNE ++ ; Progressive Armor
			LDA $7EF35B : CMP.l ProgressiveArmorLimit : !BLT +
				LDA.l ProgressiveArmorReplacement : STA $02D8 : BRL .done
			+ : CMP.b #$00 : BNE + ; No Armor
				LDA.b #$22 : STA $02D8 : BRL .done
			+ ; Everything Else
				LDA.b #$23 : STA $02D8 : BRA .done
		++ : CMP.b #$61 : BNE ++ ; Progressive Lifting Glove
			LDA $7EF354 : BNE + ; No Lift
				LDA.b #$1B : STA $02D8 : BRA .done
			+ ; Everything Else
				LDA.b #$1C : STA $02D8 : BRA .done
		++ : CMP.b #$64 : BNE ++ : -- ; Progressive Bow
			LDA $7EF340 : INC : LSR : CMP.l ProgressiveBowLimit : !BLT +
				LDA.l ProgressiveBowReplacement : STA $02D8 : BRL .done
			+ : CMP.b #$00 : BNE + ; No Bow
				LDA.b #$3A : STA $02D8 : BRA .done
			+ ; Any Bow
				LDA.b #$3B : STA $02D8 : BRA .done
		++ : CMP.b #$65 : BNE ++ ; Progressive Bow 2
			LDA #$20 : TSB !INVENTORY_SWAP_2
			BRA --
		++ : CMP.b #$62 : BNE ++ ; RNG Item (Single)
			JSL.l GetRNGItemSingle : STA $02D8
			XBA : JSR.w MarkRNGItemSingle
			LDA #$FF : STA !LOCK_IN ; clear lock-in
			BRA .done
		++ : CMP.b #$63 : BNE ++ ; RNG Item (Multi)
			JSL.l GetRNGItemMulti : STA $02D8
			LDA #$FF : STA !LOCK_IN ; clear lock-in
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
	dw $F340 ; Upgrade-Only Sivler Arrows
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
    dw $8000, $4000, $2000, $1000, $0800, $0400, $0200, $0100
    dw $0080, $0040, $0020, $0010, $0008, $0004, $0000, $0000

	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000, $0000, $0000, $0000
	db $00
	dw $0000 ; Caves
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
		;TYA : JSR IncrementItemCounters
		;LDA Link_ReceiveItemAlternatesExpanded, Y : STA $03
		TYA : JSR AttemptItemSubstitution : STA $03
		CPY $03 : BNE + : LDA.b #$FF : STA $03 : +
	PLB
RTL
;--------------------------------------------------------------------------------
;DrawHUDSilverArrows:
;	LDA $7EF340 : AND.w #$00FF : BNE +
;		LDA !INVENTORY_SWAP_2 : AND.w #$0040 : BEQ +
;	        LDA.w #$2810 : STA $11C8
;	        LDA.w #$2811 : STA $11CA
;	        LDA.w #$2820 : STA $1208
;	        LDA.w #$2821 : STA $120A
;	+
;	LDA.w #$11CE : STA $00 ; thing we wrote over
;RTL
;--------------------------------------------------------------------------------
;Return $7EF340 but also draw silver arrows if you have the upgrade even if you don't have the bow
CheckHUDSilverArrows:
	LDA.l ArrowMode : BEQ .normal
	.rupee_arrows
		JSL.l DrawHUDArrows
		LDA $7EF340
		RTL
	.normal
	LDA $7EF340 : BNE +
		LDA !INVENTORY_SWAP_2 : AND.b #$40 : BEQ ++
			JSL.l DrawHUDArrows
		++
		LDA $7EF340
	+
RTL
;--------------------------------------------------------------------------------
DrawHUDArrows:
LDA.l ArrowMode : BEQ .normal
	.rupee_arrows

	LDA $7EF377 : BEQ .none ; assuming silvers will increment this. if we go with something else, reorder these checks
	LDA $7EF340 : BNE +
	LDA !INVENTORY_SWAP_2 : AND.b #$40 : BNE .silver
	BRA .wooden
	+ CMP.b #03 : !BGE .silver

	.wooden
	LDA.b #$A7 : STA $7EC720 ; draw wooden arrow marker
	LDA.b #$20 : STA $7EC721
	LDA.b #$A9 : STA $7EC722
	LDA.b #$20 : STA $7EC723
RTL
	.normal ; in normal arrow mode this function is only ever called for silvers
	.silver
	LDA.b #$86 : STA $7EC720 ; draw silver arrow marker
	LDA.b #$24 : STA $7EC721
	LDA.b #$87 : STA $7EC722
	LDA.b #$24 : STA $7EC723
RTL
	.none
	LDA.b #$7F : STA $7EC720 ; draw no arrow marker
	LDA.b #$24 : STA $7EC721
	LDA.b #$7F : STA $7EC722
	LDA.b #$24 : STA $7EC723
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM = "$7EF450"
!SCRATCH_AREA = "$7F5020"
!SINGLE_INDEX_TEMP = "$7F5020"
!SINGLE_INDEX_OFFSET_TEMP = "$7F5021"
!SINGLE_INDEX_BITMASK_TEMP = "$7F5022"
!LOCK_IN = "$7F5090"
GetRNGItemSingle:
	PHY
		LDA !LOCK_IN : CMP.b #$FF : BEQ + : TAX : XBA : LDA.l RNGSingleItemTable, X : RTL : +
		LDX.b #$00
		.single_reroll
			JSL.l GetRandomInt : AND.b #$7F ; select random value
			INX : CPX #$7F : !BLT + : LDA.b #$00 : BRA +++ : + ; default to 0 if too many attempts
			CMP.l RNGSingleTableSize : !BGE .single_reroll
		+++

		STA !SINGLE_INDEX_TEMP ; put our index value here
		LDX #$00
		TAY
		.recheck
			TYA
			JSR.w CheckSingleItem : BEQ .single_unused ; already used
				LDA !SINGLE_INDEX_TEMP : INC ; increment index
				CMP.l RNGSingleTableSize : !BLT +++ : LDA.b #$00 : +++ ; rollover index if needed
				STA !SINGLE_INDEX_TEMP ; store index
				INX : TAY : TXA : CMP.l RNGSingleTableSize : !BLT .recheck
				LDA.b #$5A ; everything is gone, default to null item - MAKE THIS AN OPTION FOR THIS AND THE OTHER ONE
				BRA .single_done
		.single_unused
			LDA !SINGLE_INDEX_TEMP
		.single_done
			TAX : LDA.l RNGSingleItemTable, X
			XBA : LDA.l !SINGLE_INDEX_TEMP : STA !LOCK_IN : XBA
	PLY
RTL
;--------------------------------------------------------------------------------
CheckSingleItem:
	LSR #3 : TAX
	LDA.l !RNG_ITEM, X : STA !SINGLE_INDEX_BITMASK_TEMP ; load value to temporary
	PHX
		LDA !SINGLE_INDEX_TEMP : AND #$07 : TAX ; load 0-7 part into X
		LDA !SINGLE_INDEX_BITMASK_TEMP
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
	;STA !SINGLE_INDEX_TEMP

	LSR #3 : STA !SINGLE_INDEX_OFFSET_TEMP : TAX
	LDA.l !RNG_ITEM, X
	STA.l !SINGLE_INDEX_BITMASK_TEMP
	LDA.l !SINGLE_INDEX_TEMP : AND #$07 : TAX ; load 0-7 part into X
	LDA.b #01
	---
	CPX.b #$00 : BEQ +++
		ASL
		DEX
	BRA ---
	+++

	PHA
		LDA.l !SINGLE_INDEX_OFFSET_TEMP : TAX
	PLA
	ORA.l !SINGLE_INDEX_BITMASK_TEMP
	STA.l !RNG_ITEM, X
RTS
;--------------------------------------------------------------------------------
GetRNGItemMulti:
	LDA !LOCK_IN : CMP #$FF : BEQ + : TAX : XBA : LDA.l RNGMultiItemTable, X : RTL : +
	LDX.b #$00
	- ; reroll
		JSL.l GetRandomInt : AND.b #$7F ; select random value
		INX : CPX #$7F : !BLT + : LDA.b 00 : BRA .done : + ; default to 0 if too many attempts
		CMP.l RNGMultiTableSize : !BGE -
	.done
	STA !LOCK_IN
	TAX : XBA : LDA.l RNGMultiItemTable, X
RTL
;--------------------------------------------------------------------------------
IncrementItemCounters:
	PHX : PHA
		LDX.b #$00
		-
			LDA.l ItemSubstitutionRules, X
			CMP.b #$FF : BEQ .exit
			CMP 1,s : BNE .noMatch
				.match
					PHX
						TXA : LSR #2 : TAX
						LDA !ITEM_LIMIT_COUNTS, X : INC : STA !ITEM_LIMIT_COUNTS, X
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
		CMP 1,s : BNE .noMatch
			.match
				PHX
					TXA : LSR #2 : TAX
					LDA !ITEM_LIMIT_COUNTS, X
				PLX
				CMP.l ItemSubstitutionRules+1, X : !BLT +
					LDA.l ItemSubstitutionRules+2, X : STA 1,s
				+

				BEQ .exit
			.noMatch
				INX #4
	BRA -
.exit
	PLA : PLX
RTS
;--------------------------------------------------------------------------------
CountBottles:
	LDX.b #$00
	LDA $7EF35C : BEQ ++ : INX
	++ : LDA $7EF35D : BEQ ++ : INX
	++ : LDA $7EF35E : BEQ ++ : INX
	++ : LDA $7EF35F : BEQ ++ : INX
	++
	TXA
RTS
;--------------------------------------------------------------------------------
ActivateGoal:
    STZ $11
    STZ $B0
JML.l StatsFinalPrep
;--------------------------------------------------------------------------------
