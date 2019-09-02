;================================================================================
; Service Request Support Code
;--------------------------------------------------------------------------------
; $7F5300 - $7F53FF - Multiworld Block
;	$00 - $5F - RX Buffer
;	$60 - $7E - Reserved
;		  $7F - RX Status
;	$80 - $EF - TX Buffer
;	$E0 - $FE - Reserved
;		  $FF - TX Status
;--------------------------------------------------------------------------------
; Status Codes
; #$00 - Idle
; #$01 - Local Read/Write
; #$02 - Ready for External Read/Write
;--------------------------------------------------------------------------------
; Block Commands
; #$00 - Wait
; #$01 - Signal Item-Seen
; #$02 - Signal Item-Get
; #$03 - Prompt Text
;--------------------------------------------------------------------------------
!RX_BUFFER = "$7F5300"
!RX_STATUS = "$7F537F"
!RX_SEQUENCE = "$7EF4A0"
!TX_BUFFER = "$7F5380"
!TX_STATUS = "$7F53FF"
!TX_SEQUENCE = "$7EF4A0"
;--------------------------------------------------------------------------------
PollService:
	LDA !RX_STATUS : BEQ + : SEC : RTL : + ; return fail if we don't have the lock
	LDA #$01 : STA !RX_STATUS ; mark busy
	LDA !RX_BUFFER+1 : STA !RX_SEQUENCE ; mark this as handled
	LDA !RX_BUFFER+2 : STA !RX_SEQUENCE+1
		LDA !RX_BUFFER : CMP.b #03 : BNE +
			LDA.l !RX_BUFFER+8 : TAX
			LDA.l !RX_BUFFER+9 : STA $7E012E, X ; set sound effect, could possibly make this STA not-long
			REP #$30 ; set 16-bit accumulator and index registers
				LDA !RX_BUFFER+10 : TAX
				LDA !RX_BUFFER+12
				JSL.l DoToast
			SEP #$30 ; set 8-bit accumulator and index registers
		+
	LDA #$00 : STA !RX_STATUS ; release lock
	CLC ; mark request as successful
RTL
;--------------------------------------------------------------------------------
macro ServiceRequest(type)
	LDA !TX_STATUS : BEQ + : SEC : RTL : + ; return fail if we don't have the lock
	LDA #$01 : STA !TX_STATUS ; mark busy
		LDA $7B : STA !TX_BUFFER+1 ; world
		LDA $1B : STA !TX_BUFFER+2 ; indoor/outdoor
		LDA $A0 : STA !TX_BUFFER+3 ; roomid low
		LDA $A1 : STA !TX_BUFFER+4 ; roomid high
		LDA $76 : STA !TX_BUFFER+5 ; object index (type 2 only)
		LDA <type> : STA !TX_BUFFER ; item get
	LDA #$00 : STA !TX_STATUS ; release lock
	CLC ; mark request as successful
RTL
endmacro
;--------------------------------------------------------------------------------
ItemVisualServiceRequest:
%ServiceRequest(#$01)
;--------------------------------------------------------------------------------
ItemGetServiceRequest:
%ServiceRequest(#$02)
;--------------------------------------------------------------------------------