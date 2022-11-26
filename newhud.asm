NewDrawHud:
        SEP #$30
;================================================================================
; Draw bomb count
;================================================================================

	LDA.l InfiniteBombs : BNE .infinite_bombs
	.finite_bombs
		LDA.l BombsEquipment ; bombs
		JSR HudHexToDec2Digit ;requires 8 bit registers!
		REP #$20
		LDX.b Scrap06 : TXA : ORA.w #$2400 : STA.l HUDBombCount ; Draw bombs 10 digit
		LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDBombCount+2 ; Draw bombs 1 digit
		BRA +

	.infinite_bombs
		REP #$20
		LDA.w #$2431 : STA.l HUDBombCount ; infinity (left half)
		INC A        : STA.l HUDBombCount+2 ; infinity (right half)
	+

;================================================================================
; Draw rupee counter
;================================================================================
	
	LDA.l DisplayRupees ; Drawing bombs (above) always ends with 16-bit A, so, no need to REP here
	JSR HudHexToDec4Digit
	LDX.b Scrap04 : TXA : ORA.w #$2400 : STA.l HUDRupees   ; 1000s
	LDX.b Scrap05 : TXA : ORA.w #$2400 : STA.l HUDRupees+2 ;  100s
	LDX.b Scrap06 : TXA : ORA.w #$2400 : STA.l HUDRupees+4 ;   10s
	LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDRupees+6 ;    1s
	
;================================================================================
; Draw arrow count
;================================================================================

	SEP #$20
	LDA.l ArrowMode : BNE +
		LDA.l InfiniteArrows : BNE .infinite_arrows
		.finite_arrows
			LDA.l CurrentArrows ; arrows
			JSR HudHexToDec2Digit
			REP #$20
			LDX.b Scrap06 : TXA : ORA.w #$2400 : STA.l HUDArrowCount ; Draw arrows 10 digit
			LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDArrowCount+2 ; Draw arrows  1 digit
			BRA +
		
		.infinite_arrows
			REP #$20
			LDA.w #$2431 : STA.l HUDArrowCount ; infinity (left half)
			INC A        : STA.l HUDArrowCount+2 ; infinity (right half)
	+
	
;================================================================================
; Draw Goal Item Indicator
;================================================================================

	REP #$20
	LDA.l GoalItemRequirement : BNE + : JMP .done : + ; Star Meter

        LDA.l GoalCounter
        JSR HudHexToDec4Digit

	LDA.l GoalItemIcon : STA.l HUDGoalIndicator ; draw star icon
	
	LDX.b Scrap05 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+2 ; draw 100's digit
	LDX.b Scrap06 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+4 ; draw 10's digit
	LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+6 ; draw 1's digit
	
	LDA.l GoalItemRequirement : CMP.w #$FFFF : BEQ .skip
		LDA.l GoalItemRequirement
		JSR HudHexToDec4Digit
		LDA.w #$2830 : STA.l HUDGoalIndicator+8 ; draw slash
		LDX.b Scrap05 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+10 ; draw 100's digit
		LDX.b Scrap06 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+12 ; draw 10's digit
		LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDGoalIndicator+14 ; draw 1's digit
		BRA .done
	.skip
		LDA.w #$207F ; transparent tile
		STA.l HUDGoalIndicator+8
		STA.l HUDGoalIndicator+10
		STA.l HUDGoalIndicator+12
	.done
	
;================================================================================
; Draw Dungeon Compass Counts
;================================================================================
	LDA.l CompassMode : AND.w #$00FF : BEQ + ; skip if CompassMode is 0.
		JSL.l DrawDungeonCompassCounts ; compasses.asm
	+

;================================================================================
; Draw key count
;================================================================================
	SEP #$20
	LDA.l CurrentSmallKeys : CMP.b #$FF : BEQ .not_in_dungeon
		.in_dungeon
		JSR HudHexToDec2Digit : REP #$20
		
		; if 10s digit is 0, draw transparent tile instead of 0
		LDX.b Scrap06 : TXA : CPX.b #$90 : BNE +
			LDA.w #$007F 
		+
		ORA.w #$2400 : STA.l HUDKeyDigits
		
		; 1s digit
		LDX.b Scrap07 : TXA : ORA.w #$2400 : STA.l HUDKeyDigits+2
		BRA .done_keys
		
	.not_in_dungeon
	REP #$20
	
	;in the overworld, draw transparent tiles instead of key count
	LDA.w #$247F : STA.l HUDKeyDigits : STA.l HUDKeyDigits+2
	STA.l HUDKeyIcon
	
	.done_keys




;--------------------------------------------------------------------------------
; Draw pendant/crystal icon
;--------------------------------------------------------------------------------
!P_ICON = $296C
!C_ICON = $295F

	SEP #$20
	LDA.b IndoorsFlag : BEQ .noprize

	LDX.w DungeonID
	CPX #$1A : !BGE .noprize
	CPX #$04 : !BLT .noprize
	CPX #$08 : BEQ .noprize

	LDA.b GameMode : CMP.b #$12 : BEQ .noprize

	LDA.l MapMode
	REP #$20
	BEQ .drawprize

	LDA.l MapField
	AND.l DungeonItemMasks,X
	BEQ .noprize

.drawprize
	TXA : LSR : TAX
	LDA.l CrystalPendantFlags_2, X
	AND.w #$0040 : BNE .is_crystal

	LDA.w #!P_ICON
	BRA .doneprize

.is_crystal
	LDA.w #!C_ICON
	BRA .doneprize

.noprize
	REP #$20
	LDA.w #$207F

.doneprize
	STA.l HUDPrizeIcon

;--------------------------------------------------------------------------------
; Draw Magic Meter
DrawMagicMeter_mp_tilemap = $0DFE0F
;--------------------------------------------------------------------------------
	LDA.l CurrentMagic : AND.w #$00FF ; crap we wrote over when placing the hook for OnDrawHud
	!ADD #$0007
	AND.w #$FFF8
	TAX						 ; end of crap
	
	LDA.l InfiniteMagic : AND.w #$00FF : BNE + : JMP .green : +
	SEP #$20 : LDA.b #$80 : STA.l CurrentMagic : REP #$30 ; set magic to max
	LDX.w #$0080 ; load full magic meter graphics
	LDA.b FrameCounter : AND.w #$000C : LSR #2
	BEQ .red
	CMP.w #0001 : BEQ .yellow
	CMP.w #0002 : BNE + : JMP .green : +
	.blue
	    LDA.l DrawMagicMeter_mp_tilemap+0, X : AND.w #$EFFF : STA.l HUDTileMapBuffer+$46
	    LDA.l DrawMagicMeter_mp_tilemap+2, X : AND.w #$EFFF : STA.l HUDTileMapBuffer+$86
	    LDA.l DrawMagicMeter_mp_tilemap+4, X : AND.w #$EFFF : STA.l HUDTileMapBuffer+$C6
	    LDA.l DrawMagicMeter_mp_tilemap+6, X : AND.w #$EFFF : STA.l HUDTileMapBuffer+$06
            RTL
	.red
	    LDA.l DrawMagicMeter_mp_tilemap+0, X : AND.w #$E7FF : STA.l HUDTileMapBuffer+$46
	    LDA.l DrawMagicMeter_mp_tilemap+2, X : AND.w #$E7FF : STA.l HUDTileMapBuffer+$86
	    LDA.l DrawMagicMeter_mp_tilemap+4, X : AND.w #$E7FF : STA.l HUDTileMapBuffer+$C6
	    LDA.l DrawMagicMeter_mp_tilemap+6, X : AND.w #$E7FF : STA.l HUDTileMapBuffer+$06
            RTL
	.yellow
	    LDA.l DrawMagicMeter_mp_tilemap+0, X : AND.w #$EBFF : STA.l HUDTileMapBuffer+$46
	    LDA.l DrawMagicMeter_mp_tilemap+2, X : AND.w #$EBFF : STA.l HUDTileMapBuffer+$86
	    LDA.l DrawMagicMeter_mp_tilemap+4, X : AND.w #$EBFF : STA.l HUDTileMapBuffer+$C6
	    LDA.l DrawMagicMeter_mp_tilemap+6, X : AND.w #$EBFF : STA.l HUDTileMapBuffer+$0106
            RTL
	.orange
	    LDA.l DrawMagicMeter_mp_tilemap+0, X : AND.w #$E3FF : STA.l HUDTileMapBuffer+$46
	    LDA.l DrawMagicMeter_mp_tilemap+2, X : AND.w #$E3FF : STA.l HUDTileMapBuffer+$86
	    LDA.l DrawMagicMeter_mp_tilemap+4, X : AND.w #$E3FF : STA.l HUDTileMapBuffer+$C6
	    LDA.l DrawMagicMeter_mp_tilemap+6, X : AND.w #$E3FF : STA.l HUDTileMapBuffer+$0106
            RTL
	.green
	    LDA.l DrawMagicMeter_mp_tilemap+0, X : STA.l HUDTileMapBuffer+$46
	    LDA.l DrawMagicMeter_mp_tilemap+2, X : STA.l HUDTileMapBuffer+$86
	    LDA.l DrawMagicMeter_mp_tilemap+4, X : STA.l HUDTileMapBuffer+$C6
	    LDA.l DrawMagicMeter_mp_tilemap+6, X : STA.l HUDTileMapBuffer+$0106
RTL

;================================================================================
; 16-bit A, 8-bit X
; in:	A(b) - Byte to Convert
; out:	$04 - $07 (high - low)
;================================================================================
HudHexToDec4Digit:
	LDY.b #$90
	-
		CMP.w #1000 : !BLT +
		INY
		SBC.w #1000 : BRA -
	+
	STY.b Scrap04 : LDY.b #$90 ; Store 1000s digit & reset Y
	-
		CMP.w #100 : !BLT +
		INY
		SBC.w #100 : BRA -
	+
	STY.b Scrap05 : LDY.b #$90 ; Store 100s digit & reset Y
	-
		CMP.w #10 : !BLT +
		INY
		SBC.w #10 : BRA -
	+ 
	STY.b Scrap06 : LDY.b #$90 ; Store 10s digit & reset Y
	CMP.w #1 : !BLT +
	-
		INY
		DEC : BNE -
	+
	STY.b Scrap07 ; Store 1s digit
RTS

;================================================================================
; 8-bit registers
; in:	A(b) - Byte to Convert
; out:	$06 - $07 (high - low)
;================================================================================
HudHexToDec2Digit:
	LDY.b #$90
	-
		CMP.b #10 : !BLT +
		INY
		SBC.b #10 : BRA -
	+ 
	STY.b Scrap06 : LDY.b #$90 ; Store 10s digit and reset Y
	CMP.b #1 : !BLT +
	-
		INY
		DEC : BNE -
	+
	STY.b Scrap07 ; Store 1s digit
RTS
