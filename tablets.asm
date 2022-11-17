;================================================================================
; Randomize Tablets
;--------------------------------------------------------------------------------
ItemSet_EtherTablet:
	PHA : LDA.l NpcFlags+1 : ORA.b #$01 : STA.l NpcFlags+1 : PLA
RTL
;--------------------------------------------------------------------------------
ItemSet_BombosTablet:
	PHA : LDA.l NpcFlags+1 : ORA.b #$02 : STA.l NpcFlags+1 : PLA
RTL
;--------------------------------------------------------------------------------
ItemCheck_EtherTablet:
	LDA.l NpcFlags+1 : AND.b #$01
RTL
;--------------------------------------------------------------------------------
ItemCheck_BombosTablet:
	LDA.l NpcFlags+1 : AND.b #$02
RTL
;--------------------------------------------------------------------------------
SetTabletItem:
	JSL.l GetSpriteID
	PHA
		LDA.b $8A : CMP.b #$03 : BEQ .ether ; if we're on the map where ether is, we're the ether tablet
		.bombos
		JSL.l ItemSet_BombosTablet : BRA .done
		.ether
		JSL.l ItemSet_EtherTablet
		.done
	PLA
RTL
;--------------------------------------------------------------------------------
SpawnTabletItem:
	JSL.l LoadOutdoorValue
	PHA
	JSL.l PrepDynamicTile
	
	JSL.l SetTabletItem
	
	LDA.b #$EB
	STA.l $7FFE00
	JSL Sprite_SpawnDynamically

	PLA : STA.w $0E80, Y ; Store item type
	LDA.b $22 : STA.w $0D10, Y
	LDA.b $23 : STA.w $0D30, Y
  
	LDA.b $20 : STA.w $0D00, Y
	LDA.b $21 : STA.w $0D20, Y

	LDA.b #$00 : STA.w $0F20, Y
	
	LDA.b #$7F : STA.w $0F70, Y ; spawn WAY up high
RTL
;--------------------------------------------------------------------------------
MaybeUnlockTabletAnimation:
	PHA : PHP
		JSL.l IsMedallion : BCC +
			STZ $0112 ; disable falling-medallion mode
			STZ $03EF ; release link from item-up pose
			LDA.b #$00 : STA.b $5D ; set link to ground state

			REP #$20 ; set 16-bit accumulator
				LDA.b $8A : CMP.w #$0030 : BNE ++ ; Desert
					SEP #$20 ; set 8-bit accumulator
					LDA.b #$02 : STA.b $2F ; face link forward
					LDA.b #$3C : STA.b $46 ; lock link for 60f
				++
			SEP #$20 ; set 8-bit accumulator
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IsMedallion:
	REP #$20 ; set 16-bit accumulator
	LDA.b $8A
	CMP.w #$03 : BNE + ; Death Mountain
		LDA.b $22 : CMP.w #1890 : !BGE ++
			SEC
			JMP .done
		++
		BRA .false
	+ CMP.w #$30 : BNE + ; Desert
		LDA.b $22 : CMP.w #512 : !BLT ++
			SEC
			JMP .done
		++
	+
	.false
	CLC
	.done
	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
LoadNarrowObject:
	LDA.l AddReceivedItemExpanded_wide_item_flag, X : STA.b ($92), Y ; AddReceiveItem.wide_item_flag?
RTL
;--------------------------------------------------------------------------------
DrawNarrowDroppedObject:
    ; If it's a 16x16 sprite, we'll only draw one, otherwise we'll end up drawing
    ; two 8x8 sprites stack on top of each other
    CMP.b #$02 : BEQ .large_sprite
    
    REP #$20
    
    ; Shift Y coordinate 8 pixels down
    LDA.b Scrap08 : STA.b Scrap00
    
    SEP #$20
    
    JSL.l Ancilla_SetOam_XY_Long
    
    ; always use the same character graphic (0x34)
    LDA.b #$34 : STA.b ($90), Y : INY
    
    LDA.l AddReceivedItemExpanded_properties, X : BPL .valid_lower_properties
    
    LDA.b $74

.valid_lower_properties

    ASL A : ORA.b #$30 : STA.b ($90), Y 
    
    INY : PHY
    
    TYA : !SUB.b #$04 : LSR #2 : TAY
    
    LDA.b #$00 : STA.b ($92), Y
    
    PLY
.large_sprite
RTL
;--------------------------------------------------------------------------------
