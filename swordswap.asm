;================================================================================
; Master / Tempered / Golden Sword Swap
;================================================================================
;$03348E: smith sword check (to see if uprade-able)
;================================================================================
;GetFairySword:
;	CMP.b #$49 : BNE + : LDA.b #$00 : + ; convert single fighter sword to low id one
;	CMP.b #$50 : BNE + : LDA.b #$01 : + ; convert safe master sword to normal one
;	CMP #$04 : !BLT + : JML.l PyramidFairy_BRANCH_IOTA : + ; for any sword, incl newer
;	JSL ItemCheck_FairySword : BEQ + : JML.l PyramidFairy_BRANCH_IOTA : + ; skip if we already flagged getting this
;	JSL ItemSet_FairySword ; mark as got
;	LDA FairySword : STA $0DC0, X ; whichever sword
;	LDA.b #$05 : STA $0EB0, X ; something we overwrote, documentation unclear on purpose
;
;JML.l PyramidFairy_BRANCH_GAMMA
;================================================================================
;GetSmithSword:
;	JSL ItemCheck_SmithSword : BEQ + : JML.l Smithy_AlreadyGotSword : + ; check if we're not already done
;	;JSL ItemSet_SmithSword - too early
;JML.l Smithy_DoesntHaveSword
;================================================================================
;LoadSwordForDamage:
;	LDA SwordEquipment : CMP #$04 : BNE .done ; skip if not gold sword
;	LDA $1B : BEQ + ; skip if outdoors
;	LDA $A0 : CMP #41 : BNE + ; decimal 41 ; skip if not in the mothula room
;		LDA #$03 ; pretend we're using tempered
;		BRA .done
;	+
;	LDA #$04 ; nvm gold sword is fine
;	.done
;RTL
;================================================================================
LoadSwordForDamage:
	LDA $0E20, X : CMP.b #$88 : BNE .notMoth
		JSR.w LoadModifiedSwordLevel ; load normal sword value
		CMP.b #$04 : !BLT + : DEC : + ; if it's gold sword, change it to tempered
		RTL
	.notMoth
	JSR.w LoadModifiedSwordLevel ; load normal sword value
RTL
;================================================================================
;!StalfosBombDamage = "$7F509D"
LookupDamageLevel:
	CPX.w #$0918 : BNE +
		LDA.l !StalfosBombDamage
		RTL
	+
	PHP
		REP #$20 ; set 16-bit accumulator
		TXA : LSR : TAX : BCS .lower
.upper
	PLP
	LDA.l Damage_Table, X
	LSR #4
RTL
.lower
	PLP
	LDA.l Damage_Table, X
	AND.b #$0F
RTL
;================================================================================
; $7F50C0 - Sword Modifier
LoadModifiedSwordLevel: ; returns short
	LDA $7F50C0 : BEQ +
		!ADD SwordEquipment ; add normal sword value to modifier
			BNE ++ : LDA.b #$01 : RTS : ++
			CMP.b #$05 : !BLT ++ : LDA.b #$04 : RTS : ++
		RTS
	+
	LDA SwordEquipment ; load normal sword value
RTS
;================================================================================
; ArmorEquipment - Armor Inventory
; $7F50C2 - Armor Modifier
; $7F5020 - Scratch Space (Caller Preserved)
LoadModifiedArmorLevel:
	PHA
		LDA ArmorEquipment : !ADD $7F50C2
		CMP.b #$FF : BNE + : LDA.b #$00 : +
		CMP.b #$03 : !BLT + : LDA.b #$02 : +
		STA $7F5020
	PLA
	!ADD $7F5020
RTL
;================================================================================
; MagicConsumption - Magic Inventory
; $7F50C3 - Magic Modifier
LoadModifiedMagicLevel:
	LDA $7F50C3 : BEQ +
		!ADD MagicConsumption ; add normal magic value to modifier
			CMP.b #$FF : BNE ++ : LDA.b #$00 : RTL : ++
			CMP.b #$03 : !BLT ++ : LDA.b #$02 : ++
		RTL
	+
	LDA MagicConsumption ; load normal magic value
RTL
;================================================================================
; $7E0348 - Ice Value
; $7F50C7 - Ice Modifier
LoadModifiedIceFloorValue_a11:
	LDA $A0 : CMP #$91 : BEQ + : CMP #$92 : BEQ + : CMP #$93 : BEQ + ; mire basement currently broken - not sure why
	LDA $5D : CMP #$01 : BEQ + : CMP #$17 : BEQ + : CMP #$1C : BEQ +
	LDA $5E : CMP #$02 : BEQ +
	LDA $5B : BNE +
		LDA.w $0348 : ORA $7F50C7 : AND.b #$11 : RTL
	+ : LDA.w $0348 : AND.b #$11
RTL
LoadModifiedIceFloorValue_a01:
	LDA $A0 : CMP #$91 : BEQ + : CMP #$92 : BEQ + : CMP #$93 : BEQ + ; mire basement currently broken - not sure why
	LDA $5D : CMP #$01 : BEQ + : CMP #$17 : BEQ + : CMP #$1C : BEQ +
	LDA $5E : CMP #$02 : BEQ +
	LDA $5B : BNE +
		LDA.w $0348 : ORA $7F50C7 : AND.b #$01 : RTL
	+ : LDA.w $0348 : AND.b #$01
RTL
;================================================================================
CheckTabletSword:
	LDA.l AllowHammerTablets : BEQ +
	LDA HammerEquipment : BEQ + ; check for hammer
		LDA.b #$02 : RTL
	+
	LDA SwordEquipment ; get actual sword value
RTL
;================================================================================
GetSwordLevelForEvilBarrier:
	LDA.l AllowHammerEvilBarrierWithFighterSword : BEQ +
	LDA #$FF : RTL
	+
	LDA SwordEquipment
RTL
;================================================================================
CheckGanonHammerDamage:
	LDA.l HammerableGanon : BEQ +
	LDA $0E20, X : CMP.b #$D8 ; original behavior except ganon
RTL
	+
	LDA $0E20, X : CMP.b #$D6 ; original behavior
RTL
;================================================================================
GetSmithSword:
	JSL ItemCheck_SmithSword : BEQ + : JML.l Smithy_AlreadyGotSword : +
	LDA.l SmithItemMode : BNE +
		JML.l Smithy_DoesntHaveSword ; Classic Smithy
	+

	REP #$20 : LDA CurrentRupees : CMP #$000A : SEP #$20 : !BGE .buy
	.cant_afford
		REP #$10
		LDA.b #$7A
		LDY.b #$01
		JSL.l Sprite_ShowMessageUnconditional
		LDA.b #$3C : STA $012E ; error sound
		SEP #$10
		BRA .done

	.buy
		LDA.l SmithItem : TAY
		STZ $02E9 ; Item from NPC
		PHX : JSL Link_ReceiveItem : PLX

		REP #$20 : LDA CurrentRupees : !SUB.w #$000A : STA CurrentRupees : SEP #$20 ; Take 10 rupees
		JSL ItemSet_SmithSword
	
	.done
		JML.l Smithy_AlreadyGotSword
;================================================================================
CheckMedallionSword:
	LDA.l AllowSwordlessMedallionUse : BEQ .check_sword
	CMP #$01 : BEQ .check_pad
		LDA.b #$02 ; Pretend we have master sword
		RTL
	.check_sword
		LDA SwordEquipment
		RTL
	.check_pad
		PHB : PHX : PHY
		LDA $1B : BEQ .outdoors
		.indoors
			REP #$20 ; set 16-bit accumulator
			LDA $A0 ; load room ID
			CMP.w #$000E : BNE + ; freezor1
				LDA $22 : AND.w #$01FF ; check x-coord
					CMP.w #368-8 : !BLT .normal
					CMP.w #368+32-8 : !BGE .normal
				LDA $20 : AND.w #$01FF ; check y-coord
					CMP.w #400-22 : !BLT .normal
					CMP.w #400+32-22 : !BGE .normal
				JMP .permit
			+ : CMP.w #$007E : BNE + ; freezor2
				LDA $22 : AND.w #$01FF ; check x-coord
					CMP.w #112-8 : !BLT .normal
					CMP.w #112+32-8 : !BGE .normal
				LDA $20 : AND.w #$01FF ; check y-coord
					CMP.w #400-22 : !BLT .normal
					CMP.w #400+32-22 : !BGE .normal
				JMP .permit
			+ : CMP.w #$00DE : BNE + ; kholdstare
				LDA $22 : AND.w #$01FF ; check x-coord
					CMP.w #368-8 : !BLT .normal
					CMP.w #368+32-8 : !BGE .normal
				LDA $20 : AND.w #$01FF ; check y-coord
					CMP.w #144-22 : !BLT .normal
					CMP.w #144+32-22 : !BGE .normal
				BRA .permit
			+ : .normal
			SEP #$20 ; set 8-bit accumulator
			BRA .done
		.outdoors
			LDA $8A : CMP.b #$70 : BNE +
				LDA.l MireRequiredMedallion : TAX : LDA.l .medallion_type, X : CMP $0303 : BNE .done
				LDA OverworldEventDataWRAM+$70 : AND.b #$20 : BNE .done
				LDA.b #$08 : PHA : PLB ; set data bank to $08
				LDY.b #$02 : JSL.l Ancilla_CheckIfEntranceTriggered : BCS .permit ; misery mire
				BRA .done
			+ : CMP.b #$47 : BNE +
				LDA.l TRockRequiredMedallion : TAX : LDA.l .medallion_type, X : CMP $0303 : BNE .done
				LDA OverworldEventDataWRAM+$47 : AND.b #$20 : BNE .done
				LDA.b #$08 : PHA : PLB ; set data bank to $08
				LDY.b #$03 : JSL.l Ancilla_CheckIfEntranceTriggered : BCS .permit ; turtle rock
			+
	.done
		PLY : PLX : PLB
		LDA SwordEquipment
		RTL
	.permit
		SEP #$20 ; set 8-bit accumulator
		PLY : PLX : PLB
		LDA.b #$02 ; Pretend we have master sword
		RTL
.medallion_type
db #$0F, #$10, #$11
;================================================================================
