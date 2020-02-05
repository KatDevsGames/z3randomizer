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
; #$01 - Ready to Read
; #$FF - Busy
;--------------------------------------------------------------------------------
; Block Commands
!SCM_WAIT = "#$00"

!SCM_SEEN = "#$01"
!SCM_GET = "#$02"
!SCM_GIVE = "#$03"
!SCM_PROMPT = "#$04"
!SCM_AREACHG = "#$05"
!SCM_DUNGEON = "#$06"
!SCM_DEATH = "#$07"
!SCM_SAVEQUIT = "#$08"
!SCM_FCREATE = "#$09"
!SCM_FLOAD = "#$0A"
!SCM_FCDELETE = "#$0B"
!SCM_SPAWN = "#$0C"
!SCM_PAUSE = "#$0D"

!SCM_STALL = "#$7E"
!SCM_RESUME = "#$7F"
; ;--------------------------------------------------------------------------------
!RX_BUFFER = "$7F5300"
!RX_STATUS = "$7F537F"
!RX_SEQUENCE = "$7EF4A0"
!TX_BUFFER = "$7F5380"
!TX_STATUS = "$7F53FF"
!TX_SEQUENCE = "$7EF4A0"
;--------------------------------------------------------------------------------
PollService:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA !RX_STATUS : DEC : BEQ + : PLP : SEC : RTL : + ; return fail if there's nothing to read
		LDA #$FF : STA !RX_STATUS ; stop calls from recursing in
		LDA !RX_BUFFER : CMP.b !SCM_GIVE : BNE +
			PHY : LDA.l !RX_BUFFER+8 : TAY
			LDA.l !RX_BUFFER+9 : BNE ++
				JSL.l Link_ReceiveItem ; do something else
				PLY : BRA .done
			++
				JSL.l Link_ReceiveItem
				PLY : BRA .done
		+ : CMP.b !SCM_PROMPT : BNE +
			LDA.l !RX_BUFFER+8 : TAX
			LDA.l !RX_BUFFER+9 : STA $7E012E, X ; set sound effect, could possibly make this STA not-long
			REP #$30 ; set 16-bit accumulator and index registers
				LDA !RX_BUFFER+10 : TAX
				LDA !RX_BUFFER+12
				JSL.l DoToast
			SEP #$30 ; set 8-bit accumulator and index registers
		+
	.done
	LDA #$00 : STA !RX_STATUS ; release lock
	PLP
	CLC ; mark request as successful
RTL
;--------------------------------------------------------------------------------
macro ServiceRequest(type)
	LDA !TX_STATUS : BEQ + : SEC : RTL : + ; return fail if we don't have the lock
		LDA $1B : STA !TX_BUFFER+8 ; indoor/outdoor
		LDA $A0 : STA !TX_BUFFER+9 ; roomid low
		LDA $A1 : STA !TX_BUFFER+10 ; roomid high
		LDA $76 : STA !TX_BUFFER+11 ; object index (type 2 only)
		LDA <type> : STA !TX_BUFFER ; item get
	LDA #$01 : STA !TX_STATUS ; mark ready for reading
	CLC ; mark request as successful
RTL
endmacro
;--------------------------------------------------------------------------------
ItemVisualServiceRequest:
%ServiceRequest(!SCM_SEEN)
;--------------------------------------------------------------------------------
ItemGetServiceRequest:
%ServiceRequest(!SCM_GET)
;--------------------------------------------------------------------------------