;================================================================================
; Service Request Support Code
;--------------------------------------------------------------------------------
; $7F5300 - $7F53FF - Multiworld Block
;	$00 - $5F - RX Buffer
;	$60 - $7E - Reserved
;		  $7F - RX Status
;	$80 - $EF - TX Buffer
;	$F0 - $FE - Reserved
;		  $FF - TX Status
;--------------------------------------------------------------------------------
; Status Codes
; $00 - Idle
; $01 - Ready to Read
; $FF - Busy
;--------------------------------------------------------------------------------
; Service Indexes
; 0x00 - 0x04 - chests
; 0xF0 - freestanding heart / powder / mushroom / bonkable
; 0xF1 - freestanding heart 2 / boss heart / npc
; 0xF2 - tablet/pedestal
;--------------------------------------------------------------------------------
; Block Commands
!SCM_WAIT = $00

!SCM_SEEN = $01
!SCM_SHOW = $02
!SCM_GET = $03
!SCM_GIVE = $04
!SCM_PROMPT = $05

!SCM_AREACHG = $10
!SCM_DUNGEON = $11
!SCM_DEATH = $12
!SCM_SAVEQUIT = $13
!SCM_FCREATE = $14
!SCM_FLOAD = $15
!SCM_FCDELETE = $16
!SCM_SPAWN = $17
!SCM_PAUSE = $18

!SCM_STALL = $70
!SCM_RESUME = $71

!SCM_VERSION = $80
;--------------------------------------------------------------------------------
macro ServiceRequestVersion()
	LDA.l TxStatus : BEQ + : CLC : RTL : + ; return fail if we don't have the lock
		LDA.b #$01 : STA.l TxBuffer+8 ; version
		LDA.b #$00 : STA.l TxBuffer+9
					STA.l TxBuffer+10
					STA.l TxBuffer+11
		LDA.b #!SCM_VERSION : STA.l TxBuffer
	LDA.b #$01 : STA.l TxStatus ; mark ready for reading
	SEC ; mark request as successful
RTL
endmacro
;--------------------------------------------------------------------------------
macro ServiceRequestChest(type)
	LDA.l TxStatus : BEQ + : CLC : RTL : + ; return fail if we don't have the lock
		LDA.b IndoorsFlag : STA.l TxBuffer+8 ; indoor/outdoor
		BEQ +
			LDA.b RoomIndex : STA.l TxBuffer+9 ; roomid low
			LDA.b RoomIndex+1 : STA.l TxBuffer+10 ; roomid high
			BRA ++
		+
			LDA.b OverworldIndex : STA.l TxBuffer+9 ; area id
			LDA.b #$00 : STA.l TxBuffer+10 ; protocol defines this as a ushort
		++
		LDA.b $76 : !SUB #$58 : STA.l TxBuffer+11 ; object index (type 2 only)
		LDA.b #<type> : STA.l TxBuffer ; item get
	LDA.b #$01 : STA.l TxStatus ; mark ready for reading
	SEC ; mark request as successful
RTL
endmacro
;--------------------------------------------------------------------------------
macro ServiceRequest(type,index)
	LDA.l TxStatus : BEQ + : CLC : RTL : + ; return fail if we don't have the lock
		LDA.b IndoorsFlag : STA.l TxBuffer+8 ; indoor/outdoor
		BEQ +
			LDA.b RoomIndex : STA.l TxBuffer+9 ; roomid low
			LDA.b RoomIndex+1 : STA.l TxBuffer+10 ; roomid high
			BRA ++
		+
			LDA.b OverworldIndex : STA.l TxBuffer+9 ; area id
			LDA.b #$00 : STA.l TxBuffer+10 ; protocol defines this as a ushort
		++
		LDA.b #<index> : STA.l TxBuffer+11 ; object index (type 2 only)
		LDA.b #<type> : STA.l TxBuffer ; item get
	LDA.b #$01 : STA.l TxStatus ; mark ready for reading
	SEC ; mark request as successful
RTL
endmacro
;--------------------------------------------------------------------------------
PollService:
	PHP
	SEP #$20 ; set 8-bit accumulator
	LDA.l RxStatus : DEC : BEQ + : PLP : CLC : RTL : + ; return fail if there's nothing to read
		LDA.b #$FF : STA.l RxStatus ; stop calls from recursing in
		LDA.l RxBuffer : CMP.b #!SCM_GIVE : BNE + ; give item
			PHY : LDA.l RxBuffer+8 : TAY
			LDA.l RxBuffer+9 : BNE ++
				JSL.l Link_ReceiveItem ; do something else
				PLY : BRA .done
			++
				JSL.l Link_ReceiveItem
				PLY : BRA .done
		+ : CMP.b #!SCM_SHOW : BNE + ; show item
			; you could check here if you're on the right screen, etc
			LDA.l RxBuffer+12 : JSL.l PrepDynamicTile ; we could properly process the whole message but we're not going to
			BRA .done
		+ : CMP.b #!SCM_PROMPT : BNE + ; item prompt
			LDA.l RxBuffer+8 : TAX
			LDA.l RxBuffer+9 : STA.w SFX2, X ; set sound effect
			REP #$30 ; set 16-bit accumulator and index registers
				LDA.l RxBuffer+10 : TAX
				LDA.l RxBuffer+12
				JSL.l DoToast
			SEP #$30 ; set 8-bit accumulator and index registers
		+ : CMP.b #!SCM_VERSION : BNE + ; version
			%ServiceRequestVersion()
		+
	.done
	LDA.l #$00 : STA.l RxStatus ; release lock
	PLP
	SEC ; mark request as successful
RTL
;--------------------------------------------------------------------------------
ItemVisualServiceRequest_F0:
%ServiceRequest(!SCM_SEEN, $F0)
;--------------------------------------------------------------------------------
ItemVisualServiceRequest_F1:
%ServiceRequest(!SCM_SEEN, $F1)
;--------------------------------------------------------------------------------
ItemVisualServiceRequest_F2:
%ServiceRequest(!SCM_SEEN, $F2)
;--------------------------------------------------------------------------------
ChestItemServiceRequest:
%ServiceRequestChest(!SCM_GET)
;--------------------------------------------------------------------------------
ItemGetServiceRequest_F0:
%ServiceRequest(!SCM_GET, $F0)
;--------------------------------------------------------------------------------
ItemGetServiceRequest_F1:
%ServiceRequest(!SCM_GET, $F1)
;--------------------------------------------------------------------------------
ItemGetServiceRequest_F2:
%ServiceRequest(!SCM_GET, $F2)
;--------------------------------------------------------------------------------
