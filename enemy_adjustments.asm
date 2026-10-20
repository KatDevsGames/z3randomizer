;--------------------------------------------------------------------------------
; NewBatInit:
; make sure bats always load LW stats
;--------------------------------------------------------------------------------
NewBatInit:
	CPY.b #$00 : BEQ .light_world
	;check if map id == 240 or 241
	LDA.b RoomIndex : CMP.b #$F0 : BEQ .light_world ;oldman cave1
	CMP.b #$F1 : BEQ .light_world ;oldman cave2
	CMP.b #$B0 : BEQ .light_world ;agahnim statue keese
	CMP.b #$D0 : BEQ .light_world ;agahnim darkmaze

	
	LDA.b #$85 : STA.w SpriteBump, X
	LDA.b #$04 : STA.w SpriteHitPoints, X
RTL
	.light_world
		LDA.b #$80 : STA.w SpriteBump, X
		LDA.b #$01 : STA.w SpriteHitPoints, X
RTL
;--------------------------------------------------------------------------------
NewFireBarDamage:
        LDA.b LinkLayer : CMP.w SpriteLayer, X : BNE .NotSameLayer
                JSL Sprite_AttemptDamageToPlayerPlusRecoilLong
                RTL
.NotSameLayer
RTL

;--------------------------------------------------------------------------------
; Moldorm_UpdateOamPosition:
; adjust oam space to the maximum of 8 possible eyes
;--------------------------------------------------------------------------------
Moldorm_UpdateOamPosition:
	REP #$21
	LDA.b $90
	ADC.w #$0020
	STA.b $90
	LDA.b $92
	ADC.w #$08
	STA.b $92
RTL

;===================================================================================================

TektitePrep: ; they actually end up being identical code
BeetlePrep:
StalfosPrep:
	LDA.b $1B : BEQ .overworld

	LDA.w $0E30,X ; retain value
	RTL

	; vanilla in overworld
.overworld
	LDA.w $0D10,X
	AND.b #$010
	RTL

;===================================================================================================

GeldmanDrawCheck:
	LDA.l VisibleHiddenEnemies
	BNE .unhide

.vanilla
	LDA.w $0D80,X
	CMP.b #$02
	RTL

.unhide
	LDA.b #$01
	STA.w $0DC0,X
	RTL

;===================================================================================================

StalfosKnightDrawCheck:
	LDA.l VisibleHiddenEnemies
	BNE .unhide

.vanilla
	JML GetScreenCoordinates_long

.unhide
	JSL GetScreenCoordinates_long
	JML Sprite_DrawShadowLong

;===================================================================================================

BlobDrawCheck:
	LDA.l VisibleHiddenEnemies
	BNE .unhide

.vanilla
	LDA.b $0D80,X
	BEQ .invisible

	JML DoDrawBlob

.invisible
	JML $9EB209

.unhide
	LDA.b #$05
	STA.w $0DC0,X
	JML DoDrawBlob

;===================================================================================================

SnitchGuardMusic = $0E90 ; this seems safe?

TryGuardMusic:
	; check if we were spawned by a snitch
	LDA.w SnitchGuardMusic,X
	BEQ .exit

	LDA.w $0136 ; check for overworld song bank
	BNE .fail

	LDA.b #$0C ; SONG 0C
	CMP.w $0130
	BEQ .fail ; don't duplicate

	STA.w $012C

.exit
	RTL

.fail
	STZ.w SnitchGuardMusic,X
	RTL

;---------------------------------------------------------------------------------------------------

TryUndoGuardMusic:
	LDA.w SnitchGuardMusic,X
	BEQ .exit

	
	LDY.w $0136 ; check for overworld song bank
	BNE .exit

	CPY.w $0130 ; don't duplicate
	BEQ .exit

	LDY.w $012C ; don't override
	BNE .exit

	STA.w $012C

.exit
	RTL

;---------------------------------------------------------------------------------------------------
; only used when actually called by a snitch
;---------------------------------------------------------------------------------------------------
FinalizeSnitchGuard:
	LDA.b #$0B : STA.w $0F50,Y
	LDA.w $0130 : STA.w SnitchGuardMusic,Y ; remember last song played
	PLB
	RTL
