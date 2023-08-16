Module_Password:
	LDA.b GameSubMode

	JSL.l JumpTableLong

	dl Password_BeginInit ; 0
	dl Password_EndInit ; 1
	dl Password_Main ; 2
	dl Password_Check ; 3
	dl Password_Return ; 4

Password_BeginInit:
	LDA.b #$80 : STA.w $0710 ;skip animated sprite updates in NMI

	JSL EnableForceBlank
	JSL Vram_EraseTilemaps_triforce

	JSL LoadCustomHudPalette ; replace the 2bpp palettes, and trigger upload
	LDA.b #$07 : STA.b NMISTRIPES ; have NMI load up the initial tilemap from Password_Tilemap

	INC.b GameSubMode
RTL

Password_EndInit:
        JSR LoadPasswordStripeTemplate

        ;reset the variables used by this screen
        STZ.b PasswordCodePosition
        STZ.b PasswordSelectPosition

        JSL ValidatePassword : BNE +
                ; zero out password if not valid
                LDX.b #$0F
                LDA.b #$00
                -
                STA.l PasswordSRAM, X
                DEX : BPL -
	+

	LDA.b #$0F : STA.b INIDISPQ
	INC.b GameSubMode
RTL

Password_Main:
	PHB
	PHK : PLB

    JSR PasswordEraseOldCursors

	; handle joypad input
	LDA.b $F6 : AND.b #$10 : BEQ + ; R Button
		JSR PasswordMoveCursorRight
	+
	LDA.b $F6 : AND.b #$20 : BEQ + ; L Button
		JSR PasswordMoveCursorLeft
	+
	LDA.b $F4 : AND.b #$01 : BEQ + ; right
		LDA.b PasswordSelectPosition : INC A : CMP.b #$24 : !BLT ++
			!SUB.b #$24
		++
		STA.b PasswordSelectPosition
		LDA.b #$20 : STA.w SFX3
	+
	LDA.b $F4 : AND.b #$02 : BEQ + ; left
		LDA.b PasswordSelectPosition : DEC A : BPL ++
			!ADD.b #$24
		++
		STA.b PasswordSelectPosition
		LDA.b #$20 : STA.w SFX3
	+
	LDA.b $F4 : AND.b #$04 : BEQ + ; down
		LDA.b PasswordSelectPosition : !ADD.b #$09 : CMP.b #$24 : !BLT ++
			!SUB.b #$24
		++
		STA.b PasswordSelectPosition
		LDA.b #$20 : STA.w SFX3
	+
	LDA.b $F4 : AND.b #$08 : BEQ + ; up
		LDA.b PasswordSelectPosition : !SUB.b #$09 :  BPL ++
			!ADD.b #$24
		++
		STA.b PasswordSelectPosition
		LDA.b #$20 : STA.w SFX3
	+
	LDA.b $F4 : ORA.b $F6 : AND.b #$C0 : BEQ + ; face button
		LDX.b PasswordSelectPosition
		LDA.l .selectionValues, X : BPL ++
			CMP.b #$F0 :  BNE +++
				INC.b GameSubMode
				BRA .endOfButtonChecks
			+++ : CMP.b #$F1 :  BNE +++
				JSR PasswordMoveCursorLeft
				BRA +
			+++ : CMP.b #$F2 :  BNE +++
				JSR PasswordMoveCursorRight
				BRA +
			+++ : CMP.b #$F3 :  BNE +++
				INC.b GameSubMode : INC.b GameSubMode ; skip to return submodule
				LDA.b #$2C : STA.w SFX2 ;file screen selection sound
				BRA .endOfButtonChecks
			+++
			BRA +
		++
		LDX.b PasswordCodePosition
		STA.l PasswordSRAM,X
		TXA : INC A : AND.b #$0F : STA.b PasswordCodePosition
		BNE ++
			STZ.w SFX2
			INC.b GameSubMode
			BRA .endOfButtonChecks
		++
		LDA.b #$2B : STA.w SFX2
	+
	LDA.b $F4 : AND.b #$10 : BEQ + ; start
		INC.b GameSubMode
	+
	.endOfButtonChecks

	JSR UpdatePasswordTiles

	JSR PasswordSetNewCursors
	LDA.b #$01 : STA.b NMISTRIPES
	PLB
RTL
.selectionValues
db $01, $02, $03, $04, $05, $06, $07, $08, $F0
db $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $F1
db $11, $12, $13, $14, $15, $16, $17, $18, $F2
db $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $F3

Password_Check:
	JSL.l ValidatePassword : BNE .correct
	LDA.b #$3C : STA.w SFX2 ; error
	DEC.b GameSubMode
RTL
	.correct
	LDA.b #$1B : STA.w SFX3 ; solved puzzle sound
	INC.b GameSubMode
RTL

Password_Return:
	LDA.b #$01 : STA.b GameMode ; select screen
	LDA.b #$01 : STA.b GameSubMode ; Skip the first submodule
	STZ.b SubSubModule
	STZ.w SaveFileIndex
	STZ.b PasswordCodePosition
	STZ.b PasswordCodePosition+1
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
	LDX.b #$0F
	-
		LDA.l PasswordSRAM, X : BNE +
		 	JMP .incorrect
		+
	DEX : BPL -

	REP #$20 ; 16 bit Accumulator

	; Clear out any existing encryption key
	LDX.b #$0E
	LDA.w #$0000
	- :	STA.l KeyBase, X : DEX #2 : BPL -

	JSR PasswordToKey


	LDA.l StaticDecryptionKey+$0A : STA.l KeyBase+$0A
	LDA.l StaticDecryptionKey+$0C : STA.l KeyBase+$0C
	LDA.l StaticDecryptionKey+$0E : STA.l KeyBase+$0E

	LDA.l KnownEncryptedValue   : STA.l CryptoBuffer
	LDA.l KnownEncryptedValue+2 : STA.l CryptoBuffer+2
	LDA.l KnownEncryptedValue+4 : STA.l CryptoBuffer+4
	LDA.l KnownEncryptedValue+6 : STA.l CryptoBuffer+6

	LDA.w #$0002 : STA.b $04 ;set block size

	JSL.l XXTEA_Decode

	SEP #$20 ; 8 bit accumulator

	LDA.l CryptoBuffer+0 : CMP.b #$31 : BNE .incorrect
	LDA.l CryptoBuffer+1 : CMP.b #$41 : BNE .incorrect
	LDA.l CryptoBuffer+2 : CMP.b #$59 : BNE .incorrect
	LDA.l CryptoBuffer+3 : CMP.b #$26 : BNE .incorrect
	LDA.l CryptoBuffer+4 : CMP.b #$53 : BNE .incorrect
	LDA.l CryptoBuffer+5 : CMP.b #$58 : BNE .incorrect
	LDA.l CryptoBuffer+6 : CMP.b #$97 : BNE .incorrect
	LDA.l CryptoBuffer+7 : CMP.b #$93 : BNE .incorrect

	;trial decrypt the known plaintext, and verify if result is correct

	.correct
	PLY : PLX

	LDA.b #$01 : STA.l ValidKeyLoaded
RTL
	.incorrect
	PLY : PLX
	LDA.b #$00
RTL

;--------------------------------------------------------------------------------
; Local Helper functions
;--------------------------------------------------------------------------------

PasswordToKey:
	; $00 input offset
	; $02 output offset
	; $04 shift amount
	LDA.w #$0000 : STA.b $00 : STA.b $02
	LDA.w #$000B : STA.b $04
	-
		LDX.b $00
		LDA.l PasswordSRAM, X : DEC : AND.w #$001F
		LDY.b $04
		-- : BEQ + : ASL : DEY : BRA -- : + ; Shift left by Y
		XBA
		LDX.b $02
		ORA.l KeyBase, X
		STA.l KeyBase, X

		LDA.b $04 : !SUB.w #$0005 : BPL +
			!ADD.w #$0008
			INC $02
		+ : STA.b $04

	LDA.b $00 : INC : STA.b $00 : CMP.w #$0010 : !BLT -
RTS

LoadPasswordStripeTemplate:
	LDA.w DMAP0 : PHA : LDA.w BBAD0 : PHA :	LDA.w A1T0L : PHA ; preserve DMA parameters
	LDA.w A1T0H : PHA : LDA.w A1B0 : PHA :	LDA.w DAS0L : PHA ; preserve DMA parameters
	LDA.w DAS0H : PHA ; preserve DMA parameters  
  
	LDA.b #$00 : STA.w DMAP0 ; set DMA transfer direction A -> B, bus A auto increment, single-byte mode
	LDA.b #$80 : STA.w BBAD0 ; set bus B destination to WRAM register

	LDA.b #$02 : STA.w WMADDL ; set WRAM register source address
	LDA.b #$10 : STA.w WMADDH
	LDA.b #$7E : STA.w WMADDB

	LDA.b #Password_StripeImageTemplate : STA.w A1T0L ; set bus A source address
	LDA.b #Password_StripeImageTemplate>>8 : STA.w A1T0H ; set bus A source address
	LDA.b #Password_StripeImageTemplate>>16 : STA.w A1B0 ; set bus A source bank

	LDA.b #Password_StripeImageTemplate_end-Password_StripeImageTemplate
	STA.w DAS0L ;
	LDA.b #Password_StripeImageTemplate_end-Password_StripeImageTemplate>>8
	STA.w DAS0H ; set transfer size

	LDA.b #$01 : STA.w MDMAEN ; begin DMA transfer

	PLA : STA.w DAS0H : PLA : STA.w DAS0L :	PLA : STA.w A1B0 ; restore DMA parameters
	PLA : STA.w A1T0H : PLA : STA.w A1T0L :	PLA : STA.w BBAD0 ; restore DMA parameters
	PLA : STA.w DMAP0 ; restore DMA parameters
RTS

PasswordEraseOldCursors:

	REP #$20 ; set 16-bit accumulator

	;Code Cursor
	LDA.b PasswordCodePosition : AND.w #$00FF : ASL : TAX
	LDA.l .code_offsets, X
	!ADD.w #$20*Scrap04+Scrap04+$6000
	XBA ; because big endian is needed
	STA.l $1002+Password_StripeImageTemplate_CodeCursorErase-Password_StripeImageTemplate

	;selection cursor
	LDA.b PasswordSelectPosition : AND.w #$00FF : ASL : TAX
	LDA.l .selection_offsets, X
	!ADD.w #$20*Scrap0D+Scrap03+$6000
	XBA ; because big endian is needed
	STA.l $1002+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0020 : XBA
	STA.l $1002+$0C+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0003 : XBA
	STA.l $1002+$14+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate
	XBA : !ADD.w #$0040-$0003 : XBA
	STA.l $1002+$1C+Password_StripeImageTemplate_SelectionCursorErase-Password_StripeImageTemplate

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
	LDA.b PasswordCodePosition : AND.w #$00FF : ASL : TAX
	LDA.l PasswordEraseOldCursors_code_offsets, X
	!ADD.w #$20*Scrap04+Scrap04+$6000
	XBA ; because big endian is needed
	STA.l $1002+Password_StripeImageTemplate_CodeCursorDraw-Password_StripeImageTemplate

	;Selection cursor
	LDA.b PasswordSelectPosition : AND.w #$00FF : ASL : TAX
	LDA.l PasswordEraseOldCursors_selection_offsets, X
	!ADD.w #$20*Scrap0D+Scrap03+$6000
	XBA ; because big endian is needed
	STA.l $1002+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0020 : XBA
	STA.l $1002+$0C+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0003 : XBA
	STA.l $1002+$14+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate
	XBA : !ADD.w #$0040-$0003 : XBA
	STA.l $1002+$1C+Password_StripeImageTemplate_SelectionCursorDraw-Password_StripeImageTemplate

	SEP #$20 ; restore 8-bit accumulator
RTS

UpdatePasswordTiles:
	REP #$30 ; set 16-bit both
	LDX.w #$000F
	-
		LDA.l PasswordSRAM, X : AND.w #$00FF : TXY
		ASL #3 : STA.b $00
		TYA : ASL #4 : STA.b $03
		LDX.b $00 : LDA.l HashAlphabetTilesWithBlank, X
		LDX.b $03 : STA.w $1006, X
		LDX.b $00 : LDA.l HashAlphabetTilesWithBlank+$02, X
		LDX.b $03 : STA.w $1008, X
		LDX.b $00 : LDA.l HashAlphabetTilesWithBlank+$04, X
		LDX.b $03 : STA.w $100E, X
		LDX.b $00 : LDA.l HashAlphabetTilesWithBlank+$06, X
		LDX.b $03 : STA.w $1010, X

		TYX : DEX : BMI + : BRA -
	+
	SEP #$30 ; restore 8-bit both
RTS

PasswordMoveCursorRight:
	; return new code position
	LDA.b #$2B : STA.w SFX2
	LDA.b PasswordCodePosition : INC A : AND.b #$0F : STA.b PasswordCodePosition
RTS
PasswordMoveCursorLeft:
	; return new code position
	LDA.b #$2B : STA.w SFX2
	LDA.b PasswordCodePosition : DEC A : AND.b #$0F : STA.b PasswordCodePosition
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
%Layer3_VRAM_Address(Scrap03,Scrap0D+0)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+1)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+3)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+4)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+6)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+7)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+9)
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

%Layer3_VRAM_Address(Scrap03,Scrap0D+10)
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
	%Layer3_VRAM_Address(Scrap04+<x>,Scrap04+<y>)
	%dw_big_endian(3)
	dw #$0186|!FS_COLOR_BW, #$0186|!FS_COLOR_BW
	%Layer3_VRAM_Address(Scrap04+<x>,Scrap04+1+<y>)
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
	%Layer3_VRAM_Address(Scrap04,Scrap04+2)
	%dw_big_endian(3)
	dw #$0200, #$0200
.CodeCursorDraw ; Then comes a code cursor draw (will override the erase if same position)
	%Layer3_VRAM_Address(Scrap04,Scrap04+2)
	%dw_big_endian(3)
	dw #$0267|!FS_COLOR_BW|!FS_HFLIP|!FS_VFLIP, #$0267|!FS_VFLIP|!FS_COLOR_BW
.SelectionCursorErase ; a selection cursor erase (position get be updated)
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D-1)
	%dw_big_endian(7)
	dw #$0200, #$0200, #$0200, #$0200
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$0200, #$0200
	%Layer3_VRAM_Address(Scrap03+2,Scrap0D)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$0200, #$0200
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D+2)
	%dw_big_endian(7)
	dw #$0200, #$0200, #$0200, #$0200
.SelectionCursorDraw ; Then comes a selection cursor draw (will override the erase if same position)
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D-1)
	%dw_big_endian(7)
	dw #$02BB|!FS_COLOR_GREEN, #$02BC|!FS_COLOR_GREEN, #$02BC|!FS_COLOR_GREEN|!FS_HFLIP, #$02BB|!FS_COLOR_GREEN|!FS_HFLIP
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$02BD|!FS_COLOR_GREEN, #$02BD|!FS_COLOR_GREEN|!FS_VFLIP
	%Layer3_VRAM_Address(Scrap03+2,Scrap0D)
	%dw_big_endian(3|!FS_VERT_STRIPE)
	dw #$02BD|!FS_COLOR_GREEN|!FS_HFLIP, #$02BD|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP
	%Layer3_VRAM_Address(Scrap03-1,Scrap0D+2)
	%dw_big_endian(7)
	dw #$02BB|!FS_COLOR_GREEN|!FS_VFLIP, #$02BC|!FS_COLOR_GREEN|!FS_VFLIP, #$02BC|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP, #$02BB|!FS_COLOR_GREEN|!FS_HFLIP|!FS_VFLIP
dw $FFFF
.end
