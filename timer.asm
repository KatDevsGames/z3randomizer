;================================================================================
; Challenge Timer
;================================================================================
;--------------------------------------------------------------------------------
!FRAMES_PER_SECOND = 60
!FRAMES_PER_MINUTE = 60*60
!FRAMES_PER_HOUR = 60*60*60
;--------------------------------------------------------------------------------
macro DecIncr(value)
	LDA.w <value> : INC
		CMP.w #$000A : !BLT ?noIncr
			LDA.w <value>+2 : INC : STA.w <value>+2
			LDA.w #$0000
		?noIncr:
	STA.w <value>
endmacro
;--------------------------------------------------------------------------------
macro Sub32(minuend,subtrahend,result)
	LDA.l <minuend>
	!SUB.l <subtrahend>		; perform subtraction on the LSBs
	STA.w <result>
	LDA.l <minuend>+2		; do the same for the MSBs, with carry
	SBC.l <subtrahend>+2	; set according to the previous result
	STA.w <result>+2
endmacro
;--------------------------------------------------------------------------------
macro Blt32(value1,value2)
	LDA.w <value1>+2
	CMP.l <value2>+2
	!BLT ?done
	BNE ?done
		LDA.l <value1>
		CMP.l <value2>
	?done:
endmacro
;--------------------------------------------------------------------------------
CalculateTimer:
	LDA.w #$0000
	STA.l ClockHours ; clear digit storage
	STA.l ClockHours+2
	STA.l ClockMinutes
	STA.l ClockMinutes+2
	STA.l ClockSeconds
	STA.l ClockSeconds+2

	LDA.l TimerStyle : AND.w #$00FF : CMP.w #$0002 : BNE + ; Stopwatch Mode
		%Sub32(NMIFrames,ChallengeTimer,ClockBuffer)
		BRA ++
	+ CMP.w #$0001 : BNE ++ ; Countdown Mode
		%Sub32(ChallengeTimer,NMIFrames,ClockBuffer)
	++

	%Blt32(ClockBuffer,.halfCycle) : !BLT +
		LDA.l TimeoutBehavior : AND.w #$00FF : BNE ++ ; DNF
			LDA.w #$0002 : STA.l ClockStatus ; Set DNF Mode
			LDA.l NMIFrames : STA.l ChallengeTimer
			LDA.l NMIFrames+2 : STA.l ChallengeTimer+2
			RTS
		++ CMP.w #$0001 : BNE ++ ; Negative Time
			LDA.l ClockBuffer : EOR.w #$FFFF : !ADD.w #$0001 : STA.l ClockBuffer
			LDA.l ClockBuffer+2 : EOR.w #$FFFF : ADC.w #$0000 : STA.l ClockBuffer+2
			LDA.w #$0001 : STA.l ClockStatus ; Set Negative Mode
			BRA .prepDigits
		++ CMP.w #$0002 : BNE ++ ; OHKO
			LDA.w #$0002 : STA.l ClockStatus ; Set DNF Mode
			LDA.l NMIFrames : STA.l ChallengeTimer
			LDA.l NMIFrames+2 : STA.l ChallengeTimer+2
			RTS
		++ ; End Game
			SEP #$30
				JSL.l ActivateGoal
			REP #$30
			RTS
	+

	LDA.l TimerRestart : AND.w #$00FF : BEQ +
		LDA.w #$0000 : STA.l ClockStatus ; Set Positive Mode
	+
	.prepDigits

	-
		%Blt32(ClockBuffer,.hour) : !BLT +
		%DecIncr(ClockHours)
		%Sub32(ClockBuffer,.hour,ClockBuffer) : BRA -
	+ -
		%Blt32(ClockBuffer,.minute) : !BLT +
		%DecIncr(ClockMinutes)
		%Sub32(ClockBuffer,.minute,ClockBuffer) : BRA -
	+ -
		%Blt32(ClockBuffer,.second) : !BLT +
		%DecIncr(ClockSeconds)
		%Sub32(ClockBuffer,.second,ClockBuffer) : BRA -
	+

	LDA.l ClockHours : !ADD.w #$2490 : STA.l ClockHours ; convert decimal values to tiles
	LDA.l ClockHours+2 : !ADD.w #$2490 : STA.l ClockHours+2
	LDA.l ClockMinutes : !ADD.w #$2490 : STA.l ClockMinutes
	LDA.l ClockMinutes+2 : !ADD.w #$2490 : STA.l ClockMinutes+2
	LDA.l ClockSeconds : !ADD.w #$2490 : STA.l ClockSeconds
	LDA.l ClockSeconds+2 : !ADD.w #$2490 : STA.l ClockSeconds+2
RTS
;--------------------------------------------------------------------------------
.hour
dw #$4BC0, #$0003
.minute
dw #$0E10, #$0000
.second
dw #$003C, #$0000
.halfCycle
dw #$FFFF, #$7FFF
;--------------------------------------------------------------------------------
DrawChallengeTimer:
        JSR.w CheckOHKO : BCC ++
	        AND.w #$00FF : BEQ +
                        LDA.w #$2807 : STA.l HUDTileMapBuffer+$90
                        LDA.w #$280A : STA.l HUDTileMapBuffer+$92
                        LDA.w #$280B : STA.l HUDTileMapBuffer+$94
                        LDA.w #$280C : STA.l HUDTileMapBuffer+$96
                        RTL
                +
                LDA.w #$247F : STA.l HUDTileMapBuffer+$90
                STA.l HUDTileMapBuffer+$92
                STA.l HUDTileMapBuffer+$94
                STA.l HUDTileMapBuffer+$96
        ++
        LDA.l TimerStyle : BNE + : RTL : + ; Hud Timer
        LDA.w #$2807 : STA.l HUDTileMapBuffer+$92    	
        LDA.l ClockStatus : AND.w #$0002 : BEQ + ; DNF / OKHO

			LDA.l TimeoutBehavior : AND.w #$00FF : BNE ++ ; DNF
				LDA.w #$2808 : STA.l HUDTileMapBuffer+$94
				LDA.w #$2809 : STA.l HUDTileMapBuffer+$96
				LDA.w #$247F : STA.l HUDTileMapBuffer+$98
				STA.l HUDTileMapBuffer+$9A
				BRA +++
			++ ; OHKO
				LDA.w #$280A : STA.l HUDTileMapBuffer+$94
				LDA.w #$280B : STA.l HUDTileMapBuffer+$96
				LDA.w #$280C : STA.l HUDTileMapBuffer+$98
				LDA.w #$247F : STA.l HUDTileMapBuffer+$9A
			+++
			STA.l HUDTileMapBuffer+$9C
			STA.l HUDTileMapBuffer+$9E
			STA.l HUDTileMapBuffer+$A0
			STA.l HUDTileMapBuffer+$A2
			STA.l HUDTileMapBuffer+$A4
			LDA.l TimerRestart : BNE +++ : RTL : +++
			BRA ++
		+ ; Show Timer
	    	LDA.l ClockStatus : AND.w #$0001 : !ADD.w #$2804 : STA.l HUDTileMapBuffer+$94
			LDA.l ClockHours+2 : STA.l HUDTileMapBuffer+$96
			LDA.l ClockHours : STA.l HUDTileMapBuffer+$98
	    	LDA.w #$2806 : STA.l HUDTileMapBuffer+$9A
			LDA.l ClockMinutes+2 : STA.l HUDTileMapBuffer+$9C
			LDA.l ClockMinutes : STA.l HUDTileMapBuffer+$9E
	    	LDA.w #$2806 : STA.l HUDTileMapBuffer+$A0
			LDA.l ClockSeconds+2 : STA.l HUDTileMapBuffer+$A2
			LDA.l ClockSeconds : STA.l HUDTileMapBuffer+$A4
		++
		LDA.b FrameCounter : AND.w #$001F : BNE + : JSR CalculateTimer : +

RTL
;--------------------------------------------------------------------------------
OHKOTimer:
	LDA.l OHKOFlag : BNE .kill
	LDA.l TimeoutBehavior : CMP.b #$02 : BNE +
	LDA.l ClockStatus : AND.b #$02 : BEQ +
		.kill
		LDA.b #$00 : STA.l CurrentHealth ; kill link
	+
	LDA.l CurrentHealth
RTL
;--------------------------------------------------------------------------------
CheckOHKO:
        SEP #$20
        LDA.l OHKOFlag : CMP.l OHKOCached : BNE .change
                REP #$21
                RTS
        .change
        STA.l OHKOCached
        LDA.b #$01 : STA.l UpdateHUDFlag
        REP #$20
        SEC
RTS
;--------------------------------------------------------------------------------
