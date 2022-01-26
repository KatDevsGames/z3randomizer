pushtable

table "bsodencode.txt"

; Uncomment this to force a crash to test message
;pushpc
;	org $8132 : db 0
;pullpc

;===================================================================================================

DontUseZSNES:
	SEP #$35 ; sets carry and I flag too

	LDA.b #$00
	STA.l $4200 ; disable NMI and IRQ
	STA.l $420C ; disable HDMA

	ROR ; A = 0x80 from carry
	STA.l $2100
	STA.l $2115

	; Empty VRAM
	LDA.b #AllZeros>>16 : STA.l $4304

	REP #$20

	LDA.w #AllZeros
	STA.l $4302

	LDA.w #$1809
	STA.l $4300

	LDA.w #$0000
	STA.l $4305

	LDA.w #$0001
	STA.l $420B

	JSR ConfigurePPUForFailureReport
	JSR ConfigureBSODVWF

	STZ.b VWFR
	LDA.w #ZSNESMessage_line1 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line2 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line3 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line4 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line5 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line6 : JSR DrawVWFLine
	LDA.w #ZSNESMessage_line7 : JSR DrawVWFLine

	LDA.w #$0F0F
	STA.w $2100

--	BRA --

ZSNESMessage:
.line1
	db "It has been detected that you are attempting to load", $FF

.line2
	db "this ROM on a low-quality emulator.", $FF

.line3
	db "The randomizer is designed to work on real hardware,", $FF

.line4
	db "which this application cannot emulate properly;", $FF

.line5
	db "as such, this ROM file refuses to boot.", $FF

.line6
	db "Please upgrade to a more accurate emulator such as", $FF

.line7
	db "SNES9X or BSNES/higan.", $FF

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
	STA.l $4200 ; disable NMI and IRQ
	STA.l $420C ; disable HDMA

	ROR ; A = 0x80 from carry
	STA.l $2100
	STA.l $2115

	; Empty VRAM
	LDA.b #AllZeros>>16 : STA.l $4304

	REP #$38

	LDA.w #AllZeros
	STA.l $4302

	LDA.w #$1809
	STA.l $4300

	LDA.w #$0000
	STA.l $4305

	LDA.w #$0001
	STA.l $420B

;===================================================================================================

	; Create report
	LDA.w #$2100
	TCD

;---------------------------------------------------------------------------------------------------

	; Report status

	; stack pointer
	LDA.w #$0438>>1
	STA.b $2116

	TSC
	XBA
	AND.w #$00FF
	ORA.w #$0100
	STA.b $2118

	TSC
	AND.w #$00FF
	ORA.w #$0100
	STA.l $2118

	; game module
	LDA.w #$0478>>1
	STA.b $2116

	LDA.l $10
	AND.w #$00FF
	ORA.w #$0100
	STA.b $2118

	LDA.l $11
	AND.w #$00FF
	ORA.w #$0100
	STA.b $2118

;---------------------------------------------------------------------------------------------------

	; Report stack
	TSC
	INC
	STA.l $7F0100

	; For now, we can report as much of the stack as possible
	; If desired later on, uncomment the code below to keep the stack limited to
	; where it was last doing stuff
	LDA.l UselessStackTooFar ; also comment out this line when doing the above

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

	LDA.w #$0404>>1

.next_row
	STA.l $7F0002
	STA.l $7F0004

	LDY.w #20

.next_char
	STA.b $2116

	TXA
	CMP.l $7F0100

	LDA.l $000000,X
	AND.w #$00FF
	ORA.w #$0500
	BCS ++

	AND.w #$01FF

++	STA.b $2118

	DEX
	TXA
	CMP.l $7F0000
	BEQ .skip_stack

	DEY
	BEQ .done_row

	LDA.l $7F0002
	INC
	STA.l $7F0002

	BRA .next_char

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

	JSR ConfigurePPUForFailureReport
	JSR ConfigureBSODVWF
	JSR LoadBSODFont

	STZ.b VWFR

	LDA.w #BSODMessage_line1 : JSR DrawVWFLine
	LDA.w #BSODMessage_line2 : JSR DrawVWFLine
	LDA.w #BSODMessage_line3 : JSR DrawVWFLine
	LDA.w #BSODMessage_line4 : JSR DrawVWFLine
	LDA.w #BSODMessage_line5 : JSR DrawVWFLine
	LDA.w #BSODMessage_line6 : JSR DrawVWFLine
	LDA.w #BSODMessage_line7 : JSR DrawVWFLine

	LDA.w #$0F0F
	STA.w $2100

--	BRA --
;	LDA.w #$0000
;	TCD
;
;	TSC


BSODMessage:
.line1
	db "A fatal error has occurred and resulted in an", $FF

.line2
	db "unrecoverable crash. ?", $FF

.line3
	db "If you believe this is the result of a bug caused by", $FF

.line4
	db "the randomizer itself, please screenshot this message", $FF

.line5
	db "and share it in the #bug-reports channel of the official", $FF

.line6
	db "ALTTPR discord along with a detailed description of", $FF

.line7
	db "what you were doing, including video if available.", $FF

;===================================================================================================

DrawVWFLine:
	STA.b $06

.next
	LDA.b ($06)
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .done_row

	JSR DrawFailureVWFChar

	INC.b $06
	BRA .next

.done_row
	LDA.b VWFR
	ASL
	TAX
	LDA.w .row_offset,X
	STA.w $2116

	INC.b VWFR

	LDA.w #$1800
	STA.w $4300
	
	LDA.w #20*16
	STA.w $4305

	LDA.w #$1000
	STA.w $4302

	SEP #$20

	STZ.w $2115
	STZ.w $4304

	LDA.b #$01
	STA.w $420B

	REP #$20

	JMP ResetVFW

.row_offset
	dw $10F8
	dw $11E8
	dw $12D8
	dw $13C8
	dw $14B8
	dw $15A8
	dw $1698
	dw $1788



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
	STA.b $08

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

LoadBSODFont:
	REP #$20

	LDA.w #BSODHex
	STA.w $4302

	LDA.w #$1801
	STA.w $4300

	LDA.w #$1000
	STA.w $4305

	LDA.w #$1800
	STA.w $2116

	SEP #$20
	LDA.b #BSODHex>>16
	STA.w $4304

	LDA.b #$01
	STA.w $420B

	REP #$30

	RTS

;===================================================================================================

ConfigureBSODVWF:
	REP #$30

	LDA.w #$2100
	TCD

	SEP #$20
	STZ.b $2121

	STZ.b $2122
	STZ.b $2122

	LDA.b #$FF
	STA.b $2122
	LDA.b #$7F
	STA.b $2122

	STZ.b $2122
	STZ.b $2122

	STZ.b $2122
	STZ.b $2122

	STZ.b $2122
	STZ.b $2122

	LDA.b #$11
	STA.b $2122
	LDA.b #$7F
	STA.b $2122

	REP #$20

	PEA.w $0001

	LDA.w #8
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
	STA.b $2116

	PLA

	LDY.w #30

.next_char
	STA.b $2118
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

	STZ.w $2105 ; BG mode 0
	STZ.w $2106 ; no mosaic
	STZ.w $2107 ; BG1 tilemap to $0000
	STZ.w $210D
	STZ.w $210D
	STZ.w $210E
	STZ.w $210E
	STZ.w $2123
	STZ.w $2131
	STZ.w $2133

	LDA.b #$01
	STA.w $210B
	STA.w $212C
	STA.w $212D

	RTS

;===================================================================================================

BSODHex:
incbin "bsodhex.2bpp"

BSODFontGFX:
incbin "bsodfont.1bpp"

BSODCharWidths:
	; [space]
	db 3

	;  A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
	db 4, 4, 3, 4, 3, 3, 4, 3, 1, 4, 3, 3, 5, 4, 4, 4, 5, 4, 4, 3, 4, 5, 5, 3, 3, 3

	;  0  1  2  3  4  5  6  7  8  9  .  #  ?  -  /  ,  '
	db 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 5, 8, 3, 3, 2, 1

;===================================================================================================

pulltable
