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
	STA.w ClockHours ; clear digit storage
	STA.w ClockHours+2
	STA.w ClockMinutes
	STA.w ClockMinutes+2
	STA.w ClockSeconds
	STA.w ClockSeconds+2

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
			LDA.w ClockBuffer : EOR.w #$FFFF : !ADD.w #$0001 : STA.w ClockBuffer
			LDA.w ClockBuffer+2 : EOR.w #$FFFF : ADC.w #$0000 : STA.w ClockBuffer+2
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

	LDA.w ClockHours : !ADD.w #$2490 : STA.w ClockHours ; convert decimal values to tiles
	LDA.w ClockHours+2 : !ADD.w #$2490 : STA.w ClockHours+2
	LDA.w ClockMinutes : !ADD.w #$2490 : STA.w ClockMinutes
	LDA.w ClockMinutes+2 : !ADD.w #$2490 : STA.w ClockMinutes+2
	LDA.w ClockSeconds : !ADD.w #$2490 : STA.w ClockSeconds
	LDA.w ClockSeconds+2 : !ADD.w #$2490 : STA.w ClockSeconds+2
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
	LDA.l OHKOFlag : AND.w #$00FF : BEQ +
                LDA.w #$2807 : STA.l $7EC790
                LDA.w #$280A : STA.l $7EC792
                LDA.w #$280B : STA.l $7EC794
                LDA.w #$280C : STA.l $7EC796
                RTL
        +
        LDA.w #$247F : STA.l $7EC790
        STA.l $7EC792
        STA.l $7EC794
        STA.l $7EC796
        ++

        LDA.l TimerStyle : BNE + : RTL : + ; Hud Timer
        LDA.w #$2807 : STA.l $7EC792    	
        LDA.l ClockStatus : AND.w #$0002 : BEQ + ; DNF / OKHO

			LDA.l TimeoutBehavior : AND.w #$00FF : BNE ++ ; DNF
				LDA.w #$2808 : STA.l $7EC794
				LDA.w #$2809 : STA.l $7EC796
				LDA.w #$247F : STA.l $7EC798
				STA.l $7EC79A
				BRA +++
			++ ; OHKO
				LDA.w #$280A : STA.l $7EC794
				LDA.w #$280B : STA.l $7EC796
				LDA.w #$280C : STA.l $7EC798
				LDA.w #$247F : STA.l $7EC79A
			+++
			STA.l $7EC79C
			STA.l $7EC79E
			STA.l $7EC7A0
			STA.l $7EC7A2
			STA.l $7EC7A4
			LDA.l TimerRestart : BNE +++ : RTL : +++
			BRA ++
		+ ; Show Timer
	    	LDA.l ClockStatus : AND.w #$0001 : !ADD.w #$2804 : STA.l $7EC794
			LDA.w ClockHours+2 : STA.l $7EC796
			LDA.w ClockHours : STA.l $7EC798
	    	LDA.w #$2806 : STA.l $7EC79A
			LDA.w ClockMinutes+2 : STA.l $7EC79C
			LDA.w ClockMinutes : STA.l $7EC79E
	    	LDA.w #$2806 : STA.l $7EC7A0
			LDA.w ClockSeconds+2 : STA.l $7EC7A2
			LDA.w ClockSeconds : STA.l $7EC7A4
		++
		LDA.b $1A : AND.w #$001F : BNE + : JSR CalculateTimer : +

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
