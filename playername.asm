; Note shortly before this we have a blank-the-sram slot code that we might want to hook
WriteBlanksToPlayerName:
	STA.l ExtendedFileNameSRAM
	STA.l ExtendedFileNameSRAM+2
	STA.l ExtendedFileNameSRAM+4
	STA.l ExtendedFileNameSRAM+6

	STA.l ExtendedFileNameSRAM+8
	STA.l ExtendedFileNameSRAM+10
        STA.l ExtendedFileNameSRAM+12
	STA.l ExtendedFileNameSRAM+14

        STA.l ExtendedFileNameSRAM+16
	STA.l ExtendedFileNameSRAM+18
	STA.l ExtendedFileNameSRAM+20
	STA.l ExtendedFileNameSRAM+22

        STA.l $7003D9, X ;What we wrote over (clear first byte of vanilla name slot)
RTL

WriteCharacterToPlayerName:
	STA ExtendedFileNameSRAM, X
        CPX.w #$0008 : !BGE +
	    STA $7003D9, X ;what we wrote over
        +
RTL

ReadCharacterFromPlayerName: ;Only for use on Name Screen
	LDA ExtendedFileNameSRAM, X
        CPX.w #$0008 : !BGE +
            LDA $7003D9, X ;what we wrote over
        +
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
