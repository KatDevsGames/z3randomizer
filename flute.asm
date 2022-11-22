;================================================================================
; Randomize Flute Dig Item
;--------------------------------------------------------------------------------
SpawnHauntedGroveItem:
	LDA.b OverworldIndex : CMP.b #$2A : BEQ + : RTL : + ; Skip if not the haunted grove
	LDA.b IndoorsFlag : BEQ + : RTL : + ; Skip if indoors

	%GetPossiblyEncryptedItem(HauntedGroveItem, HeartPieceOutdoorValues)
	JSL.l PrepDynamicTile
	
	LDA.b #$EB
	STA.l MiniGameTime
	JSL Sprite_SpawnDynamically

	LDX.b #$00
	LDA.b LinkDirection : CMP.b #$04 : BEQ + : INX : +

	LDA.l .x_speeds, X : STA.w $0D50, Y

	LDA.b #$00 : STA.w $0D40, Y
	LDA.b #$18 : STA.w $0F80, Y
	LDA.b #$FF : STA.w $0B58, Y
	LDA.b #$30 : STA.w $0F10, Y

	LDA.b $22 : !ADD.l .x_offsets, X
        AND.b #$F0 : STA.w $0D10, Y
	LDA.b $23 : ADC.b #$00 : STA.w $0D30, Y

	LDA.b $20 : !ADD.b #$16 : AND.b #$F0 : STA.w $0D00, Y
	LDA.b $21 : ADC.b #$00 : STA.w $0D20, Y

	LDA.b #$00 : STA.w $0F20, Y
	TYX

	LDX.b OverworldIndex ; haunted grove (208D0A)
	LDA.l OverworldEventDataWRAM, X : AND.b #$40 : BNE +
		LDA.b #$1B : JSL Sound_SetSfx3PanLong
	+
RTL

;DATA - Flute Spawn Information
{

.x_speeds
	db $F0
	db $10

.x_offsets
	db $00
	db $13

}
;--------------------------------------------------------------------------------
FluteBoy:
	LDA.b GameMode : CMP.b #$1A : BEQ +
		LDA.b #$01 : STA.w $0FDD
		JML.l FluteBoy_Abort
	+
	LDA.w SpriteUnknown, X : CMP.b #$03 ; thing we wrote over
JML.l FluteBoy_Continue
;--------------------------------------------------------------------------------
FreeDuckCheck:
	LDA.l InvertedMode : BEQ .done
	LDA.l FluteEquipment : CMP.b #$03 : BEQ .done ; flute is already active
	
    ; check the area, is it #$18 = 30?
    LDA.b OverworldIndex : CMP.b #$18 : BNE .done

	REP #$20
	
    ; Y coordinate boundaries for setting it off.
    LDA.b $20
    
    CMP.w #$0760 : BCC .done
    CMP.w #$07E0 : BCS .done
    
    ; do if( (Ycoord >= 0x0760) && (Ycoord < 0x07e0
    LDA.b $22
    
    CMP.w #$01CF : BCC .done
    CMP.w #$0230 : BCS .done
    
    ; do if( (Xcoord >= 0x1cf) && (Xcoord < 0x0230)
    SEP #$20
    
    ; Apparently a special Overworld mode for doing this?
    LDA.b #$2D : STA.b GameSubMode
    
    ; Trigger the sequence to start the weathervane explosion.
    LDY.b #$00
    LDA.b #$37
    
    JSL AddWeathervaneExplosion
	BRA .skipSong
	.done
    SEP #$20
	LDA.b #$80 : STA.w $03F0 ; thing we wrote over, load flute timer
	LDA.b #$13
RTL
	.skipSong
	SEP #$20
	LDA.b #$80 : STA.w $03F0 ; thing we wrote over, load flute timer
	LDA.b #$00
RTL
;--------------------------------------------------------------------------------
