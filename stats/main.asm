lorom

!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

org $238000
incsrc stats/credits.asm

FontGfx:
if !FEATURE_NEW_TEXT
	incbin stats/font.2bpp
else
	incbin stats/font.gb
endif
FontGfxEnd:

; Custom addresses. Most are arbitrary. Feel free to make sure they're okay or moving them elsewhere within ZP
CreditsPtr = $7C   ; 3 bytes
Temp = $B3         ; 2 bytes
StatsBottom = $B5  ; 2 bytes
StatsPtr = $B7     ; 3 bytes
ValueLow = $BA     ; 2 bytes
ValueHigh = $BC    ; 2 bytes
Hours = $72        ; 2 bytes
Minutes = $74      ; 2 bytes
Seconds = $76      ; 2 bytes
RemoveZero = $78   ; 2 bytes

; Original addresses
LineNumber = $CA   ; 2 bytes

PreparePointer:
	LDA.w #$2300
	STA.b CreditsPtr+1
	LDA.w #CreditsLineTable
	STA.b CreditsPtr
	LDA.b [CreditsPtr],Y
	STA.b CreditsPtr
	LDY.w #$0000
RTL

;   Regular stat:   XXXX X00L   LLLL LLLL   BBBB SSSS   CCC- ----   ---- ----   AAAA AAAA   AAAA AAAA   AAAA AAAA
;   Time stat:      XXXX X01L   LLLL LLLL   ---- ----   ---- ----   ---- ----   AAAA AAAA   AAAA AAAA   AAAA AAAA
;   End of data:    1111 1111   1111 1111

;   X   X offset (measured in 8x8 tiles)
;   L   Line number
;   B   Amount of bits to keep after shifting (0000 = 16 bits, 0001 = 1 bit, 1111 = 15 bits)
;   S   Amount of bits to right shift the value by (0000 = 0 bits, 1111 = 15 bits)
;   C   Value cap
;           000 No cap
;           001 9
;           010 99
;           011 999
;           100 9999
;   A   Memory Address

ValueCaps:
    dw 0
    dw 9
    dw 99
    dw 999
    dw 9999
    dw 9999 ; TODO - 5 digits need to be fixed at a later date

BitMasks:
    dw $FFFF
    dw $0001
    dw $0003
    dw $0007
    dw $000F
    dw $001F
    dw $003F
    dw $007F
    dw $00FF
    dw $01FF
    dw $03FF
    dw $07FF
    dw $0FFF
    dw $1FFF
    dw $3FFF
    dw $7FFF

macro StripeStart(xPos, length)
    LDA.b $C8
    CLC
    ADC.w #<xPos>
    XBA
    STA.w $1002,x
    
    LDA.w #<length>*2-1
    XBA
    LDA.w #$0500
    STA.w $1004,x
endmacro

macro StripeTile()
    STA.w $1006,x
    INX
    INX
endmacro

macro StripeEnd()
    INX
    INX
    INX
    INX
endmacro

HexToDecStats:
	PHA
	PHA
		LDA.w #$0000
		STA.l $7F5003 : STA.l $7F5005 : STA.l $7F5006 ; clear digit storage
	PLA
	-
	CMP.w #10000 : !BLT +
	PHA : SEP #$20 : LDA.l $7F5003 : INC : STA.l $7F5003 : REP #$20 : PLA
	!SUB.w #10000 : BRA -
	+ -
	CMP.w #1000 : !BLT +
	PHA : SEP #$20 : LDA.l $7F5004 : INC : STA.l $7F5004 : REP #$20 : PLA
	!SUB.w #1000 : BRA -
	+ -
	CMP.w #100 : !BLT +
	PHA : SEP #$20 : LDA.l $7F5005 : INC : STA.l $7F5005 : REP #$20 : PLA
	!SUB.w #100 : BRA -
	+ -
	CMP.w #10 : !BLT +
	PHA : SEP #$20 : LDA.l $7F5006 : INC : STA.l $7F5006 : REP #$20 : PLA
	!SUB.w #10 : BRA -
	+ -
	CMP.w #1 : !BLT +
	PHA : SEP #$20 : LDA.l $7F5007 : INC : STA.l $7F5007 : REP #$20 : PLA
	!SUB.w #1 : BRA -
	+ 
	PLA
RTL

LastHexDigit: 
    TYA
    AND.w #$000F
    PHA
    TYA
    LSR #4
    TAY
    CLC
    LDA.b StatsBottom
    BNE +
    ; Upper half
    PLA
    ADC #$3D40
    RTS
+   ; Lower half
    PLA
    ADC #$3D50
    RTS
    
FindLine:
    LDY.w #$0000

-   LDA.w CreditsStats,y
    STZ.b StatsBottom
    CMP #$FFFF
    BEQ .noLine
    
    XBA
    AND.w #$01FF
    CMP.b LineNumber
    BEQ .lineFound
    
    INC
    INC.b StatsBottom
    CMP.b LineNumber
    BEQ .lineFound
    
    INY #8
    BRA -
    
.lineFound
    SEC
    RTS
    
.noLine
    CLC
    RTS

!FRAMES_PER_SECOND = 60
!FRAMES_PER_MINUTE = 60*60
!FRAMES_PER_HOUR = 60*60*60
!MAX_FRAME_COUNT = 59*60+59*60+59*60+99

macro CountUnits(framesPerUnit, unitCounter)
    STZ.b <unitCounter>
?loop:
    LDA.b ValueLow
    SEC
    SBC.w #<framesPerUnit>
    STA.b Temp
    LDA.b ValueHigh
    SBC.w #<framesPerUnit>>>16
    BCC ?end
    STA.b ValueHigh
    LDA.b Temp
    STA.b ValueLow
    INC.b <unitCounter>
    BRA ?loop
?end:
endmacro

!ColonOffset = $83
!PeriodOffset = $80
BlankTile = $883D

RenderCreditsStatCounter:
    PHB
    PHK
    PLB
    
    JSR FindLine
    BCS +
    JMP .endStats
+   
    
    ;   XXXX X00L   LLLL LLLL   BBBB SSSS   CCC- ----   ---- ----   AAAA AAAA   AAAA AAAA   AAAA AAAA
    
    ; == Determine stat type ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR
    AND.w #$0003          ; TT
    CMP.w #$0000
    BEQ .normalStat
    JMP .timeStat

.normalStat
    ; == Write Stripe header (VRAM address, i.e. tile coordinates) ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR #3
    AND.w #$001F          ; X XXXX
    CLC
    ADC.w $C8
    XBA
    STA.w $1002,x
    
    ; == Write Stripe header (Length of data) ==
    LDA.w #4*2-1    ; 4 tiles = 8 bytes
    XBA
    STA.w $1004,x
    PHX
    
    ; == Load tile base (upper or lower half of white two-line zero) ==
    LDA.b StatsBottom
    BNE +
    LDA.w #$3D40
    BRA ++
+   LDA.w #$3D50
++  STA.b Temp

    ; == Load the actual stat word ==
    LDA.w CreditsStats+5,y
    STA.b StatsPtr
    LDA.w CreditsStats+6,y
    STA.b StatsPtr+1
    LDA.b [StatsPtr]
    STA.b ValueLow
    
    ; == Shift value ==
    LDA.w CreditsStats+2,y;   CCC- ---- BBBB SSSS
    AND.w #$000F        ;   SSSS
    BEQ +
    TAX
    LDA.b ValueLow
-   LSR
    DEX
    BNE -
    STA.b ValueLow
+   
    ; == Mask value ==
    LDA.w CreditsStats+2,y;   CCC- ---- BBBB SSSS
    ;LSR #4
    ;AND.w #$000F        ;   BBBB
	LSR #3
	AND.w #$001E
    TAX
    LDA.l BitMasks,x
    AND.b ValueLow
    STA.b ValueLow
    
    ; == Cap value ==
    LDA.w CreditsStats+3,y;   ---- ---- CCC- ----
    LSR #5
    AND.w #$0007        ;   CCC
    BEQ +
    ASL : TAX
    LDA.l ValueCaps,x
    CMP.b ValueLow
    !BGE +
    STA.b ValueLow
+   
    ; == Display value ==
    LDA.b ValueLow
    JSL HexToDecStats
    PLX
    STZ.b RemoveZero
    
    LDA.l $7F5004
    AND.w #$00FF
    CMP.b RemoveZero
    BNE +
    LDA.w #BlankTile
    BRA ++
+   DEC.b RemoveZero
    CLC
    ADC.b Temp
++  %StripeTile()
    
    LDA.l $7F5005
    AND.w #$00FF
    CMP.b RemoveZero
    BNE +
    LDA.w #BlankTile
    BRA ++
+   DEC.b RemoveZero
    CLC
    ADC.b Temp
++  %StripeTile()
    
    LDA.l $7F5006
    AND.w #$00FF
    CMP.b RemoveZero
    BNE +
    LDA.w #BlankTile
    BRA ++
+   DEC.b RemoveZero
    CLC
    ADC.b Temp
++  %StripeTile()
    
    LDA.l $7F5007
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    %StripeEnd()
.endStats

    PLB
    RTL
    
.timeStat
    ; Output format: HH:MM:SS.FF
    
    ; == Write Stripe header (VRAM address, i.e. tile coordinates) ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR #3
    AND.w #$001F          ; X XXXX
    CLC
    ADC.b $C8
    XBA
    STA.w $1002,x
    
    ; == Write Stripe header (Length of data) ==
    LDA.w #11*2-1    ; 11 tiles = 22 bytes
    XBA
    STA.w $1004,x
    PHX
    
    ; == Load the actual stat words ==
    LDA.w CreditsStats+5,y
    STA.b StatsPtr
    LDA.w CreditsStats+6,y
    STA.b StatsPtr+1
    LDA.b [StatsPtr]
    STA.b ValueLow
    INC.b StatsPtr
    INC.b StatsPtr
    LDA.b [StatsPtr]
    STA.b ValueHigh
    
    CMP.w #!MAX_FRAME_COUNT>>16+1
    !BGE ++
    
    ; == Convert total frames into hours, minutes, seconds and frames ==
    %CountUnits(!FRAMES_PER_HOUR, Hours)
    %CountUnits(!FRAMES_PER_MINUTE, Minutes)
    %CountUnits(!FRAMES_PER_SECOND, Seconds)
    
    ; == Cap at 99:59:59.59 ==
    LDA.b Hours
    CMP.w #100
    !BLT +
++  LDA.w #99
    STA.b Hours
    LDA.w #59
    STA.b Minutes
    STA.b Seconds
    STA.b ValueLow
+
    
    ; == Load tile base (upper or lower half of white two-line zero) ==
    LDA.b StatsBottom
    BNE +
    LDA.w #$3D40
    BRA ++
+   LDA.w #$3D50
++  STA.b Temp
    
    PLX
    
    ; == Display value ==
    LDA.b Hours
    JSL HexToDecStats
    
    LDA.l $7F5006
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.l $7F5007
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.w #!ColonOffset
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.b Minutes
    JSL HexToDecStats
    LDA.l $7F5006
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.l $7F5007
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.w #!ColonOffset
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.b Seconds
    JSL HexToDecStats
    LDA.l $7F5006
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.l $7F5007
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.w #!PeriodOffset
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.b ValueLow
    JSL HexToDecStats
    LDA.l $7F5006
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    LDA.l $7F5007
    AND.w #$00FF
    CLC
    ADC.b Temp
    %StripeTile()
    
    %StripeEnd()
    JMP .endStats
    
    
RenderLineNumber:
    %StripeStart(0, 3)
    
    STZ.b StatsBottom
    LDA.b $CA
    TAY
    AND.w #$0001
    BEQ +
    DEY
    INC.b StatsBottom
+   
    JSR LastHexDigit
    PHA
    JSR LastHexDigit
    PHA
    JSR LastHexDigit
    %StripeTile()
    PLA
    %StripeTile()
    PLA
    %StripeTile()
    
    %StripeEnd()
    
    RTS
    
LoadModifiedFont:
    ; Based on CopyFontToVram(Bank00)
    ; copies font graphics to VRAM (for BG3)
    
    ; set name base table to vram $4000 (word)
    LDA.b #$02 : STA.w OBSEL
    
    ; increment on writes to $2119
    LDA.b #$80 : STA.w VMAIN
    
    ; set bank of the source address (see below)
    LDA.b #FontGfx>>16 : STA.b Scrap02
    
    REP #$30
    
    ; vram target address is $7000 (word)
    LDA.w #$7000 : STA.w VMADDL
    
    ; $00[3] = $0E8000 (offset for the font data)
    LDA.w #FontGfx : STA.b Scrap00
    
    ; going to write 0x1000 bytes (0x800 words)
    LDX.w #FontGfxEnd-FontGfx/2-1
    
.nextWord

    ; read a word from the font data
    LDA.b [$00] : STA.w VMDATAL
    
    ; increment source address by 2
    INC.b Scrap00 : INC.b Scrap00
    
    DEX : BPL .nextWord
    
    SEP #$30
	JSL LoadFullItemTilesCredits

    RTL

LoadFullItemTilesCredits:
	; Based on CopyFontToVram(Bank00)
	; copies font graphics to VRAM (for BG3)

	; increment on writes to $2119
	LDA.b #$80 : STA.w VMAIN

	; set bank of the source address (see below)
	LDA.b #FileSelectNewGraphics>>16 : STA.b Scrap02

	REP #$30

	; vram target address is $8000 (word) (Wraps to start of VRAM on normal SNES, but using the correct address so it works on extended VRAM machines)
	LDA.w #$8000 : STA.w VMADDL

	; $00[3] = $0E8000 (offset for the font data)
	LDA.w #FileSelectNewGraphics : STA.b Scrap00

	; going to write 0x1000 bytes (0x800 words)
	LDX.w #$800-1

	.nextWord

	; read a word from the font data
	LDA.b [$00] : STA.w VMDATAL

	; increment source address by 2
	INC.b Scrap00 : INC.b Scrap00

	DEX : BPL .nextWord

	SEP #$30
    
    RTL
    
CheckFontTable:
    TAY
    PHB
    PHK
    PLB
    LDA.w FontTable,Y
    PLB
    RTL

NearEnding:
	STZ.w $012A ; disable triforce helper thread
	JSL LoadCustomHudPalette
	REP #$10
	JSL AltBufferTable_credits
	JSR DrawEndingItems
JML.l $00ec03 ; PaletteFilter_InitTheEndSprite

EndingItems:
	; This function is not strictly needed, simply updating the tracker
	; every frame, but it is useful for debuging, so should be left in.
	REP #$10
	JSR DrawEndingItems
	REP #$20
	LDX.b #$0E
RTL

DrawEndingItems:
	JSL DrawPlayerFile_credits
	JSL SetItemLayoutPriority
	SEP #$30
	LDA.b #$01 : STA.b NMISTRIPES
RTS

FontTable:
    incbin stats/fonttable.bin

CreditsStats:
incsrc stats/statConfig.asm
dw $FFFF

org $0eedd9
    JSL EndingItems

org $0eedaf
	JSL NearEnding

org $0EE651
    JSL LoadModifiedFont

org $0EE828
	JSL PreparePointer
	LDA.b [CreditsPtr],Y
	NOP
org $0EE83F
	LDA.b [CreditsPtr],Y
	NOP
org $0EE853
	LDA.b [CreditsPtr],Y
	NOP
    AND.w #$00ff
    ASL A
    JSL CheckFontTable
    
org $0ee86d
    JSL RenderCreditsStatCounter
    JMP.w AfterDeathCounterOutput
    
org $0ee8fd
    AfterDeathCounterOutput:
