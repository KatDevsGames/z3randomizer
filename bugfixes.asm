;================================================================================

;--------------------------------------------------------------------------------
AssignKiki:
    LDA.b #$00 : STA $7EF3D3 ; defuse bomb
    LDA.b #$0A : STA $7EF3CC ; assign kiki as follower
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Name: AllowSQ
; Returns: Accumulator = 0 if S&Q is disallowed, 1 if allowed
;--------------------------------------------------------------------------------
!ITEM_BUSY = "$7F5091"
AllowSQ:
	LDA $7EF3C5 : BEQ .done ; thing we overwrote - check if link is in his bed
	LDA !ITEM_BUSY : EOR #$01
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Reset Music
;1 = Don't Reset Music
MSMusicReset:
	LDA $8A : CMP.b #$80 : BNE +
		LDA $23
	+
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Become Permabunny
DecideIfBunny:
	LDA $7EF357 : BEQ + : RTL : +
	LDA $7EF3CA : AND.b #$40 : EOR #$40
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;ReadInventoryPond:
;	CPX.b #$1B : BNE + : LDA.b #$01 : RTL : +
;	LDA $7EF340, X
;RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
FixBunnyOnExitToLightWorld:
    JSL.l FakeWorldFix
    LDA.w $02E0 : BEQ +
        JMP.w DecideIfBunny
    +
    LDA $7EF357; thing we overwrote
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; fix issue where if a player beats aga1 without moon pearl, they don't turn into
; bunny on the pyramid
FixAga2Bunny:
    LDA.l FixFakeWorld :  BEQ + ; Only use this fix is fakeworld fix is in use
	JSL DecideIfBunny : BNE +
		JSR MakeBunny
		LDA.b #$04 : STA.w $012C ; play bunny music
		BRA .done
	+
	LDA.b #$09 : STA.w $012C ; what we wrote over
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
MakeBunny:
    PHX : PHY
	LDA.b #$17 : STA $5D ; set player mode to permabunny
	LDA.b #$01 : STA $02E0 : STA $56 ; make player look like bunny
	JSL LoadGearPalettes_bunny
    PLY : PLX
RTS
;--------------------------------------------------------------------------------
