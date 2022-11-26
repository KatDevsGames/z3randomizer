
;--------------------------------------------------------------------------------
LoadStaticDecryptionKey:
	PHB : PHA : PHX : PHY : PHP
	REP #$30 ; set 16-bit accumulator & index registers
	LDX.w #StaticDecryptionKey  ; Source
	LDY.w #KeyBase             ; Target
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
			LDY.b Scrap04 : PHY : LDY.b Scrap06 : PHY : LDY.b Scrap08 : PHY
			LDY.b Scrap0A : PHY : LDY.b Scrap0C : PHY : LDY.b Scrap0E : PHY

				AND.w #$FFF8 : TAY
				LDA.b [$00], Y : STA.l CryptoBuffer : INY #2
				LDA.b [$00], Y : STA.l CryptoBuffer+2 : INY #2
				LDA.b [$00], Y : STA.l CryptoBuffer+4 : INY #2
				LDA.b [$00], Y : STA.l CryptoBuffer+6

				LDA.w #$0002 : STA.b Scrap04 ;set block size

				JSL.l XXTEA_Decode

			PLA : STA.b Scrap0E : PLA : STA.b Scrap0C : PLA : STA.b Scrap0A
			PLA : STA.b Scrap08 : PLA : STA.b Scrap06 : PLA : STA.b Scrap04
		PLA : AND.w #$0007 : TAX
		LDA.l CryptoBuffer, X
		PHA
			LDA.w #$0000
			STA.l CryptoBuffer
			STA.l CryptoBuffer+2
			STA.l CryptoBuffer+4
			STA.l CryptoBuffer+6
		PLA
	PLY : PLX
RTL
;--------------------------------------------------------------------------------
ChestData = $01E96C
ChestDataPayload = $01EABC ; ChestData+$0150
;--------------------------------------------------------------------------------
GetChestData:
	LDA.l IsEncrypted : BNE .encrypted
		INC.b Scrap0E : LDX.w #$FFFD ; what we wrote over
JML.l Dungeon_OpenKeyedObject_nextChest

.encrypted
		INC.b Scrap0E : LDX.w #$FFFE

	.nextChest

	INX #2 : CPX.w #$0150 : BEQ .couldntFindChest
	LDA.l ChestData, X : AND.w #$7FFF : CMP.b RoomIndex : BNE .nextChest

	DEC.b Scrap0E : BNE .nextChest

	LDA.b Scrap00 : PHA : LDA.b Scrap02 : PHA

		LDA.w #ChestDataPayload : STA.b Scrap00
		LDA.w #ChestDataPayload>>16 : STA.b Scrap02

		TXA : LSR
		JSL RetrieveValueFromEncryptedTable
		STA.b Scrap0C

	PLA : STA.b Scrap02 : PLA : STA.b Scrap00

	LDA.l ChestData, X : ASL A : BCC .smallChest

JML.l Dungeon_OpenKeyedObject_bigChest ;(bank01.asm line #13783)

.smallChest
JML.l Dungeon_OpenKeyedObject_smallChest
.couldntFindChest
JML.l Dungeon_OpenKeyedObject_couldntFindChest
;--------------------------------------------------------------------------------
