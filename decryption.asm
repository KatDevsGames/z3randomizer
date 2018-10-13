
!CryptoBuffer = "$7F5100"
;!keyBase = "$7F50D0"

;--------------------------------------------------------------------------------
LoadStaticDecryptionKey:
	PHB : PHA : PHX : PHY : PHP
	REP #$30 ; set 16-bit accumulator & index registers
	LDX.w #StaticDecryptionKey  ; Source
	LDY.w #!keyBase             ; Target
	LDA.w #$000F                ; Length
	MVN $307F

	PLP : PLY : PLX : PLA : PLB
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
RetrieveValueFromEncryptedTable:
;Requires 16-bit A and X/Y
;$00-$02 are long address of start of table
;A is desired byte offset into table
;Returns result in A
	PHX : PHY
		PHA
			LDY $04 : PHY : LDY $06 : PHY : LDY $08 : PHY
			LDY $0A : PHY : LDY $0C : PHY : LDY $0E : PHY

				AND.w #$FFF8 : TAY
				LDA [$00], Y : STA.l !CryptoBuffer : INY #2
				LDA [$00], Y : STA.l !CryptoBuffer+2 : INY #2
				LDA [$00], Y : STA.l !CryptoBuffer+4 : INY #2
				LDA [$00], Y : STA.l !CryptoBuffer+6

				LDA.w #$0002 : STA $04 ;set block size

				JSL.l XXTEA_Decode

			PLA : STA $0E : PLA : STA $0C : PLA : STA $0A
			PLA : STA $08 : PLA : STA $06 : PLA : STA $04
		PLA : AND.w #$0007 : TAX
		LDA.l !CryptoBuffer, X
		PHA
			LDA.w #$0000
			STA.l !CryptoBuffer
			STA.l !CryptoBuffer+2
			STA.l !CryptoBuffer+4
			STA.l !CryptoBuffer+6
		PLA
	PLY : PLX
RTL
;--------------------------------------------------------------------------------

!ChestData = "$01E96C"
!ChestData_Payload = "$1EABC" ; !ChestData+$0150

;--------------------------------------------------------------------------------
GetChestData:
	LDA.l IsEncrypted : BNE .encrypted
		INC $0E : LDX.w #$FFFD ; what we wrote over
JML.l Dungeon_OpenKeyedObject_nextChest

.encrypted
		INC $0E : LDX.w #$FFFE

	.nextChest

	INX #2 : CPX.w #$0150 : BEQ .couldntFindChest
	LDA !ChestData, X : AND.w #$7FFF : CMP $A0 : BNE .nextChest

	DEC $0E : BNE .nextChest

	LDA $00 : PHA : LDA $02 : PHA

		LDA.w #!ChestData_Payload : STA $00
		LDA.w #!ChestData_Payload>>16 : STA $02

		TXA : LSR
		JSL RetrieveValueFromEncryptedTable
		STA $0C

	PLA : STA $02 : PLA : STA $00

	LDA !ChestData, X : ASL A : BCC .smallChest

JML.l Dungeon_OpenKeyedObject_bigChest ;(bank01.asm line #13783)

.smallChest
JML.l Dungeon_OpenKeyedObject_smallChest
.couldntFindChest
JML.l Dungeon_OpenKeyedObject_couldntFindChest
;--------------------------------------------------------------------------------
