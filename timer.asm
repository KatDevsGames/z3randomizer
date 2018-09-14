;================================================================================
; Challenge Timer
;================================================================================
!Temp = "$7F5020"
!BaseTimer = "$7EF43E"
!ChallengeTimer = "$7EF454"
!TemporaryOHKO = "$7F50CC"
;--------------------------------------------------------------------------------
!CLOCK_HOURS = "$7F5080" ; $7F5080 - $7F5083 - Clock Hours
!CLOCK_MINUTES = "$7F5084" ; $7F5084 - $7F5087 - Clock Minutes
!CLOCK_SECONDS = "$7F5088" ; $7F5088 - $7F508B - Clock Seconds
!CLOCK_TEMPORARY = "$7F508C" ; $7F508C - $7F508F - Clock Temporary
;--------------------------------------------------------------------------------
!FRAMES_PER_SECOND = #60
!FRAMES_PER_MINUTE = #60*60
!FRAMES_PER_HOUR = #60*60*60
;--------------------------------------------------------------------------------
!Status = "$7F507E"
; ---- --dn
; d - dnf
; n - negative
;--------------------------------------------------------------------------------
macro DecIncr(value)
	LDA.l <value> : INC
		CMP.w #$000A : !BLT ?noIncr
			LDA.l <value>+2 : INC : STA.l <value>+2
			LDA.w #$0000
		?noIncr:
	STA.l <value>
endmacro
;--------------------------------------------------------------------------------
macro Sub32(minuend,subtrahend,result)
	LDA.l <minuend>
	!SUB.l <subtrahend>		; perform subtraction on the LSBs
	STA.l <result>
	LDA.l <minuend>+2		; do the same for the MSBs, with carry
	SBC.l <subtrahend>+2	; set according to the previous result
	STA.l <result>+2
endmacro
;--------------------------------------------------------------------------------
macro Blt32(value1,value2)
	LDA.l <value1>+2
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
	STA.l !CLOCK_HOURS ; clear digit storage
	STA.l !CLOCK_HOURS+2
	STA.l !CLOCK_MINUTES
	STA.l !CLOCK_MINUTES+2
	STA.l !CLOCK_SECONDS
	STA.l !CLOCK_SECONDS+2

	LDA.l TimerStyle : AND.w #$00FF : CMP.w #$0002 : BNE + ; Stopwatch Mode
		%Sub32(!BaseTimer,!ChallengeTimer,!CLOCK_TEMPORARY)
		BRA ++
	+ CMP.w #$0001 : BNE ++ ; Countdown Mode
		%Sub32(!ChallengeTimer,!BaseTimer,!CLOCK_TEMPORARY)
	++

	%Blt32(!CLOCK_TEMPORARY,.halfCycle) : !BLT +
		LDA.l TimeoutBehavior : AND.w #$00FF : BNE ++ ; DNF
			LDA.w #$0002 : STA.l !Status ; Set DNF Mode
			LDA.l !BaseTimer : STA.l !ChallengeTimer
			LDA.l !BaseTimer+2 : STA.l !ChallengeTimer+2
			RTS
		++ CMP.w #$0001 : BNE ++ ; Negative Time
			LDA.l !CLOCK_TEMPORARY : EOR.w #$FFFF : !ADD.w #$0001 : STA.l !CLOCK_TEMPORARY
			LDA.l !CLOCK_TEMPORARY+2 : EOR.w #$FFFF : ADC.w #$0000 : STA.l !CLOCK_TEMPORARY+2
			LDA.w #$0001 : STA.l !Status ; Set Negative Mode
			BRA .prepDigits
		++ CMP.w #$0002 : BNE ++ ; OHKO
			LDA.w #$0002 : STA.l !Status ; Set DNF Mode
			LDA.l !BaseTimer : STA.l !ChallengeTimer
			LDA.l !BaseTimer+2 : STA.l !ChallengeTimer+2
			RTS
		++ ; End Game
			SEP #$30
				JSL.l ActivateGoal
			REP #$30
			RTS
	+

	LDA.l TimerRestart : AND.w #$00FF : BEQ +
		LDA.w #$0000 : STA.l !Status ; Set Positive Mode
	+
	.prepDigits

	-
		%Blt32(!CLOCK_TEMPORARY,.hour) : !BLT +
		%DecIncr(!CLOCK_HOURS)
		%Sub32(!CLOCK_TEMPORARY,.hour,!CLOCK_TEMPORARY) : BRA -
	+ -
		%Blt32(!CLOCK_TEMPORARY,.minute) : !BLT +
		%DecIncr(!CLOCK_MINUTES)
		%Sub32(!CLOCK_TEMPORARY,.minute,!CLOCK_TEMPORARY) : BRA -
	+ -
		%Blt32(!CLOCK_TEMPORARY,.second) : !BLT +
		%DecIncr(!CLOCK_SECONDS)
		%Sub32(!CLOCK_TEMPORARY,.second,!CLOCK_TEMPORARY) : BRA -
	+

	LDA !CLOCK_HOURS : !ADD.w #$2490 : STA !CLOCK_HOURS ; convert decimal values to tiles
	LDA !CLOCK_HOURS+2 : !ADD.w #$2490 : STA !CLOCK_HOURS+2
	LDA !CLOCK_MINUTES : !ADD.w #$2490 : STA !CLOCK_MINUTES
	LDA !CLOCK_MINUTES+2 : !ADD.w #$2490 : STA !CLOCK_MINUTES+2
	LDA !CLOCK_SECONDS : !ADD.w #$2490 : STA !CLOCK_SECONDS
	LDA !CLOCK_SECONDS+2 : !ADD.w #$2490 : STA !CLOCK_SECONDS+2
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
!TEMPORARY_OHKO = "$7F50CC"
DrawChallengeTimer:
	LDA !TEMPORARY_OHKO : AND.w #$00FF : BEQ +
    	LDA.w #$2807 : STA $7EC790
		LDA.w #$280A : STA $7EC792
		LDA.w #$280B : STA $7EC794
		LDA.w #$280C : STA $7EC796
		RTL
	+
    	LDA.w #$247F : STA $7EC790
					   STA $7EC792
					   STA $7EC794
					   STA $7EC796
	++
	
	LDA.l TimerStyle : BNE + : RTL : + ; Hud Timer
    	LDA.w #$2807 : STA $7EC792
    	
    	LDA.l !Status : AND.w #$0002 : BEQ + ; DNF / OKHO
    	
			LDA.l TimeoutBehavior : AND.w #$00FF : BNE ++ ; DNF
				LDA.w #$2808 : STA $7EC794
				LDA.w #$2809 : STA $7EC796
				LDA.w #$247F : STA $7EC798
				STA $7EC79A
				BRA +++
			++ ; OHKO
				LDA.w #$280A : STA $7EC794
				LDA.w #$280B : STA $7EC796
				LDA.w #$280C : STA $7EC798
				LDA.w #$247F : STA $7EC79A
			+++
			STA $7EC79C
			STA $7EC79E
			STA $7EC7A0
			STA $7EC7A2
			STA $7EC7A4
			LDA.l TimerRestart : BNE +++ : RTL : +++
			BRA ++
		+ ; Show Timer
	    	LDA.l !Status : AND.w #$0001 : !ADD.w #$2804 : STA $7EC794
			LDA !CLOCK_HOURS+2 : STA $7EC796
			LDA !CLOCK_HOURS : STA $7EC798
	    	LDA.w #$2806 : STA $7EC79A
			LDA !CLOCK_MINUTES+2 : STA $7EC79C
			LDA !CLOCK_MINUTES : STA $7EC79E
	    	LDA.w #$2806 : STA $7EC7A0
			LDA !CLOCK_SECONDS+2 : STA $7EC7A2
			LDA !CLOCK_SECONDS : STA $7EC7A4
		++
		LDA $1A : AND.w #$001F : BNE + : JSR CalculateTimer : +

RTL
;--------------------------------------------------------------------------------
OHKOTimer:
	LDA !TemporaryOHKO : BNE .kill
	LDA.l TimeoutBehavior : CMP #$02 : BNE +
	LDA !Status : AND.b #$02 : BEQ +
		.kill
		LDA.b #$00 : STA $7EF36D ; kill link
	+
	LDA $7EF36D
RTL
;--------------------------------------------------------------------------------
