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

        STA.l FileNameVanillaSRAM, X ;What we wrote over (clear first byte of vanilla name slot)
RTL

WriteCharacterToPlayerName:
	STA.l ExtendedFileNameSRAM, X
        CPX.w #$0008 : !BGE +
	    STA.l FileNameVanillaSRAM, X ;what we wrote over
        +
RTL

ReadCharacterFromPlayerName: ;Only for use on Name Screen
	LDA.l ExtendedFileNameSRAM, X
        CPX.w #$0008 : !BGE +
            LDA.l FileNameVanillaSRAM, X ;what we wrote over
        +
RTL

GetCharacterPosition:
PHB : PHK : PLB
	ORA.w CharacterPositions, Y
	XBA
PLB
RTL

WrapCharacterPosition:
	LDA.w PlayerNameCursor : BPL +
		LDA.b #$0B
	+
	CMP.b #$0C : !BLT +
		LDA.b #$00
	+
	STA.w PlayerNameCursor
RTL

CharacterPositions:
dw $006E, $006F, $0070, $0071
dw $0073, $0074, $0075, $0076
dw $0078, $0079, $007a, $007b
HeartCursorPositions:
db $70, $78, $80, $88
db $98, $a0, $a8, $b0
db $c0, $c8, $d0, $d8


NumberStripes:
dw $AB66, $1100 ; 0-4 top
dw $1D40, $0188, $1D41, $0188, $1D42, $0188, $1D43, $0188
dw $1D44
dw $CB66, $1100 ; 0-4 bottom
dw $1D50, $0188, $1D51, $0188, $1D52, $0188, $1D53, $0188
dw $1D54
dw $EB66, $1100 ; 5-9 top
dw $1D45, $0188, $1D46, $0188, $1D47, $0188, $1D48, $0188
dw $1D49
dw $0B67, $1100 ; 5-9 bottom
dw $1D55, $0188, $1D56, $0188, $1D57, $0188, $1D58, $0188
dw $1D59
db $80 ; termination

TransferNumericStripes:
        REP #$30
        LDA.w GameMode : CMP.w #$0204 : BNE .exit
        SEP #$20
        LDA.b #NumberStripes>>0 : STA.b $00
        LDA.b #NumberStripes>>8 : STA.b $01
        LDA.b #NumberStripes>>16 : STA.b $02 : STA.w DMA1ADDRB
        STZ.b $06 : LDY.w #$0000
        .check_next
        LDA.b [$00],Y : BPL .next_stripe
        .exit
        SEP #$30
RTL
        .next_stripe
        STA.b $04
        INY
        LDA.b [$00],Y : STA.b $03
        INY
        LDA.b [$00],Y : AND.b #$80 : ASL : ROL : STA.b $07
        LDA.b [$00],Y : AND.b #$40 : STA.b $05
        LSR #3 : ORA.b #$01 : STA.w DMA1MODE
        LDA.b #VMDATAL : STA.w DMA1PORT
        REP #$20
        LDA.b $03 : STA.w VMADDR
        LDA.b [$00],Y : XBA : AND.w #$3FFF
        TAX : INX : STX.w DMA1SIZE
        INY #2 : TYA
        CLC : ADC.b $00 : STA.w DMA1ADDRL
        LDA.b $05
        STX.b $03
        TYA : CLC : ADC.b $03 : TAY
        SEP #$20
        LDA.b $07 : ORA.b #$80 : STA.w VMAIN
        LDA.b #$02 : STA.w DMAENABLE
        JMP.w .check_next
