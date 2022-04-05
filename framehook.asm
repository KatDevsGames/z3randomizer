;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
FrameHookAction:
	JSL $0080B5 ; Module_MainRouting
	JSL CheckMusicLoadRequest
	PHP : REP #$30 : PHA
	
		SEP #$20
		
		LDA StatsLocked : BNE ++
			REP #$20 ; set 16-bit accumulator
				LDA LoopFrames : INC : STA LoopFrames : BNE +
					LDA LoopFrames+2 : INC : STA LoopFrames+2
				+
				LDA $10 : CMP.w #$010E : BNE + ; move this to nmi hook?
				LDA MenuFrames : INC : STA MenuFrames : BNE +
					LDA MenuFrames+2 : INC : STA MenuFrames+2
				+
		++
	REP #$30 : PLA : PLP
RTL
;--------------------------------------------------------------------------------
NMIHookAction:
	PHA : PHX : PHY : PHD ; thing we wrote over, push stuff
	
	LDA StatsLocked : AND.w #$00FF : BNE ++
		LDA NMIFrames : INC : STA NMIFrames : BNE +
			LDA NMIFrames+2 : INC : STA NMIFrames+2
		+
	++
	
JML.l NMIHookReturn
;--------------------------------------------------------------------------------
!NMI_AUX = "$7F5044"
PostNMIHookAction:
	LDA !NMI_AUX : BEQ +
		LDA $00 : PHA ; preserve DP ram
		LDA $01 : PHA
		LDA $02 : PHA
		
		LDA !NMI_AUX+2 : STA $02 ; set up jump pointer
		LDA !NMI_AUX+1 : STA $01
		LDA !NMI_AUX+0 : STA $00
		
		PHK : PER .return-1 ; push stack for RTL return
		JMP [$0000]
		
		.return
		LDA.b #$00 : STA !NMI_AUX ; zero bank byte of NMI hook pointer
		
		PLA : STA $02
		PLA : STA $01
		PLA : STA $00
	+
	
	LDA $13 : STA $2100 ; thing we wrote over, turn screen back on
JML.l PostNMIHookReturn
;--------------------------------------------------------------------------------
