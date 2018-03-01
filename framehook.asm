;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
; $7EF42Ew[2] - loop frame counter (low)
!LOOP_FRAMES_LOW = "$7EF42E"
;--------------------------------------------------------------------------------
; $7EF430w[2] - loop frame counter (high)
!LOOP_FRAMES_HIGH = "$7EF430"
;--------------------------------------------------------------------------------
; $7EF43Ew[2] - nmi frame counter (low)
!NMI_FRAMES_LOW = "$7EF43E"
;--------------------------------------------------------------------------------
; $7EF440w[2] - nmi frame counter (high)
!NMI_FRAMES_HIGH = "$7EF440"
;--------------------------------------------------------------------------------
; $7EF444w[2] - item menu frame counter (low)
!ITEM_FRAMES_LOW = "$7EF444"
;--------------------------------------------------------------------------------
; $7EF446w[2] - item menu frame counter (high)
!ITEM_FRAMES_HIGH = "$7EF446"
;--------------------------------------------------------------------------------
!LOCK_STATS = "$7EF443"
FrameHookAction:
	JSL $0080B5 ; Module_MainRouting
	PHA : PHP
		;LDA EnableSRAMTrace : AND.l TournamentSeedInverse : BEQ +
		;	LDA $1A : BNE ++ : JSL.l WriteStatusPreview : ++ ; write every 256 frames
		;+
		
		LDA !LOCK_STATS : BNE ++
			REP #$20 ; set 16-bit accumulator
				LDA !LOOP_FRAMES_LOW : INC : STA !LOOP_FRAMES_LOW : BNE +
					LDA !LOOP_FRAMES_HIGH : INC : STA !LOOP_FRAMES_HIGH
				+
				LDA $10 : CMP.w #$010E : BNE + ; move this to nmi hook?
				LDA !ITEM_FRAMES_LOW : INC : STA !ITEM_FRAMES_LOW : BNE +
					LDA !ITEM_FRAMES_HIGH : INC : STA !ITEM_FRAMES_HIGH
				+
			SEP #$20 ; set 8-bit accumulator ?? check this
		++
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
NMIHookAction:
	PHA : PHX : PHY : PHD ; thing we wrote over, push stuff
	
	LDA !LOCK_STATS : AND.w #$00FF : BNE ++
		LDA !NMI_FRAMES_LOW : INC : STA !NMI_FRAMES_LOW : BNE +
			LDA !NMI_FRAMES_HIGH : INC : STA !NMI_FRAMES_HIGH
		+
	++
	
JML.l NMIHookReturn
;--------------------------------------------------------------------------------
;!NMI_AUX = "$7F5044"
;PostNMIHookAction:
;	LDA !NMI_AUX+2 : BEQ +
;		LDA $00 : PHA ; preserve DP ram
;		LDA $01 : PHA
;		LDA $02 : PHA
;		
;		LDA !NMI_AUX+2 : STA $02 ; set up jump pointer
;		LDA !NMI_AUX+1 : STA $01
;		LDA !NMI_AUX+0 : STA $00
;		
;		PHK : PER .return-1 ; push stack for RTL return
;		JMP [$0000]
;		
;		.return
;		LDA.b #$00 : STA !NMI_AUX+2 ; zero bank byte of NMI hook pointer
;		
;		PLA : STA $02
;		PLA : STA $01
;		PLA : STA $00
;	+
;	
;	LDA $13 : STA $2100 ; thing we wrote over, turn screen back on
;JML.l PostNMIHookReturn
;--------------------------------------------------------------------------------