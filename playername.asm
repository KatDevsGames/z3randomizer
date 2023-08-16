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


NewNameStripes:
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

; Move JP characters where a-z are to column where second END button was
dw $B162, $1100
dw $1CEE, $0188, $1CEF, $0188, $1D05, $0188, $1D06, $0188
dw $1D07
dw $D162, $1100
dw $1CFE, $0188, $1CFF, $0188, $1D15, $0188, $1D16, $0188
dw $1D17
dw $F162, $1100
dw $1D0D, $0188, $1D0E, $0188, $1D0F, $0188, $1D20, $0188
dw $1D21
dw $1163, $1100
dw $1D1D, $0188, $1D1E, $0188, $1D1F, $0188, $1D30, $0188
dw $1D31
dw $3163, $1100
dw $1D22, $0188, $1D23, $0188, $1D24, $0188, $1D25, $0188
dw $1D26
dw $5163, $1100
dw $1D32, $0188, $1D33, $0188, $1D34, $0188, $1D35, $0188
dw $1D36

db $80 ; termination

TransferNewNameStripes:
        REP #$30
        LDA.w GameMode : CMP.w #$0204 : BNE .exit
        SEP #$20
        LDA.b #NewNameStripes>>0 : STA.b $00
        LDA.b #NewNameStripes>>8 : STA.b $01
        LDA.b #NewNameStripes>>16 : STA.b $02 : STA.w DMA1ADDRB
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
