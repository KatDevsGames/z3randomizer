!PASSWORD_CODE_POSITION = "$C8"
!PASSWORD_SELECTION_POSITION = "$C9"
!PASSWORD_SRAM = "$700510"


Module_Password:
	LDA $11

	JSL.l UseImplicitRegIndexedLongJumpTable

	dl Password_BeginInit ; 0
	dl Password_EndInit ; 1
	dl Password_Main ; 2
	dl Password_Check ; 3
	dl Password_Return ; 4

Password_BeginInit:
	LDA.b #$80 : STA $0710 ;skip animated sprite updates in NMI

	JSL EnableForceBlank
	JSL Vram_EraseTilemaps_triforce
	;JSL Palette_SelectScreen

	JSL LoadCustomHudPalette ; replace the 2bpp palettes, and trigger upload
	LDA.b #$07 : STA $14 ; have NMI load up the initial tilemap from Password_Tilemap

	INC $11
RTL

Password_EndInit:
	JSR LoadPasswordStripeTemplate

	;reset the variables used by this screen
	STZ !PASSWORD_CODE_POSITION
	STZ !PASSWORD_SELECTION_POSITION

	JSL ValidatePassword : BNE +
		; zero out password if not valid
		LDX.b #$0F
		LDA.b #$00
		-
			STA.l !PASSWORD_SRAM, X
		DEX : BPL -
	+

	LDA.b #$0F : STA $13
	INC $11
RTL

Password_Main:
	PHB
	PHK : PLB

    JSR PasswordEraseOldCursors

	; handle joypad input
	LDA $F6 : AND.b #$10 : BEQ + ; R Button
		JSR PasswordMoveCursorRight
	+
	LDA $F6 : AND.b #$20 : BEQ + ; L Button
		JSR PasswordMoveCursorLeft
	+
	LDA $F4 : AND.b #$01 : BEQ + ; right
		LDA !PASSWORD_SELECTION_POSITION : INC A : CMP.b #$24 : !BLT ++
			!SUB.b #$24
		++
		STA !PASSWORD_SELECTION_POSITION
		LDA.b #$20 : STA $012F
	+
	LDA $F4 : AND.b #$02 : BEQ + ; left
		LDA !PASSWORD_SELECTION_POSITION : DEC A : BPL ++
			!ADD.b #$24
		++
		STA !PASSWORD_SELECTION_POSITION
		LDA.b #$20 : STA $012F
	+
	LDA $F4 : AND.b #$04 : BEQ + ; down
		LDA !PASSWORD_SELECTION_POSITION : !ADD.b #$09 : CMP.b #$24 : !BLT ++
			!SUB.b #$24
		++
		STA !PASSWORD_SELECTION_POSITION
		LDA.b #$20 : STA $012F
	+
	LDA $F4 : AND.b #$08 : BEQ + ; up
		LDA !PASSWORD_SELECTION_POSITION : !SUB.b #$09 :  BPL ++
			!ADD.b #$24
		++
		STA !PASSWORD_SELECTION_POSITION
		LDA.b #$20 : STA $012F
	+
	LDA $F4 : ORA $F6 : AND.b #$C0 : BEQ + ; face button
		LDX !PASSWORD_SELECTION_POSITION
		LDA .selectionValues, X : BPL ++
			CMP #$F0 :  BNE +++
				INC $11
				BRA .endOfButtonChecks
			+++ : CMP #$F1 :  BNE +++
				JSR PasswordMoveCursorLeft
				BRA +
			+++ : CMP #$F2 :  BNE +++
				JSR PasswordMoveCursorRight
				BRA +
			+++ : CMP #$F3 :  BNE +++
				INC $11 : INC $11 ; skip to return submodule
				LDA.b #$2C : STA $012E ;file screen selection sound
				BRA .endOfButtonChecks
			+++
			BRA +
		++
		LDX !PASSWORD_CODE_POSITION
		STA !PASSWORD_SRAM,X
		TXA : INC A : AND.b #$0F : STA !PASSWORD_CODE_POSITION
		BNE ++
			STZ $012E
			INC $11
			BRA .endOfButtonChecks
		++
		LDA.b #$2B : STA $012E
	+
	LDA $F4 : AND.b #$10 : BEQ + ; start
		INC $11
	+
	.endOfButtonChecks

	JSR UpdatePasswordTiles

	JSR PasswordSetNewCursors
	LDA.b #$01 : STA $14
	PLB
RTL
.selectionValues
db $01, $02, $03, $04, $05, $06, $07, $08, $F0
db $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $F1
db $11, $12, $13, $14, $15, $16, $17, $18, $F2
db $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $F3

Password_Check:
	JSL.l ValidatePassword : BNE .correct
	LDA.b #$3C : STA $012E ; error
	DEC $11
RTL
	.correct
	LDA.b #$1B : STA $012F ; solved puzzle sound
	INC $11
RTL

Password_Return:
	LDA.b #$01 : STA $10 ; select screen
	LDA.b #$01 : STA $11 ; Skip the first submodule
	STZ $B0
	STZ $0B9D ; Reset file screen cursor pre-selection
	STZ $C8
	STZ $C9
RTL

;--------------------------------------------------------------------------------
; Exported Function
;--------------------------------------------------------------------------------

ValidatePassword:
	; returns 1/Not Z for correct, 0/Z for incorrect
	; REQUIRES: 8 bit both
	; has a deliberate side effect of key being loaded into RAM if password is correct.
	PHX : PHY

	;check for incomplete password
	LDX #$0F
	-
		LDA.l !PASSWORD_SRAM, X : BNE +
		 	BRL .incorrect
		+
	DEX : BPL -

	REP #$20 ; 16 bit Accumulator

	; Clear out any existing encryption key
	LDX.b #$0E
	LDA.w #$0000
	- :	STA.l !keyBase, X : DEX #2 : BPL -

	JSR PasswordToKey


	LDA.l StaticDecryptionKey+$0A : STA.l !keyBase+$0A
	LDA.l StaticDecryptionKey+$0C : STA.l !keyBase+$0C
	LDA.l StaticDecryptionKey+$0E : STA.l !keyBase+$0E

	LDA.l KnownEncryptedValue   : STA.l !CryptoBuffer
	LDA.l KnownEncryptedValue+2 : STA.l !CryptoBuffer+2
	LDA.l KnownEncryptedValue+4 : STA.l !CryptoBuffer+4
	LDA.l KnownEncryptedValue+6 : STA.l !CryptoBuffer+6

	LDA.w #$0002 : STA $04 ;set block size

	JSL.l XXTEA_Decode

	SEP #$20 ; 8 bit accumulator

	LDA !CryptoBuffer+0 : CMP #$31 : BNE .incorrect
	LDA !CryptoBuffer+1 : CMP #$41 : BNE .incorrect
	LDA !CryptoBuffer+2 : CMP #$59 : BNE .incorrect
	LDA !CryptoBuffer+3 : CMP #$26 : BNE .incorrect
	LDA !CryptoBuffer+4 : CMP #$53 : BNE .incorrect
	LDA !CryptoBuffer+5 : CMP #$58 : BNE .incorrect
	LDA !CryptoBuffer+6 : CMP #$97 : BNE .incorrect
	LDA !CryptoBuffer+7 : CMP #$93 : BNE .incorrect

	;trial decrypt the known plaintext, and verify if result is correct

	.correct
	PLY : PLX

	LDA #$01 : STA.l !ValidKeyLoaded
RTL
	.incorrect
	PLY : PLX
	LDA #$00
RTL

;--------------------------------------------------------------------------------
; Local Helper functions
;--------------------------------------------------------------------------------

PasswordToKey:
	; $00 input offset
	; $02 output offset
	; $04 shift amount
	LDA.w #$0000 : STA $00 : STA $02
	LDA.w #$000B : STA $04
	-
		LDX $00
		LDA !PASSWORD_SRAM, X : DEC : AND #$001F
		LDY $04
		-- : BEQ + : ASL : DEY : BRA -- : + ; Shift left by Y
		XBA
		LDX $02
		ORA !keyBase, X
		STA !keyBase, X

		LDA $04 : !SUB.w #$0005 : BPL +
			!ADD.w #$0008
			INC $02
		+ : STA $04

	LDA $00 : INC : STA $00 : CMP.w #$0010 : !BLT -
RTS

LoadPasswordStripeTemplate:
	LDA $4300 : PHA : LDA $4301 : PHA :	LDA $4302 : PHA ; preserve DMA parameters
	LDA $4303 : PHA : LDA $4304 : PHA :	LDA $4305 : PHA ; preserve DMA parameters
	LDA $4306 : PHA ; preserve DMA parameters

	LDA.b #$00 : STA $4300 ; set DMA transfer direction A -> B, bus A auto increment, single-byte mode
	LDA.b #$80 : STA $4301 ; set bus B destination to WRAM register

	LDA.b #$02 : STA $2181 ; set WRAM register source address
	LDA.b #$10 : STA $2182
	LDA.b #$7E : STA $2183

	LDA.b #Password_StripeImageTemplate : STA $4302 ; set bus A source address
	LDA.b #Password_StripeImageTemplate>>8 : STA $4303 ; set bus A source address
	LDA.b #Password_StripeImageTemplate>>16 : STA $4304 ; set bus A source bank

	LDA.b #Password_StripeImageTemplate_end-Password_StripeImageTemplate
	STA $4305 ;
	LDA.b #Password_StripeImageTemplate_end-Password_StripeImageTemplate>>8
	STA $4306 ; set transfer size

	LDA #$01 : STA $420B ; begin DMA transfer

	PLA : STA $4306 : PLA : STA $4305 :	PLA : STA $4304 ; restore DMA parameters
	PLA : STA $4303 : PLA : STA $4302 :	PLA : STA $4301 ; restore DMA parameters
	PLA : STA $4300 ; restore DMA parameters
RTS

!PASSWORD_INPUT_START_X = $03
!PASSWORD_INPUT_START_Y = $0D

!PASSWORD_DISPLAY_START_X = $04
!PASSWORD_DISPLAY_START_Y = $04

PasswordEraseOldCursors:

	REP #$20 ; set 16-bit accumulator

	;Code Cursor
	LDA !PASSWORD_CODE_POSITION : AND.w #$00FF : ASL : TAX
	LDA .code_offsets, X
	!ADD.w #$20*!PASSWORD_DISPLAY_START_Y+!PASSWORD_DISPLAY_START_X+$6000
	XBA ; because big endian is needed
	STA $1002+Password_StripeImageTemplate_CodeCursorErase-Password_StripeImageTemplate

	;selection cursor
	LDA !PASSWORD_SELECTION_POSITION : AND.w #$00FF : ASL : TAX
	LDA .selection_offsets, X
	!ADD.w #$20*!PASSWORD_INPUT_START_Y+!PASSWORD_INPUT_START_X+$6000
	XBA ; because big endian is needed
	STA $1002+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0020 : XBA
	STA $1002+$0C+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0003 : XBA
	STA $1002+$14+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0040-$0003 : XBA
	STA $1002+$1C+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate

	SEP #$20 ; restore 8-bit accumulator
RTS
.code_offsets
	dw $0040, $0043, $0046, $0049, $004C, $004F, $0052, $0055
	dw $00A0, $00A3, $00A6, $00A9, $00AC, $00AF, $00B2, $00B5
.selection_offsets
	dw $FFDF, $FFE2, $FFE5, $FFE8, $FFEB, $FFEE, $FFF1, $FFF4, $FFF7
	dw $003F, $0042, $0045, $0048, $004B, $004E, $0051, $0054, $0057
	dw $009F, $00A2, $00A5, $00A8, $00AB, $00AE, $00B1, $00B4, $00B7
	dw $00FF, $0102, $0105, $0108, $010B, $010E, $0111, $0114, $0117

PasswordSetNewCursors:
	REP #$20 ; set 16-bit accumulator
	;Code Cursor
	LDA !PASSWORD_CODE_POSITION : AND.w #$00FF : ASL : TAX
	LDA PasswordEraseOldCursors_code_offsets, X
	!ADD.w #$20*!PASSWORD_DISPLAY_START_Y+!PASSWORD_DISPLAY_START_X+$6000
	XBA ; because big endian is needed
	STA $1002+Password_StripeImageTemplate_CodeCursorDraw-Password_StripeImageTemplate

	;Selection cursor
	LDA !PASSWORD_SELECTION_POSITION : AND.w #$00FF : ASL : TAX
	LDA PasswordEraseOldCursors_selection_offsets, X
	!ADD.w #$20*!PASSWORD_INPUT_START_Y+!PASSWORD_INPUT_START_X+$6000
	XBA ; because big endian is needed
	STA $1002+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0020 : XBA
	STA $1002+$0C+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0003 : XBA
	STA $1002+$14+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0040-$0003 : XBA
	STA $1002+$1C+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate

	SEP #$20 ; restore 8-bit accumulator
RTS

UpdatePasswordTiles:
	REP #$30 ; set 16-bit both
	LDX.w #$000F
	-
		LDA.l !PASSWORD_SRAM, X : AND.w #$00FF : TXY
		ASL #3 : STA $00
		TYA : ASL #4 : STA $03
		LDX $00 : LDA.l HashAlphabetTilesWithBlank, X
		LDX $03 : STA $1006, X
		LDX $00 : LDA.l HashAlphabetTilesWithBlank+$02, X
		LDX $03 : STA $1008, X
		LDX $00 : LDA.l HashAlphabetTilesWithBlank+$04, X
		LDX $03 : STA $100E, X
		LDX $00 : LDA.l HashAlphabetTilesWithBlank+$06, X
		LDX $03 : STA $1010, X

		TYX : DEX : BMI + : BRA -
	+
	SEP #$30 ; restore 8-bit both
RTS

PasswordMoveCursorRight:
	; return new code position
	LDA.b #$2B : STA $012E
	LDA !PASSWORD_CODE_POSITION : INC A : AND.b #$0F : STA !PASSWORD_CODE_POSITION
RTS
PasswordMoveCursorLeft:
	; return new code position
	LDA.b #$2B : STA $012E
	LDA !PASSWORD_CODE_POSITION : DEC A : AND.b #$0F : STA !PASSWORD_CODE_POSITION
RTS

macro dw_big_endian(value)
	db <value>>>8
	db <value>
endmacro
macro Layer3_VRAM_Address(x,y)
	%dw_big_endian(<y>*$20+<x>+$6000)
endmacro


Password_Tilemap:
;Add any graphics for background 0 here
%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+0)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$0201|!FS_COLOR_YELLOW, #$0202|!FS_COLOR_YELLOW ;BOW
dw #$0200
dw #$0205|!FS_COLOR_BLUE, #$0206|!FS_COLOR_BLUE ;BOOM
dw #$0200
dw #$0200|!FS_COLOR_RED, #$0215|!FS_COLOR_RED ;HOOK
dw #$0200
dw #$020C|!FS_COLOR_BLUE, #$020D|!FS_COLOR_BLUE ;BOMB
dw #$0200
dw #$0262|!FS_COLOR_RED, #$0263|!FS_COLOR_RED ;SHROOM
dw #$0200
dw #$020A|!FS_COLOR_BROWN, #$020B|!FS_COLOR_BROWN ;POWDER
dw #$0200
dw #$0220|!FS_COLOR_BLUE, #$0221|!FS_COLOR_BLUE ;ROD
dw #$0200
dw #$0285|!FS_COLOR_GREEN, #$0286|!FS_COLOR_GREEN ;PENDANT
dw #$0200
dw #$02AB|!FS_COLOR_BW, #$02AB|!FS_COLOR_BW ;placeholder upper half action button

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+1)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$0211|!FS_COLOR_YELLOW, #$0212|!FS_COLOR_YELLOW ;BOW
dw #$0200
dw #$0200|!FS_COLOR_BW, #$0216|!FS_COLOR_BLUE ;BOOM
dw #$0200
dw #$0230|!FS_COLOR_RED, #$0200|!FS_COLOR_BW ;HOOK
dw #$0200
dw #$021C|!FS_COLOR_BLUE, #$021C|!FS_COLOR_BLUE|!FS_HFLIP ;BOMB
dw #$0200
dw #$0272|!FS_COLOR_RED, #$0273|!FS_COLOR_RED ;SHROOM
dw #$0200
dw #$021A|!FS_COLOR_BROWN, #$021B|!FS_COLOR_BROWN ;POWDER
dw #$0200
dw #$0230|!FS_COLOR_BLUE, #$0231|!FS_COLOR_BLUE ;ROD
dw #$0200
dw #$0295|!FS_COLOR_GREEN, #$0296|!FS_COLOR_GREEN ;PENDANT
dw #$0200
dw #$02AB|!FS_COLOR_BW, #$02AB|!FS_COLOR_BW ;placeholder lower half action button

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+3)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$0207|!FS_COLOR_YELLOW, #$0217|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;BOMBOS
dw #$0200
dw #$0208|!FS_COLOR_YELLOW, #$0218|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;ETHER
dw #$0200
dw #$0209|!FS_COLOR_YELLOW, #$0219|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;QUAKE
dw #$0200
dw #$022C|!FS_COLOR_RED, #$022C|!FS_COLOR_RED|!FS_HFLIP ;LAMP
dw #$0200
dw #$0222|!FS_COLOR_BROWN, #$0223|!FS_COLOR_BROWN ;HAMMER
dw #$0200
dw #$0224|!FS_COLOR_BROWN, #$0225|!FS_COLOR_BROWN ;SHOVEL
dw #$0200
dw #$0226|!FS_COLOR_BLUE, #$0227|!FS_COLOR_BLUE ;FLUTE
dw #$0200
dw #$0228|!FS_COLOR_YELLOW, #$0229|!FS_COLOR_YELLOW ;NET
dw #$0200
dw #$018A|!FS_COLOR_BW, #$0200 ; Left

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+4)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$0217|!FS_COLOR_YELLOW, #$0207|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;BOMBOS
dw #$0200
dw #$0218|!FS_COLOR_YELLOW, #$0208|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;ETHER
dw #$0200
dw #$0219|!FS_COLOR_YELLOW, #$0209|!FS_COLOR_YELLOW|!FS_HFLIP|!FS_VFLIP ;QUAKE
dw #$0200
dw #$023C|!FS_COLOR_RED, #$023D|!FS_COLOR_RED ;LAMP
dw #$0200
dw #$0232|!FS_COLOR_BROWN, #$0233|!FS_COLOR_BROWN ;HAMMER
dw #$0200
dw #$0234|!FS_COLOR_BROWN, #$0235|!FS_COLOR_BROWN ;SHOVEL
dw #$0200
dw #$0236|!FS_COLOR_BLUE, #$0237|!FS_COLOR_BLUE ;FLUTE
dw #$0200
dw #$0238|!FS_COLOR_YELLOW, #$0239|!FS_COLOR_YELLOW ;NET
dw #$0200
dw #$019A|!FS_COLOR_BW, #$0200 ; Left

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+6)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$022A|!FS_COLOR_GREEN, #$022B|!FS_COLOR_GREEN ;BOOK
dw #$0200
dw #$0240|!FS_COLOR_BW, #$0241|!FS_COLOR_BW ;BOTTLE
dw #$0200
dw #$0242|!FS_COLOR_GREEN, #$0242|!FS_COLOR_GREEN|!FS_HFLIP ;POTION
dw #$0200
dw #$021D|!FS_COLOR_RED, #$021E|!FS_COLOR_RED
dw #$0200
dw #$0248|!FS_COLOR_RED, #$0249|!FS_COLOR_RED
dw #$0200
dw #$024A|!FS_COLOR_BLUE, #$024B|!FS_COLOR_BLUE
dw #$0200
dw #$024C|!FS_COLOR_BOOTS, #$024D|!FS_COLOR_BOOTS
dw #$0200
dw #$024E|!FS_COLOR_BROWN, #$024F|!FS_COLOR_BROWN
dw #$0200
dw #$0200, #$018B|!FS_COLOR_BW ; Right

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+7)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$023A|!FS_COLOR_GREEN, #$023B|!FS_COLOR_GREEN ;BOOK
dw #$0200
dw #$0250|!FS_COLOR_BW, #$0251|!FS_COLOR_BW ;BOTTLE
dw #$0200
dw #$0252|!FS_COLOR_GREEN, #$0253|!FS_COLOR_GREEN ;POTION
dw #$0200
dw #$022D|!FS_COLOR_RED, #$022E|!FS_COLOR_RED ;CANE
dw #$0200
dw #$0258|!FS_COLOR_RED, #$0259|!FS_COLOR_RED ;CAPE
dw #$0200
dw #$025A|!FS_COLOR_BLUE, #$025B|!FS_COLOR_BLUE ;MIRROR
dw #$0200
dw #$025C|!FS_COLOR_BOOTS, #$025D|!FS_COLOR_BOOTS ;BOOTS
dw #$0200
dw #$025E|!FS_COLOR_BROWN, #$025F|!FS_COLOR_BROWN ;GLOVES
dw #$0200
dw #$0200, #$019B|!FS_COLOR_BW ; Right

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+9)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$020E|!FS_COLOR_BLUE, #$020F|!FS_COLOR_BLUE ;FLIPPERS
dw #$0200
dw #$0264|!FS_COLOR_RED, #$0265|!FS_COLOR_RED  ;PEARL
dw #$0200
dw #$026D|!FS_COLOR_YELLOW, #$026E|!FS_COLOR_YELLOW ;SHIELD
dw #$0200
dw #$026F|!FS_COLOR_GREEN, #$026F|!FS_COLOR_GREEN|!FS_HFLIP ;TUNIC
dw #$0200
dw #$0281|!FS_COLOR_RED, #$0281|!FS_COLOR_RED|!FS_HFLIP ;HEART
dw #$0200
dw #$0282|!FS_COLOR_YELLOW, #$0283|!FS_COLOR_YELLOW ;MAP
dw #$0200
dw #$0284|!FS_COLOR_RED, #$0284|!FS_COLOR_RED|!FS_HFLIP ;COMPASS
dw #$0200
dw #$022F|!FS_COLOR_YELLOW|!FS_HFLIP, #$022F|!FS_COLOR_YELLOW ;KEY
dw #$0200
dw #$0267|!FS_COLOR_BW|!FS_HFLIP, #$0267|!FS_COLOR_BW ;cancel

%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X,!PASSWORD_INPUT_START_Y+10)
%dw_big_endian(51) ;(9*4)+(8*2)-1
dw #$021F|!FS_COLOR_BLUE|!FS_HFLIP, #$021F|!FS_COLOR_BLUE ;FLIPPERS
dw #$0200
dw #$0274|!FS_COLOR_RED, #$0275|!FS_COLOR_RED ;PEARL
dw #$0200
dw #$027D|!FS_COLOR_YELLOW, #$027E|!FS_COLOR_YELLOW ;SHIELD
dw #$0200
dw #$027F|!FS_COLOR_GREEN, #$027F|!FS_COLOR_GREEN|!FS_HFLIP ;TUNIC
dw #$0200
dw #$0291|!FS_COLOR_RED, #$0291|!FS_COLOR_RED|!FS_HFLIP ;HEART
dw #$0200
dw #$0292|!FS_COLOR_YELLOW, #$0293|!FS_COLOR_YELLOW ;MAP
dw #$0200
dw #$0294|!FS_COLOR_RED, #$0294|!FS_COLOR_RED|!FS_HFLIP ;COMPASS
dw #$0200
dw #$023E|!FS_COLOR_YELLOW, #$023F|!FS_COLOR_YELLOW ;KEY
dw #$0200
dw #$0267|!FS_COLOR_BW|!FS_HFLIP|!FS_VFLIP, #$0267|!FS_VFLIP|!FS_COLOR_BW ;cancel

dw $FFFF

macro PasswordDisplaySlot(x,y)
	%Layer3_VRAM_Address(!PASSWORD_DISPLAY_START_X+<x>,!PASSWORD_DISPLAY_START_Y+<y>)
	%dw_big_endian(3)
	dw #$0186|!FS_COLOR_BW, #$0186|!FS_COLOR_BW
	%Layer3_VRAM_Address(!PASSWORD_DISPLAY_START_X+<x>,!PASSWORD_DISPLAY_START_Y+1+<y>)
	%dw_big_endian(3)
	dw #$0196|!FS_COLOR_BW, #$0196|!FS_COLOR_BW
endmacro
!FS_VERT_STRIPE = $8000
Password_StripeImageTemplate:
	%PasswordDisplaySlot(0,0)
	%PasswordDisplaySlot(3,0)
	%PasswordDisplaySlot(6,0)
	%PasswordDisplaySlot(9,0)
	%PasswordDisplaySlot(12,0)
	%PasswordDisplaySlot(15,0)
	%PasswordDisplaySlot(18,0)
	%PasswordDisplaySlot(21,0)
	%PasswordDisplaySlot(0,3)
	%PasswordDisplaySlot(3,3)
	%PasswordDisplaySlot(6,3)
	%PasswordDisplaySlot(9,3)
	%PasswordDisplaySlot(12,3)
	%PasswordDisplaySlot(15,3)
	%PasswordDisplaySlot(18,3)
	%PasswordDisplaySlot(21,3)
.CodeCursorErase ; a code cursor erase (position get be updated)
	%Layer3_VRAM_Address(!PASSWORD_DISPLAY_START_X,!PASSWORD_DISPLAY_START_Y+2)
	%dw_big_endian(3)
	dw #$0200, #$0200
.CodeCursorDraw ; Then comes a code cursor draw (will override the erase if same position)
	%Layer3_VRAM_Address(!PASSWORD_DISPLAY_START_X,!PASSWORD_DISPLAY_START_Y+2)
	%dw_big_endian(3)
	dw #$0267|!FS_COLOR_BW|!FS_HFLIP|!FS_VFLIP, #$0267|!FS_VFLIP|!FS_COLOR_BW
.SelectionCursorErase ; a selection cursor erase (position get be updated)
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y-1)
	%dw_big_endian(7)
	dw #$0200, #$0200, #$0200, #$0200
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$0200, #$0200
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X+2,!PASSWORD_INPUT_START_Y)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$0200, #$0200
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y+2)
	%dw_big_endian(7)
	dw #$0200, #$0200, #$0200, #$0200
.SelectionCursorDraw ; Then comes a selection cursor draw (will override the erase if same position)
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y-1)
	%dw_big_endian(7)
	dw #$02BB|!FS_COLOR_GREEN, #$02BC|!FS_COLOR_GREEN, #$02BC|!FS_COLOR_GREEN|!FS_HFLIP, #$02BB|!FS_COLOR_GREEN|!FS_HFLIP
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$02BD|!FS_COLOR_GREEN, #$02BD|!FS_COLOR_GREEN|!FS_VFLIP
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X+2,!PASSWORD_INPUT_START_Y)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$02BD|!FS_COLOR_GREEN|!FS_HFLIP, #$02BD|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP
	%Layer3_VRAM_Address(!PASSWORD_INPUT_START_X-1,!PASSWORD_INPUT_START_Y+2)
	%dw_big_endian(7)
	dw #$02BB|!FS_COLOR_GREEN|!FS_VFLIP, #$02BC|!FS_COLOR_GREEN|!FS_VFLIP, #$02BC|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP, #$02BB|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP
dw $FFFF
.end
