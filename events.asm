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
		LDA $7EF3CC ; load follower
		CMP #$0C : BNE + ; skip if not the purple chest
			LDA #$00 : STA $7EF3CC
		+
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
	;JSL.l FlipperKill
	JSL.l OHKOTimer
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
	;LDA $02D8
	;CMP #$70 : !BLT +
	;CMP #$B0 : !BGE +
	;	JSL.l FreeDungeonItemNotice
	;+
	JSL.l MaybeWriteSRAMTrace
RTL
;--------------------------------------------------------------------------------
PostItemAnimation:
	LDA.b #$00 : STA !ITEM_BUSY ; mark item as finished
    STZ $02E9 : LDA $0C5E, X ; thing we wrote over to get here
RTL
;--------------------------------------------------------------------------------