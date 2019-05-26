;================================================================================
; Service Request Support Code
;--------------------------------------------------------------------------------
; $7F5300 - $7F53FF - Multiworld Block
;	$00 - $1F - RX Buffer
;	$20 - $7E - Reserved
;		  $7F - RX Status
;	$80 - $9F - TX Buffer
;	$A0 - $FE - Reserved
;		  $FF - TX Status
!RX_BUFFER = "$7F5300"
!RX_STATUS = "$7F537F"
!RX_SEQUENCE = "$7EF4A0"
!TX_BUFFER = "$7F5380"
!TX_STATUS = "$7F53FF"
!TX_SEQUENCE = "$7EF4A0"
PollService:
	LDA !RX_BASE : BNE + : RTL : + ; return if command is 0
	LDA #$01 : STA !RX_STATUS ; mark busy
	LDA !RX_BASE+1 : STA !RX_SEQUENCE ; mark this as handled
	LDA !RX_BASE+2 : STA !RX_SEQUENCE+1
	LDA #$00 : STA !RX_STATUS ; mark ready
RTL