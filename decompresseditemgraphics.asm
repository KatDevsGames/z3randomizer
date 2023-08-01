;===================================================================================================
; Get the item's graphic from WRAM/ROM
; Bit 7 set indicates an explicit WRAM address
; Bit 7 reset indicates an offset into the ROM buffer
;===================================================================================================
;---------------------------------------------------------------------------------------------------
; Enters with A for parameter
;---------------------------------------------------------------------------------------------------
TransferItemReceiptToBuffer_using_GraphicsID:
	PHP
	PHB

	REP #$30
	PHX
	PHY

	SEP #$30
	LDX.b #$00

.find_reverse
	CMP.l ItemReceipts_graphics,X
	BEQ .found

	INX
	BNE .find_reverse

.found
	TXA
	REP #$30
	BRA ++

;===================================================================================================

TransferRupeesProperly:
	PHP
	PHB

	REP #$31
	PHX
	PHY

	AND.w #$00FF
	SBC.w #$0023

	XBA
	LSR
	LSR
	LSR
	ADC.w #BigDecompressionBuffer+$800

	BRA TransferItemReceiptToBuffer_using_ExplicitBufferAddress

;===================================================================================================

TransferItemReceiptToBuffer_using_ReceiptID:
	PHP : PHB

	REP #$30
	PHX : PHY

++	AND.w #$00FF
	ASL : TAX

        LDA.l BusyItem : BNE +
        LDA.l StandingItemGraphicsOffsets,X
        BRA .have_address
+
	LDA.l ItemReceiptGraphicsOffsets,X
.have_address
	BMI TransferItemReceiptToBuffer_using_ExplicitBufferAddress

.rom_address
	ADC.w #ItemReceiptGraphicsROM
	PHK
	BRA .continue

#TransferItemReceiptToBuffer_using_ExplicitBufferAddress:
	PEA.w $7F7F
	PLB

.continue
	PLB
	TAY
	LDX.w #62

.next_write
	LDA.w $003E,Y
	STA.l ItemGetGFX+$00,X

	LDA.w $023E,Y
	STA.l ItemGetGFX+$40,X

	DEY
	DEY
	DEX
	DEX
	BPL .next_write


	REP #$30
	PLY
	PLX
	PLB
	PLP
	RTL

;===================================================================================================

TransferItemToVRAM:
	REP #$21
	SEP #$10

	LDA.w ItemGFXPtr
	BEQ .exit
	BMI .wram_address

.rom_address
	ADC.w #ItemReceiptGraphicsROM

	LDX.b #ItemReceiptGraphicsROM>>16

.set_address
	STA.w $4302
	ADC.w #$0200
	STA.w $4312

	STX.w $4304
	STX.w $4314

	LDX.b #$80
	STX.w $2115

	LDA.w #$1801
	STA.w $4300
	STA.w $4310

	LDA.w #$0040
	STA.w $4305
	STA.w $4315

	LDA.w ItemGFXTarget
	STA.w $2116

	LDX.b #$01
	STX.w $420B

	ADC.w #$0100
	STA.w $2116

	INX
	STX.w $420B

	STZ.w ItemGFXPtr
	STZ.w ItemGFXTarget

.exit
	RTL

.wram_address
	LDX.b #$7F
	BRA .set_address

;===================================================================================================
; Decompress everything at the start of the game
;===================================================================================================
DecompBufferOffset = $18
DecompTestByte = $04
DecompCommand = $02
DecompSize = $00
DecompTileCount = $1A
DecompSaveY = $1A
Decomp3BPPScratch = $20

;===================================================================================================

DecompressAllItemGraphics:
	PHP
	PHB
	PHD

	REP #$38

	; Stack change for safety
	TSX

	LDA.w #$1400
	TCS

	PHX

	; direct page change for speed
	LDA.w #$1200
	TCD

	STZ.b DecompBufferOffset

	SEP #$34

	STA.l $4200 ; already 0 from the LDA above

	LDX.b #$5D+$73 : JSR FastSpriteDecomp
	LDX.b #$5C+$73 : JSR FastSpriteDecomp
	LDX.b #$5B+$73 : JSR FastSpriteDecomp
	LDX.b #$5A+$73 : JSR FastSpriteDecomp

	REP #$30
	PLX
	TXS

	SEP #$20

	LDA.b #$81
	STA.l $4200


	PLD
	PLB
	PLP

	RTL

;===================================================================================================
; I normally hate macros like this... but I don't feel like constantly rewriting this
;===================================================================================================
macro GetNextByte()
	LDA.w $0000,Y
	INY
	BNE ?++

	; Y pulls more than it needs, but that's fine
	; the high byte should only be affected if we somehow have FF as our bank
	; and if that happens, we have other problems
	PHB
	PLY
	INY
	PHY
	PLB

	LDY.w #$8000

?++
endmacro

;===================================================================================================
; There's no long vanilla routine, and we're going to make heavy use of this
; so might as well rewrite it to be fast
;===================================================================================================
FastSpriteDecomp:
	SEP #$30

	LDA.l $80CFC0,X : PHA : PLB ; bank
	LDA.l $80D09F,X : XBA ; high
	LDA.l $80D17E,X ; low

	REP #$10

	TAY

	LDX.w #$0000

.next_command
	%GetNextByte()

	CMP.b #$FF
	BNE .continue

;---------------------------------------------------------------------------------------------------

	JMP Unrolled3BPPConvert

;---------------------------------------------------------------------------------------------------

.continue
	CMP.b #$E0
	BCS .expanded

	STA.b DecompTestByte

	REP #$20

	AND.w #$001F

	BRA .normal

;---------------------------------------------------------------------------------------------------
; Putting some commands up here for branch distance
;---------------------------------------------------------------------------------------------------
.nonrepeating
	REP #$21
	TYA
	ADC.b DecompSize
	ORA.w #$8000
	STA.b DecompSize

	SEP #$20

.next_nonrepeating
	%GetNextByte()

	STA.l DecompBuffer2,X

	INX

	CPY.b DecompSize
	BNE .next_nonrepeating

	BRA .next_command

;---------------------------------------------------------------------------------------------------

.repeating
	%GetNextByte()

	STY.b DecompSaveY

	LDY.b DecompSize

.next_repeating
	STA.l DecompBuffer2,X

	INX
	DEY
	BNE .next_repeating

	LDY.b DecompSaveY
	BRA .next_command

;---------------------------------------------------------------------------------------------------
; Rest of command handling
;---------------------------------------------------------------------------------------------------
.expanded
	STA.b DecompCommand

	ASL
	ASL
	ASL
	STA.b DecompTestByte

	LDA.b DecompCommand
	AND.b #$03
	XBA

	%GetNextByte()

	REP #$20

;---------------------------------------------------------------------------------------------------

.normal
	INC
	STA.b DecompSize

	SEP #$20

	LDA.b DecompTestByte

	AND.b #$E0
	BEQ .nonrepeating
	BMI .copy

	ASL
	BPL .repeating

	ASL
	BPL .repeating_word

;---------------------------------------------------------------------------------------------------

.incremental
	%GetNextByte()

	STY.b DecompSaveY

	LDY.b DecompSize

.next_incremental
	STA.l DecompBuffer2,X

	INC
	INX

	DEY
	BNE .next_incremental

	LDY.b DecompSaveY
	JMP .next_command

;---------------------------------------------------------------------------------------------------

.repeating_word
	JSR .get_next_word
	REP #$20

	STY.b DecompSaveY

	LDY.b DecompSize
	DEY

.next_word
	STA.l DecompBuffer2,X

	INX
	INX

	DEY
	DEY
	BPL .next_word

	INY
	BEQ .not_too_far

	DEX

.not_too_far
	SEP #$20

	LDY.b DecompSaveY

	JMP .next_command

;---------------------------------------------------------------------------------------------------

.copy
	JSR .get_next_word

	STY.b DecompSaveY

	TAY

	LDA.b DecompSize
	BNE ++

	DEC.b DecompSize+1

++	PHB
	LDA.b #$7F
	PHA
	PLB

.next_copy
	LDA.w DecompBuffer2,Y
	STA.w DecompBuffer2,X

	INX
	INY

	DEC.b DecompSize+0
	BNE .next_copy

	DEC.b DecompSize+1
	BPL .next_copy

	PLB

	LDY.b DecompSaveY

	JMP .next_command

;---------------------------------------------------------------------------------------------------
; These are only used once per command, so I'm fine with letting them be a JSR I guess
;---------------------------------------------------------------------------------------------------
.get_next_word
	%GetNextByte()
	XBA

	%GetNextByte()
	XBA

	RTS

;===================================================================================================
; More macros, because lazy
;===================================================================================================

macro DoPlanesA(offset)
	LDA.w DecompBuffer2+<offset>+<offset>,Y
	STA.w BigDecompressionBuffer+<offset>+<offset>,X

	ORA.w DecompBuffer2+<offset>+<offset>-1,Y
	AND.w #$FF00
	STA.b Decomp3BPPScratch

	LDA.w DecompBuffer2+$10+<offset>,Y
	AND.w #$00FF
	TSB.b Decomp3BPPScratch

	XBA
	ORA.b Decomp3BPPScratch
	STA.w BigDecompressionBuffer+$10+<offset>+<offset>,X

endmacro

;===================================================================================================

Unrolled3BPPConvert:
	LDA.b #$7F
	PHA
	PLB

	REP #$21

	LDY.w #$0000
	LDX.b DecompBufferOffset

.next_3bpp_tile
	%DoPlanesA(0) ; 8 times
	%DoPlanesA(1)
	%DoPlanesA(2)
	%DoPlanesA(3)
	%DoPlanesA(4)
	%DoPlanesA(5)
	%DoPlanesA(6)
	%DoPlanesA(7)

	; carry will always be clear
	; don't worry
	TXA
	ADC.w #32
	TAX

	; just trust me
	TYA
	ADC.w #24
	TAY

	CMP.w #24*64
	BCS .done

	JMP .next_3bpp_tile

.done
	STX.b DecompBufferOffset
	SEP #$30

	RTS

;===================================================================================================


