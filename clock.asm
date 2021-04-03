;--------------------------------------------------------------------------------
; http://problemkaputt.de/fullsnes.htm
; 2800h-2801h  S-RTC Real Time Clock I/O Ports
; cartridge type change from #$02 to #$55 to enable S-RTC
; SNES Cart S-RTC (Realtime Clock) (1 game)
;
; PCB "SHVC-LJ3R-01" with 24pin "Sharp S-RTC" chip. Used only by one japanese game:
;   Dai Kaiju Monogatari 2 (1996) Birthday/Hudson Soft (JP)
; 
; S-RTC I/O Ports
;   002800h S-RTC Read  (R)
;   002801h S-RTC Write (W)
; Both registers are 4bits wide. When writing: Upper 4bit should be zero. When reading: Upper 4bit should be masked-off (they do possibly contain garbage, eg. open-bus).
; 
; S-RTC Communication
; The sequence for setting, and then reading the time is:
;   Send <0Eh,04h,0Dh,0Eh,00h,Timestamp(12 digits),0Dh> to [002801h]
;   If ([002800h] AND 0F)=0Fh then read <Timestamp(13 digits)>
;   If ([002800h] AND 0F)=0Fh then read <Timestamp(13 digits)>
;   If ([002800h] AND 0F)=0Fh then read <Timestamp(13 digits)>
;   If ([002800h] AND 0F)=0Fh then read <Timestamp(13 digits)>
;   etc.
; The exact meaning of the bytes is unknown. 0Eh/0Dh seems to invoke/terminate commands, 04h might be some configuration stuff (like setting 24-hour mode). 00h is apparently the set-time command. There might be further commands (such like setting interrupts, alarm, 12-hour mode, reading battery low & error flags, etc.). When reading, 0Fh seems to indicate sth like "time available".
; The 12/13-digit "SSMMHHDDMYYY(D)" Timestamps are having the following format:
;   Seconds.lo  (BCD, 0..9)
;   Seconds.hi  (BCD, 0..5)
;   Minutes.lo  (BCD, 0..9)
;   Minutes.hi  (BCD, 0..5)
;   Hours.lo    (BCD, 0..9)
;   Hours.hi    (BCD, 0..2)
;   Day.lo      (BCD, 0..9)
;   Day.hi      (BCD, 0..3)
;   Month       (HEX, 01h..0Ch)
;   Year.lo     (BCD, 0..9)
;   Year.hi     (BCD, 0..9)
;   Century     (HEX, 09h..0Ah for 19xx..20xx)
; When READING the time, there is one final extra digit (the existing software doesn't transmit that extra digit on WRITING, though maybe it's possible to do writing, too):
;   Day of Week? (0..6) (unknown if RTC assigns sth like 0=Sunday or 0=Monday)
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
macro A_x10()
	ASL #1 : PHA
	ASL #2 : !ADD 1,s
	STA 1,s : PLA
endmacro
;--------------------------------------------------------------------------------
macro A_x24()
	ASL #3 : PHA
	ASL #1 : !ADD 1,s
	STA 1,s : PLA
endmacro
;--------------------------------------------------------------------------------
macro A_x60()
	ASL #2 : PHA
	ASL #4 : !SUB 1,s
	STA 1,s : PLA
endmacro
;--------------------------------------------------------------------------------
macro Clock_ReadBCD()
	LDA $002800 : PHA
	LDA $002800 : %A_x10() : !ADD 1,s
	STA 1,s : PLA
endmacro
;--------------------------------------------------------------------------------

Clock_Test:
	JSL.l Clock_Init
	JML.l Clock_IsSupported

;--------------------------------------------------------------------------------
; Clock_Init
;--------------------------------------------------------------------------------
Clock_Init:
	LDA.b #$0E : STA $002801
	LDA.b #$04 : STA $002801
	LDA.b #$0D : STA $002801
	LDA.b #$0E : STA $002801
	LDA.b #$00 : STA $002801
	
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$01 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$01 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$00 : STA $002801
	LDA.b #$0A : STA $002801
	
	LDA.b #$0D : STA $002801
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Clock_IsSupported
;--------------------------------------------------------------------------------
; Input: None (8-bit accumulator)
;--------------------------------------------------------------------------------
; Output:
; Carry - unset if unsupported, set if supported
; Zero - Undefined
;--------------------------------------------------------------------------------
; Side Effects:
; S-RTC is ready for reading upon exit if supported
;--------------------------------------------------------------------------------
Clock_IsSupported:
	PHA : PHX
		LDX #$00;
		-
			LDA $002800 : AND.b #$0F : CMP #$0F : BEQ .done ; check for clock chip ready signal
			CPX.b #$0E : BCC ++ : CLC : BRA .done ; if we've read 14 bytes with no success, unset carry and exit
		++	INX
		BRA -
	.done
	PLX : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Clock_QuickStamp
;--------------------------------------------------------------------------------
; Input: None
;--------------------------------------------------------------------------------
; Output:
; $00.b - 24-bit timestamp (low)
; $01.b - 24-bit timestamp (mid)
; $02.b - 24-bit timestamp (high)
; $03.b - zero
; Carry - Unset if error, Set if success
; Zero - Undefined
;--------------------------------------------------------------------------------
; Side Effects:
; Requires Mode-7 Matrix Registers
;--------------------------------------------------------------------------------
Clock_QuickStamp:
	PHA : PHX : PHP
		SEP #$30 ; set 8-bit accumulator and index registers
		LDX #$00;
		-
			LDA $002800 : AND.b #$0F : CMP #$0F : BEQ .ready ; check for clock chip ready signal
			CPX.b #$0E : !BLT ++ : CLC : JMP .done : ++ ; if we've read 14 bytes with no success, unset carry and exit
			INX
		BRA -
		SEC ; indicate success
		
		.ready
		%Clock_ReadBCD() : STA $00 ; seconds
		%Clock_ReadBCD() : STA $01 ; minutes
		%Clock_ReadBCD() : STA $02 ; hours
		%Clock_ReadBCD() : STA $03 ; days
		
		REP $20 ; set 16-bit accumulator
		LDA $01 : AND #$00FF : %A_x60() ; convert minutes to seconds
		STZ $01 : !ADD $00 : STA $00 ; store running total seconds to $00

		LDA $03 : AND #$00FF : %A_x24() ; convert days to hours
		STZ $03 : !ADD $02 ; get total hours
		%A_x60() ; get total minutes
		
		LDY #$60
		JSL.l Multiply_A16Y8
		STY $02 : STZ $03
		!ADD $00 : BCC + : INC $02 : +
		
	.done
	PLP : PLX : PLA
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Multiply_A16Y8:
;--------------------------------------------------------------------------------
; Expects:
; Accumulator - 16-bit
; Index Registers - 8-bit
;--------------------------------------------------------------------------------
; Notes:
; Found a (wrong) version of this on wikibooks. This is cleaned up and fixed.
;--------------------------------------------------------------------------------
Multiply_A16Y8:
	SEP #$20 ; set 8-bit accumulator
	STY $4202
	STA $4203
	NOP #4
	LDA $4216
	LDY $4217
	XBA
	STA $4203
	NOP #2
	TYA
	CLC
	ADC $4216
	LDY $4217
	BCC .carry_bit
	INY
.carry_bit:
	XBA
	REP #$20 ; set 16-bit accumulator
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Clock_GetTime
;--------------------------------------------------------------------------------
; Input: None
;--------------------------------------------------------------------------------
; Output:
; $00.b - Seconds
; $01.b - Minutes
; $02.b - Hours
; $03.b - Days
; $04.b - Months
; $05.w - Years
; Carry - Unset if error, Set if success
; Zero - Undefined
;--------------------------------------------------------------------------------
Clock_GetTime:
	PHA : PHX : PHY : PHP
		SEP #$30 ; set 8-bit accumulator and index registers
		LDX #$00;
		-
			LDA $002800 : AND.b #$0F : CMP #$0F : BEQ .ready ; check for clock chip ready signal
			CPX.b #$0E : !BLT ++ : CLC : JMP .done : ++ ; if we've read 14 bytes with no success, unset carry and exit
			INX
		BRA -
		SEC ; indicate success
		
		.ready
		%Clock_ReadBCD() : STA $00 ; seconds
		%Clock_ReadBCD() : STA $01 ; minutes
		%Clock_ReadBCD() : STA $02 ; hours
		%Clock_ReadBCD() : STA $03 ; days
		LDA $002800 : STA $04 ; months
		%Clock_ReadBCD() : STA $05 ; years
		LDA $002800 : STA $06 ; century
		
		REP $20 ; set 16-bit accumulator
		STA $06 : AND #$00FF : %A_x10() : %A_x10() : !ADD #1000 ; multiply century digit by 100 and add 1000
		STZ $06 : !ADD $05 : STA $05 ; add lower 2 digits of the year and store
		
	.done
	PLP : PLY : PLX : PLA
RTL
;--------------------------------------------------------------------------------