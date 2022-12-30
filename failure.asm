CheckZSNES:
	SEP #$28
	LDA.b #$FF
	CLC
	ADC.b #$FF
	CMP.b #$64
	REP #$28
	BEQ .zsnes
	LDA.w #$01FF : TCS ; thing we wrote over - initialize stack
	JML ReturnCheckZSNES
.zsnes
	JML DontUseZSNES

;===================================================================================================

pushtable

table "data/bsodencode.txt"

; Uncomment this to force a crash to test message
; pushpc : org $008132 : db 0 : pullpc

;===================================================================================================

DontUseZSNES:
	SEP #$35 ; sets carry and I flag too

	LDA.b #$00
	STA.l NMITIMEN ; disable NMI and IRQ
	STA.l HDMAEN ; disable HDMA

	ROR ; A = 0x80 from carry
	STA.l INIDISP
	STA.l VMAIN

	; Empty VRAM
	LDA.b #AllZeros>>16 : STA.l A1B0

	REP #$20

	LDA.w #AllZeros
	STA.l A1T0L

	LDA.w #$1809
	STA.l DMAP0

	LDA.w #$0000
	STA.l DAS0L

	LDA.w #$0001
	STA.l MDMAEN

	JSR ConfigurePPUForFailureReport
	JSR ConfigureBSODVWF

	STZ.b VWFR
	LDA.w #ZSNESMessage
	JSR DrawVWFMessage

	LDA.w #$0F0F
	STA.w INIDISP

--	BRA --

ZSNESMessage:
	db "It has been detected that you are attempting to load", $80
	db "this ROM on a low-quality emulator.", $80
	db "The randomizer is designed to work on real hardware,", $80
	db "which this application cannot emulate properly;", $80
	db "as such, this ROM file refuses to boot.", $80
	db "Please upgrade to a more accurate emulator such as", $80
	db "SNES9X or BSNES/higan.", $80
	db $FF

;===================================================================================================

AllZeros:
	db $00

UselessStackTooFar:
	dw $137

Crashed:
;===================================================================================================
;===================================================================================================
;===================================================================================================
; !!!DO NOT TRY TO OPTIMIZE THIS CODE!!!
; IT IS INTENTIONALLY AVOIDING CHANGING CERTAIN REGISTERS, ESPECIALLY THE STACK.
;===================================================================================================
;===================================================================================================
;===================================================================================================
	SEP #$35 ; sets carry and I flag too

	LDA.b #$00
	STA.l NMITIMEN ; disable NMI and IRQ
	STA.l HDMAEN ; disable HDMA

	ROR ; A = 0x80 from carry
	STA.l INIDISP
	STA.l VMAIN

	; Empty VRAM
	LDA.b #AllZeros>>16 : STA.l A1B0

	REP #$38

	LDA.w #AllZeros
	STA.l A1T0L

	LDA.w #$1809
	STA.l DMAP0

	LDA.w #$0000
	STA.l DAS0L

	LDA.w #$0001
	STA.l MDMAEN

;===================================================================================================

	; Create report
	LDA.w #$2100
	TCD

;---------------------------------------------------------------------------------------------------

	; Report status

	; stack pointer
	LDA.w #$0C38>>1
	STA.b VMADDL

	TSC
	XBA
	AND.w #$00FF
	ORA.w #$0100
	STA.b VMDATAL

	TSC
	AND.w #$00FF
	ORA.w #$0100
	STA.l VMDATAL

	; game module
	LDA.w #$0C78>>1
	STA.b VMADDL

	LDA.l GameMode
	AND.w #$00FF
	ORA.w #$0100
	STA.b VMDATAL

	LDA.l GameSubMode
	AND.w #$00FF
	ORA.w #$0100
	STA.b VMDATAL

;---------------------------------------------------------------------------------------------------

	; Report stack
	TSC
	INC
	STA.l $7F0100

	LDA.l UselessStackTooFar

	; For now, we can report as much of the stack as possible
	; If desired later on, uncomment the code below to keep the stack limited to
	; where it was last doing stuff
;	TSC
;
;	; keep stack in a useful range
;	CMP.w #$01FF ; this means we pulled too much and the stack is useless
;	BCC .stack_fine
;
;	JMP .skip_stack
;
;.stack_fine
;	CMP.l UselessStackTooFar
;	BCS .stack_adjusted
;
;	; this means we went too far in, and the stack contains little useful info
;	LDA.l UselessStackTooFar
;
;.stack_adjusted
	STA.l $7F0000

	LDX.w #$01FF

	LDA.w #$0C04>>1

.next_row
	STA.l $7F0004
	STA.b VMADDL

	LDY.w #20

	TXA

.next_char
	; set carry to see if we should color this value as being in the stack
	CMP.l $7F0100

	LDA.l $000000,X
	AND.w #$00FF
	ORA.w #$0500
	BCS .in_stack

	AND.w #$01FF

.in_stack
	STA.b VMDATAL

	DEX
	TXA
	CMP.l $7F0000
	BEQ .skip_stack

	DEY
	BNE .next_char

.done_row
	CLC

	LDA.l $7F0004
	ADC.w #32
	BRA .next_row

;===================================================================================================
;===================================================================================================
;===================================================================================================
	; once the stack is reported, we can start doing stuff that mucks with it
.skip_stack
	LDA.w #$0000
	TCD

;	TSC
;	STA.b $80 ; remember stack for later messages

	LDA.w #$01FF
	TCS

	JSR ConfigurePPUForFailureReport
	JSR ConfigureBSODVWF
	JSR LoadBSODHexFont

	STZ.b VWFR

	LDA.w #BSODMessage
	JSR DrawVWFMessage

	LDA.w #$0F0F
	STA.w INIDISP

--	BRA --

BSODMessage:
	db "A fatal error has occurred and resulted in an", $80
	db "unrecoverable crash. ?", $80
	db "If you believe this was the result of a bug caused by", $80
	db "the randomizer itself, please screenshot this message", $80
	db "and share it in the #bug-reports channel of the official", $80
	db "ALTTPR discord along with a detailed description of", $80
	db "what you were doing, including video if available.", $80
	db "Please also make a savestate now and include that in", $80
	db "your report.", $80
	db $FF

;===================================================================================================

DrawVWFMessage:
	STA.b Scrap06

.next
	LDA.b (Scrap06)
	INC.b Scrap06
	AND.w #$00FF
	CMP.w #$0080
	BEQ .done_row

	CMP.w #$00FF
	BEQ .done_message

	JSR DrawFailureVWFChar

	BRA .next

.done_message
	RTS

.done_row
	LDA.b VWFR
	ASL
	TAX
	LDA.w .row_offset,X
	STA.w VMADDL

	INC.b VWFR

	LDA.w #$1800
	STA.w DMAP0
	
	LDA.w #20*16
	STA.w DAS0L

	LDA.w #$1000
	STA.w A1T0L

	SEP #$20

	STZ.w VMAIN
	STZ.w A1B0

	LDA.b #$01
	STA.w MDMAEN

	REP #$20

	JSR ResetVFW

	BRA .next


.row_offset
	dw $10F8
	dw $11E8
	dw $12D8
	dw $13C8
	dw $14B8
	dw $15A8
	dw $1698
	dw $1788
	dw $1878
	dw $1968
	dw $1A58



;===================================================================================================

VWFL = $40
VWFX = $44
VWFS = $46
VWFP = $48
VWFR = $4A

;===================================================================================================

DrawFailureVWFChar:
	AND.w #$00FF
	STA.b VWFL

	TAX

	ASL
	ASL
	ASL
	ADC.w #BSODFontGFX
	STA.b Scrap08

	LDA.b VWFP
	AND.w #$FFF8
	STA.w VWFX

	LDA.b VWFP
	AND.w #$0007
	STA.w VWFS

	; carry set on purpose to add letter spacing
	SEC
	LDA.w BSODCharWidths,X
	AND.w #$00FF
	ADC.b VWFP
	STA.b VWFP

	LDY.w #$0000

.next_row
	LDA.b ($08),Y
	AND.w #$00FF
	XBA
	LDX.w VWFS
	BEQ ++

--	LSR
	DEX
	BNE --

++	LDX.w VWFX
	SEP #$20
	ORA.w $1008,X
	STA.w $1008,X

	XBA
	ORA.w $1000,X
	STA.w $1000,X

	REP #$20
	INX
	STX.w VWFX

	INY
	CPY.w #$0008
	BCC .next_row

	RTS

;===================================================================================================

LoadBSODHexFont:
	REP #$20

	LDA.w #BSODHex
	STA.w A1T0L

	LDA.w #$1801
	STA.w DMAP0

	LDA.w #$1000
	STA.w DAS0L

	LDA.w #$2800
	STA.w VMADDL

	SEP #$20
	LDA.b #BSODHex>>16
	STA.w A1B0

	LDA.b #$01
	STA.w MDMAEN

	REP #$30

	RTS

;===================================================================================================

ConfigureBSODVWF:
	REP #$30

	LDA.w #$2100
	TCD

	SEP #$30

	LDX.b #$FF
	LDY.b #$7F

	STZ.b CGADD
	STZ.b CGDATA : STZ.b CGDATA

	STX.b CGDATA : STY.b CGDATA

	LDA.b #$05
	STA.b CGADD

	LDA.b #$11 : STA.b CGDATA : STY.b CGDATA

	LDA.b #$21 : STA.b CGADD
	STX.b CGDATA : STY.b CGDATA

	LDA.b #$25 : STA.b CGADD
	LDA.b #$11 : STA.b CGDATA : STY.b CGDATA

	REP #$30

	PEA.w $0001

	LDA.w #15
	STA.w $28

	LDA.w #$0042>>1
	BRA .start

.next_row
	PHA

	LDA.w $20
	CLC
	LDA.w $20
	ADC.w #32

.start
	STA.w $20
	STA.b VMADDL

	PLA

	LDY.w #30

.next_char
	STA.b VMDATAL
	INC
	DEY
	BNE .next_char

	DEC.w $28
	BNE .next_row

	LDA.w #$0000
	TCD

ResetVFW:
	REP #$30

	LDX.w #$0400

--	STZ.w $1000,X
	DEX
	DEX
	BPL --

	STZ.b VWFL
	STZ.b VWFX
	STZ.b VWFS
	STZ.b VWFP

	RTS

;===================================================================================================

ConfigurePPUForFailureReport:
	SEP #$30

	PHK
	PLB

	STZ.w BGMODE ; BG mode 0
	STZ.w MOSAIC ; no mosaic
	STZ.w BG1SC ; BG1 tilemap to $0000
	STZ.w TS

	STZ.w BG1HOFS : STZ.w BG1HOFS
	STZ.w BG1VOFS : STZ.w BG1VOFS
	STZ.w BG2HOFS : STZ.w BG2HOFS
	STZ.w BG2VOFS : STZ.w BG2VOFS


	STZ.w W12SEL
	STZ.w CGADSUB
	STZ.w SETINI

	LDA.b #$04
	STA.w BG2SC ; BG1 tilemap to $0800

	LDA.b #$21
	STA.w BG12NBA

	LDA.b #$03
	STA.w TM

	RTS

;===================================================================================================

BSODHex:
incbin "data/bsodhex.2bpp"

BSODFontGFX:
incbin "data/bsodfont.1bpp"

BSODCharWidths:
	; [space]
	db 3

	;  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
	db 4, 4, 3, 4, 3, 3, 4, 3, 1, 4, 3, 3, 5, 4, 4, 4, 5, 4, 4, 3, 4, 5, 5, 3, 3, 3

	;  0  1  2  3  4  5  6  7  8  9  .  #  ?  -  /  ,  '
	db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 5, 8, 3, 3, 2, 1

;===================================================================================================

pulltable
