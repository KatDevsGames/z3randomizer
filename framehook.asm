;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
FrameHookAction:
	JSL $0080B5 ; Module_MainRouting
	JSL CheckMusicLoadRequest
	PHP : REP #$30 : PHA
	
		SEP #$20
		
		LDA.l StatsLocked : BNE ++
			REP #$20 ; set 16-bit accumulator
				LDA.l LoopFrames : INC : STA.l LoopFrames : BNE +
					LDA.l LoopFrames+2 : INC : STA.l LoopFrames+2
				+
				LDA.l $10 : CMP.w #$010E : BNE + ; move this to nmi hook?
				LDA.l MenuFrames : INC : STA.l MenuFrames : BNE +
					LDA.l MenuFrames+2 : INC : STA.l MenuFrames+2
				+
		++
	REP #$30 : PLA : PLP
RTL
;--------------------------------------------------------------------------------
NMIHookAction:
	PHA : PHX : PHY : PHD ; thing we wrote over, push stuff
	
	LDA.l StatsLocked : AND.w #$00FF : BNE ++
		LDA.l NMIFrames : INC : STA.l NMIFrames : BNE +
			LDA.l NMIFrames+2 : INC : STA.l NMIFrames+2
		+
	++
	
JML.l NMIHookReturn
;--------------------------------------------------------------------------------
PostNMIHookAction:
	LDA.l NMIAux : BEQ +
		LDA.b Scrap00 : PHA ; preserve DP ram
		LDA.b Scrap01 : PHA
		LDA.b Scrap02 : PHA
		
		LDA.l NMIAux+2 : STA.b Scrap02 ; set up jump pointer
		LDA.l NMIAux+1 : STA.b Scrap01 
		LDA.l NMIAux+0 : STA.b Scrap00 
		
		PHK : PER .return-1 ; push stack for RTL return
		JMP [$0000]
		
		.return
		LDA.b #$00 : STA.l NMIAux ; zero bank byte of NMI hook pointer
		
		PLA : STA.b Scrap02
		PLA : STA.b Scrap01
		PLA : STA.b Scrap00
	+
	
	LDA.b $13 : STA.w INIDISP ; thing we wrote over, turn screen back on
JML.l PostNMIHookReturn
;--------------------------------------------------------------------------------
