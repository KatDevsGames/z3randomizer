; Note shortly before this we have a blank-the-sram slot code that we might want to hook
WriteBlanksToPlayerName:
	STA.l !ExtendedPlayerName
	STA.l !ExtendedPlayerName+2
	STA.l !ExtendedPlayerName+4
	STA.l !ExtendedPlayerName+6

	STA.l !ExtendedPlayerName+8
	STA.l !ExtendedPlayerName+10
	STA.l !ExtendedPlayerName+12
	STA.l !ExtendedPlayerName+14

	STA.l $7003D9, X ;What we wrote over (clear first byte of vanilla name slot)
RTL

WriteCharacterToPlayerName:
	CPX.w #$0008 : !BLT .orig
		STA !ExtendedPlayerName-8, X
	.orig
	STA $7003D9, X ;what we wrote over
RTL

ReadCharacterFromPlayerName: ;Only for use on Name Screen
	CPX.w #$0008 : !BLT .orig
		LDA !ExtendedPlayerName-8, X
	.orig
	LDA $7003D9, X ;what we wrote over
RTL

GetCharacterPosition:
PHB : PHK : PLB
	ORA.w CharacterPositions, Y
	XBA
PLB
RTL

WrapCharacterPosition:
	LDA $0B12 : BPL +
		LDA.b #$0B
	+
	CMP.b #$0C : !BLT +
		LDA.b #$00
	+
	STA $0B12
RTL

CharacterPositions:
dw $006E, $006F, $0070, $0071
dw $0073, $0074, $0075, $0076
dw $0078, $0079, $007a, $007b
HeartCursorPositions:
db $70, $78, $80, $88
db $98, $a0, $a8, $b0
db $c0, $c8, $d0, $d8
