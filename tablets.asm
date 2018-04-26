;================================================================================
; Randomize Tablets
;--------------------------------------------------------------------------------
ItemSet_EtherTablet:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$01 : STA !NPC_FLAGS_2 : PLA
RTL
;--------------------------------------------------------------------------------
ItemSet_BombosTablet:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$02 : STA !NPC_FLAGS_2 : PLA
RTL
;--------------------------------------------------------------------------------
ItemCheck_EtherTablet:
	LDA !NPC_FLAGS_2 : AND.b #$01
RTL
;--------------------------------------------------------------------------------
ItemCheck_BombosTablet:
	LDA !NPC_FLAGS_2 : AND.b #$02
RTL
;--------------------------------------------------------------------------------
SetTabletItem:
	JSL.l GetSpriteID
	PHA
		LDA $8A : CMP.b #$03 : BEQ .ether ; if we're on the map where ether is, we're the ether tablet
		.bombos
		JSL.l ItemSet_BombosTablet : BRA .done
		.ether
		JSL.l ItemSet_EtherTablet
		.done
	PLA
RTL
;--------------------------------------------------------------------------------
SpawnTabletItem:
;	JSL.l HeartPieceGet
;RTL
	JSL.l LoadOutdoorValue
	JSL.l PrepDynamicTile
	
	LDA.b #$01 : STA !FORCE_HEART_SPAWN : STA !SKIP_HEART_SAVE
	JSL.l SetTabletItem
	
	LDA.b #$EB
	STA $7FFE00
	JSL Sprite_SpawnDynamically

	LDA $22 : STA $0D10, Y
	LDA $23 : STA $0D30, Y

	LDA $20 : STA $0D00, Y
	LDA $21 : STA $0D20, Y

	LDA.b #$00 : STA $0F20, Y
	
	LDA.b #$7F : STA $0F70, Y ; spawn WAY up high
RTL
;--------------------------------------------------------------------------------
MaybeUnlockTabletAnimation:
	PHA : PHP
		JSL.l IsMedallion : BCC +
			STZ $0112 ; disable falling-medallion mode
			STZ $03EF ; release link from item-up pose
			LDA.b #$00 : STA $5D ; set link to ground state
			
			REP #$20 ; set 16-bit accumulator
				LDA $8A : CMP.w #$0030 : BNE ++ ; Desert
					SEP #$20 ; set 8-bit accumulator
					LDA.b #$02 : STA $2F ; face link forward
					LDA.b #$3C : STA $46 ; lock link for 60f
				++
			SEP #$20 ; set 8-bit accumulator
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IsMedallion:
	REP #$20 ; set 16-bit accumulator
	LDA $8A
	CMP.w #$03 : BNE + ; Death Mountain
		LDA $22 : CMP.w #1890 : !BGE ++
			SEC
			BRL .done
		++
		BRA .false
	+ CMP.w #$30 : BNE + ; Desert
		LDA $22 : CMP.w #512 : !BLT ++
			SEC
			BRL .done
		++
	+
	.false
	CLC
	.done
	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
LoadNarrowObject:
	LDA AddReceivedItemExpanded_wide_item_flag, X : STA ($92), Y ; AddReceiveItem.wide_item_flag? ; LDA.b #$00 : STA ($92), Y in the japanese version
	PLY
	;JSL.l DrawNarrowDroppedObject
JML.l LoadNarrowObjectReturn
;--------------------------------------------------------------------------------
DrawNarrowDroppedObject:
    ; If it's a 16x16 sprite, we'll only draw one, otherwise we'll end up drawing
    ; two 8x8 sprites stack on top of each other
    CMP.b #$02 : BEQ .large_sprite
    
    REP #$20
    
    ; Shift Y coordinate 8 pixels down
    LDA $08 : STA $00
    
    SEP #$20
    
    JSL.l Ancilla_SetOam_XY_Long
    
    ; always use the same character graphic (0x34)
    LDA.b #$34 : STA ($90), Y : INY
    
    LDA AddReceivedItemExpanded_properties, X : BPL .valid_lower_properties
    
    LDA $74

.valid_lower_properties

    ASL A : ORA.b #$30 : STA ($90), Y 
    
    INY : PHY
    
    TYA : !SUB.b #$04 : LSR #2 : TAY
    
    LDA.b #$00 : STA ($92), Y
    
    PLY
.large_sprite
RTL
;--------------------------------------------------------------------------------