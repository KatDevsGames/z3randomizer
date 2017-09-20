;--------------------------------------------------------------------------------
; OnLoadOW
;--------------------------------------------------------------------------------
OnLoadMap:
	JSL.l SetLWDWMap
	LDA $7EF2DB ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
OnDrawHud:
	JSL.l Draw4DigitRupees
	JSL.l DrawChallengeTimer
	JSL.l DrawGoalIndicator
	JSL.l DrawDungeonCompassCounts
RTL
;--------------------------------------------------------------------------------
OnDungeonEntrance:
	PHA : PHP
		SEP #$20 ; set 8-bit accumulator
		LDA $040C : CMP #$FF : BEQ + ; don't do this unless it's a real dungeon
		REP #$20 : LDA $A0 : CMP.w #18 : BEQ + : SEP #$20 ; skip if we're in the sanctuary
		LDA $7EF3CC ; load follower
		CMP #$0C : BNE + ; skip if not the purple chest
			LDA #$00 : STA $7EF3CC
		+ ; this might get hit from above in either accumulator mode
	PLP : PLA
	STA $7EC172 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnFileLoad:
	LDA !FRESH_FILE_MARKER : BNE +
		JSL.l OnNewFile
		LDA.b #$FF : STA !FRESH_FILE_MARKER
	+
	JSL.l DarkWorldFlagSet
	JSL.l MasterSwordFollowerClear
	JSL.l InitOpenMode
	LDA #$FF : STA !RNG_ITEM_LOCK_IN ; reset rng item lock-in
	LDA #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnNewFile:
	REP #$20 ; set 16-bit accumulator
	LDA.l StartingTime : STA $7EF454
	LDA.l StartingTime+2 : STA $7EF454+2
	SEP #$20 ; set 8-bit accumulator
	;LDA #$FF : STA !RNG_ITEM_LOCK_IN ; reset rng item lock-in
	LDA.l PreopenCurtains : BEQ +
		LDA.b #$80 : STA $7EF061 ; open aga tower curtain
		LDA.b #$80 : STA $7EF093 ; open skull woods curtain
	+
	LDA StartingSword : STA $7EF359 ; set starting sword type
RTL
;--------------------------------------------------------------------------------
OnLinkDamaged:
	JSL.l FlipperKill
	JSL.l OHKOTimer
RTL
;--------------------------------------------------------------------------------
OnEnterWater:
	JSL.l RegisterWaterEntryScreen
	
	JSL.l MysteryWaterFunction
	LDX.b #$04
RTL
;--------------------------------------------------------------------------------
OnLinkDamagedFromPit:
	JSL.l OHKOTimer
	LDA.b #$14 : STA $11 ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
!RNG_ITEM_LOCK_IN = "$7F5090"
OnOWTransition:
	JSL.l FloodGateReset
	JSL.l FlipperFlag
	JSL.l StatTransitionCounter
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.b #$FF : STA !RNG_ITEM_LOCK_IN ; clear lock-in
	PLP
RTL
;--------------------------------------------------------------------------------
PreItemGet:
	LDA.b #$01 : STA !ITEM_BUSY ; mark item as busy
RTL
;--------------------------------------------------------------------------------
PostItemGet:
	JSL.l MaybeWriteSRAMTrace
RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
	LDA.b #$00 : STA !ITEM_BUSY ; mark item as finished
	
	;LDA $7F50A0 : BEQ +
	;	JSL.l Main_ShowTextMessage
	;	LDA.b #$00 : STA $7F50A0
	;+
	
    STZ $02E9 : LDA $0C5E, X ; thing we wrote over to get here
RTL
;--------------------------------------------------------------------------------