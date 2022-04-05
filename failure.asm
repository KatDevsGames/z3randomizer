pushtable

table "bsodencode.txt"

; Uncomment this to force a crash to test message
;pushpc : org $008132 : db 0 : pullpc

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
	LDA.w #ZSNESMessage
	JSR DrawVWFMessage

	LDA.w #$0F0F
	STA.w $2100

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
	LDA.w #$0C38>>1
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
	LDA.w #$0C78>>1
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
	STA.b $2116

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
	STA.b $2118

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
	STA.w $2100

--	BRA --

;	LDA.w #$0000
;	TCD
;
;	TSC


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
	STA.b $06

.next
	LDA.b ($06)
	INC.b $06
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

LoadBSODHexFont:
	REP #$20

	LDA.w #BSODHex
	STA.w $4302

	LDA.w #$1801
	STA.w $4300

	LDA.w #$1000
	STA.w $4305

	LDA.w #$2800
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

	SEP #$30

	LDX.b #$FF
	LDY.b #$7F

	STZ.b $2121
	STZ.b $2122 : STZ.b $2122

	STX.b $2122 : STY.b $2122

	LDA.b #$05
	STA.b $2121

	LDA.b #$11 : STA.b $2122 : STY.b $2122

	LDA.b #$21 : STA.b $2121
	STX.b $2122 : STY.b $2122

	LDA.b #$25 : STA.b $2121
	LDA.b #$11 : STA.b $2122 : STY.b $2122

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
	STZ.w $212D

	STZ.w $210D : STZ.w $210D
	STZ.w $210E : STZ.w $210E
	STZ.w $210F : STZ.w $210F
	STZ.w $2110 : STZ.w $2110


	STZ.w $2123
	STZ.w $2131
	STZ.w $2133

	LDA.b #$04
	STA.w $2108 ; BG1 tilemap to $0800

	LDA.b #$21
	STA.w $210B

	LDA.b #$03
	STA.w $212C

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
