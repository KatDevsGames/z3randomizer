;================================================================================
; Fake Flippers Softlock Fix
;--------------------------------------------------------------------------------
FlipperKill:
	PHP
	LDA $5D : CMP #$04 : BNE .done ; skip if we're not swimming
	LDA $7EF356 : BNE .done ; skip if we have the flippers
	LDA $7F5001 : BEQ .done ; skip if we're not marked in danger for softlock
	LDA $8A : CMP $7F5098 : BEQ .done ; skip if we're on the same screen we entered the water on
	;JSL.l KillFairies ; take away fairies
	LDA !IGNORE_FAIRIES : ORA.b #$04 : STA !IGNORE_FAIRIES
	LDA.b #$00 : STA $7EF36D ; kill link
	LDA.b #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	.done
	PLP
	LDA $7EF36D ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
IgnoreFairyCheck:
    LDX.b #$00 ; thing we wrote over
    LDA !IGNORE_FAIRIES : BIT.b #$04 : BEQ .normal
	
    AND.b #$FB : STA !IGNORE_FAIRIES ; clear ignore fairy flag
	LDA.b #$F0 ; set check to invalid entry
RTL
	.normal
    LDA.b #$06 ; set check to fairy
RTL
;--------------------------------------------------------------------------------
;KillFairies:
;	LDA $7EF35C : CMP #$06 : BNE +
;		LDA #$02 : STA $7EF35C
;	+ LDA $7EF35D : CMP #$06 : BNE +
;		LDA #$02 : STA $7EF35D
;	+ LDA $7EF35E : CMP #$06 : BNE +
;		LDA #$02 : STA $7EF35E
;	+ LDA $7EF35F : CMP #$06 : BNE +
;		LDA #$02 : STA $7EF35F
;	+
;RTL
;--------------------------------------------------------------------------------
FlipperReset:
	JSL $0998E8 ; AddTransitionSplash
	LDA #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	.done 
RTL
;--------------------------------------------------------------------------------
FlipperFlag:
	LDA $5D : CMP #$04 : BNE .done ; skip if we're not swimming
	LDA $7EF356 : BNE .safe ; skip if we have the flippers
	LDA #$01 : STA $7F5001 ; mark fake flipper softlock as possible
	BRA .done
	.safe
	LDA #$00 : STA $7F5001 ; mark fake flipper softlock as impossible
	.done 
RTL
;--------------------------------------------------------------------------------
RegisterWaterEntryScreen:
	PHA
		LDA $8A : STA $7F5098 ; store ow index
	PLA
RTL
;--------------------------------------------------------------------------------
MysteryWaterFunction: ; *$3AE54 ALTERNATE ENTRY POINT
    LDA.b #$20 : STA $02E2
    STZ $037B
    STZ $55
    STZ $0360
RTL
;--------------------------------------------------------------------------------
