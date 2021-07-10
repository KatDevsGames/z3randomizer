NewDrawHud:
SEP #$30
;================================================================================
; Draw bomb count
!BOMBCOUNT_DRAW_ADDRESS = "$7EC75A"
!INFINITE_BOMBS = "$7F50C9"
;================================================================================

	LDA !INFINITE_BOMBS : BNE .infinite_bombs
	.finite_bombs
		LDA.l $7EF343 ; bombs
		JSR HudHexToDec2Digit ;requires 8 bit registers!
		REP #$20
		LDX.b $06 : TXA : ORA.w #$2400 : STA !BOMBCOUNT_DRAW_ADDRESS ; Draw bombs 10 digit
		LDX.b $07 : TXA : ORA.w #$2400 : STA !BOMBCOUNT_DRAW_ADDRESS+2 ; Draw bombs 1 digit
		BRA +

	.infinite_bombs
		REP #$20
		LDA.w #$2431 : STA !BOMBCOUNT_DRAW_ADDRESS ; infinity (left half)
		INC A        : STA !BOMBCOUNT_DRAW_ADDRESS+2 ; infinity (right half)
	+

;================================================================================
; Draw rupee counter
!RUPEE_DRAW_ADDRESS = "$7EC750"
;================================================================================
	
	LDA.l $7EF362 ; Drawing bombs (above) always ends with 16-bit A, so, no need to REP here
	JSR HudHexToDec4Digit
	LDX.b $04 : TXA : ORA.w #$2400 : STA !RUPEE_DRAW_ADDRESS	; 1000s
	LDX.b $05 : TXA : ORA.w #$2400 : STA !RUPEE_DRAW_ADDRESS+2	;  100s
	LDX.b $06 : TXA : ORA.w #$2400 : STA !RUPEE_DRAW_ADDRESS+4	;   10s
	LDX.b $07 : TXA : ORA.w #$2400 : STA !RUPEE_DRAW_ADDRESS+6	;    1s
	
;================================================================================
; Draw arrow count
!ARROWCOUNT_DRAW_ADDRESS = "$7EC760"
!INFINITE_ARROWS = "$7F50C8"
;================================================================================

	SEP #$20
	LDA.l ArrowMode : BNE +
		LDA !INFINITE_ARROWS : BNE .infinite_arrows
		.finite_arrows
			LDA.l $7EF377 ; arrows
			JSR HudHexToDec2Digit
			REP #$20
			LDX.b $06 : TXA : ORA.w #$2400 : STA !ARROWCOUNT_DRAW_ADDRESS ; Draw arrows 10 digit
			LDX.b $07 : TXA : ORA.w #$2400 : STA !ARROWCOUNT_DRAW_ADDRESS+2 ; Draw arrows  1 digit
			BRA +
		
		.infinite_arrows
			REP #$20
			LDA.w #$2431 : STA !ARROWCOUNT_DRAW_ADDRESS ; infinity (left half)
			INC A        : STA !ARROWCOUNT_DRAW_ADDRESS+2 ; infinity (right half)
	+
	
;================================================================================
; Draw Goal Item Indicator
!GOAL_COUNTER = "$7EF418"
!GOAL_DRAW_ADDRESS = "$7EC72A"
;================================================================================

	SEP #$20
	LDA.l GoalItemRequirement : BNE + : JMP .done : + ; Star Meter
	
	LDA.l !GOAL_COUNTER
	JSR HudHexToDec3Digit
	REP #$20
	
	LDA.l GoalItemIcon : STA !GOAL_DRAW_ADDRESS ; draw star icon
	
	LDX.b $05 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+2 ; draw 100's digit
	LDX.b $06 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+4 ; draw 10's digit
	LDX.b $07 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+6 ; draw 1's digit
	
	SEP #$20
	LDA.l GoalItemRequirement : CMP.b #$FF : BEQ .skip
	
		LDA.l GoalItemRequirement
		JSR HudHexToDec3Digit
		REP #$20
		LDA.w #$2830 : STA !GOAL_DRAW_ADDRESS+8 ; draw slash
		LDX.b $05 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+10 ; draw 100's digit
		LDX.b $06 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+12 ; draw 10's digit
		LDX.b $07 : TXA : ORA.w #$2400 : STA !GOAL_DRAW_ADDRESS+14 ; draw 1's digit
		BRA .done
	.skip
		REP #$20
		LDA.w #$207F ; transparent tile
		STA !GOAL_DRAW_ADDRESS+8
		STA !GOAL_DRAW_ADDRESS+10
		STA !GOAL_DRAW_ADDRESS+12
	.done
	
;================================================================================
; Draw Dungeon Compass Counts
;================================================================================
	REP #$20
	LDA.l CompassMode : AND #$00FF : BEQ + ; skip if CompassMode is 0.
		JSL.l DrawDungeonCompassCounts ; compasses.asm
	+

;================================================================================
; Draw key count
!KEYS = "$7EF36F"
!KEY_DIGITS_ADDRESS = "$7EC764"
!KEY_ICON_ADDRESS = "$7EC726"
;================================================================================
	SEP #$20
	LDA.l !KEYS : CMP.b #$FF : BEQ .not_in_dungeon
		.in_dungeon
		JSR HudHexToDec2Digit : REP #$20
		
		; if 10s digit is 0, draw transparent tile instead of 0
		LDX.b $06 : TXA : CPX.b #$90 : BNE +
			LDA.w #$007F 
		+
		ORA.w #$2400 : STA !KEY_DIGITS_ADDRESS
		
		; 1s digit
		LDX.b $07 : TXA : ORA.w #$2400 : STA !KEY_DIGITS_ADDRESS+2
		BRA .done_keys
		
	.not_in_dungeon
	REP #$20
	
	;in the overworld, draw transparent tiles instead of key count
	LDA.w #$247F : STA !KEY_DIGITS_ADDRESS : STA !KEY_DIGITS_ADDRESS+2
	STA !KEY_ICON_ADDRESS
	
	.done_keys




;--------------------------------------------------------------------------------
; Draw pendant/crystal icon
;--------------------------------------------------------------------------------
!PRIZE_ICON = $7EC742
!P_ICON = $296C
!C_ICON = $295F

	SEP #$20
	LDA.b $1B : BEQ .noprize

	LDX.w $040C
	CPX #$1A : !BGE .noprize
	CPX #$04 : !BLT .noprize
	CPX #$08 : BEQ .noprize

	LDA $10 : CMP #$12 : BEQ .noprize

	REP #$20

	LDA.l MapMode
	BEQ .drawprize

	LDA.l $7EF368
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
	STA.l !PRIZE_ICON

;--------------------------------------------------------------------------------
; Draw Magic Meter
!INFINITE_MAGIC = "$7F50CA"
!DrawMagicMeter_mp_tilemap = "$0DFE0F" 
;--------------------------------------------------------------------------------
	LDA $7EF36E : AND #$00FF ; crap we wrote over when placing the hook for OnDrawHud
	!ADD #$0007
	AND #$FFF8
	TAX						 ; end of crap
	
	LDA !INFINITE_MAGIC : AND.w #$00FF : BNE + : JMP .green : +
	SEP #$20 : LDA.b #$80 : STA $7EF36E : REP #$30 ; set magic to max
	LDX.w #$0080 ; load full magic meter graphics
	LDA $1A : AND.w #$000C : LSR #2
	BEQ .red
	CMP.w #0001 : BEQ .yellow
	CMP.w #0002 : BNE + : JMP .green : +
	.blue
	    LDA !DrawMagicMeter_mp_tilemap+0, X : AND.w #$EFFF : STA $7EC746
	    LDA !DrawMagicMeter_mp_tilemap+2, X : AND.w #$EFFF : STA $7EC786
	    LDA !DrawMagicMeter_mp_tilemap+4, X : AND.w #$EFFF : STA $7EC7C6
	    LDA !DrawMagicMeter_mp_tilemap+6, X : AND.w #$EFFF : STA $7EC806
		RTL
	.red
	    LDA !DrawMagicMeter_mp_tilemap+0, X : AND.w #$E7FF : STA $7EC746
	    LDA !DrawMagicMeter_mp_tilemap+2, X : AND.w #$E7FF : STA $7EC786
	    LDA !DrawMagicMeter_mp_tilemap+4, X : AND.w #$E7FF : STA $7EC7C6
	    LDA !DrawMagicMeter_mp_tilemap+6, X : AND.w #$E7FF : STA $7EC806
		RTL
	.yellow
	    LDA !DrawMagicMeter_mp_tilemap+0, X : AND.w #$EBFF : STA $7EC746
	    LDA !DrawMagicMeter_mp_tilemap+2, X : AND.w #$EBFF : STA $7EC786
	    LDA !DrawMagicMeter_mp_tilemap+4, X : AND.w #$EBFF : STA $7EC7C6
	    LDA !DrawMagicMeter_mp_tilemap+6, X : AND.w #$EBFF : STA $7EC806
		RTL
	.orange
	    LDA !DrawMagicMeter_mp_tilemap+0, X : AND.w #$E3FF : STA $7EC746
	    LDA !DrawMagicMeter_mp_tilemap+2, X : AND.w #$E3FF : STA $7EC786
	    LDA !DrawMagicMeter_mp_tilemap+4, X : AND.w #$E3FF : STA $7EC7C6
	    LDA !DrawMagicMeter_mp_tilemap+6, X : AND.w #$E3FF : STA $7EC806
		RTL
	.green
	    LDA !DrawMagicMeter_mp_tilemap+0, X : STA $7EC746
	    LDA !DrawMagicMeter_mp_tilemap+2, X : STA $7EC786
	    LDA !DrawMagicMeter_mp_tilemap+4, X : STA $7EC7C6
	    LDA !DrawMagicMeter_mp_tilemap+6, X : STA $7EC806
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
	STY $04 : LDY #$90 ; Store 1000s digit & reset Y
	-
		CMP.w #100 : !BLT +
		INY
		SBC.w #100 : BRA -
	+
	STY $05 : LDY #$90 ; Store 100s digit & reset Y
	-
		CMP.w #10 : !BLT +
		INY
		SBC.w #10 : BRA -
	+ 
	STY $06 : LDY #$90 ; Store 10s digit & reset Y
	CMP.w #1 : !BLT +
	-
		INY
		DEC : BNE -
	+
	STY $07 ; Store 1s digit
RTS

;================================================================================
; 8-bit registers
; in:	A(b) - Byte to Convert
; out:	$05 - $07 (high - low)
;================================================================================
HudHexToDec3Digit: ; this may be overkill, could have used the 4 digit one...
	LDY.b #$90
	-
		CMP.b #100 : !BLT +
		INY
		SBC.b #100 : BRA -
	+ 
	STY $05 : LDY.b #$90 ; Store 100s digit and reset Y
	-
		CMP.b #10 : !BLT +
		INY
		SBC.b #10 : BRA -
	+ 
	STY $06 : LDY #$90 ; Store 10s digit and reset Y
	CMP.b #1 : !BLT +
	-
		INY
		DEC : BNE -
	+
	STY $07	; Store 1s digit
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
	STY $06 : LDY #$90 ; Store 10s digit and reset Y
	CMP.b #1 : !BLT +
	-
		INY
		DEC : BNE -
	+
	STY $07	; Store 1s digit
RTS
