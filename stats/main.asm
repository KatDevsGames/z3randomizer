lorom

!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

org $238000
incsrc stats/credits.asm

FontGfx:
incbin stats/font.gb
FontGfxEnd:

; Custom addresses. Most are arbitrary. Feel free to make sure they're okay or moving them elsewhere within ZP
!CreditsPtr = $7C   ; 3 bytes
!Temp = $B3         ; 2 bytes
!StatsBottom = $B5  ; 2 bytes
!StatsPtr = $B7     ; 3 bytes
!ValueLow = $BA     ; 2 bytes
!ValueHigh = $BC    ; 2 bytes
!Hours = $72        ; 2 bytes
!Minutes = $74      ; 2 bytes
!Seconds = $76      ; 2 bytes
!RemoveZero = $78   ; 2 bytes


; Original addresses
!LineNumber = $CA   ; 2 bytes

PreparePointer:
	LDA.w #$2300
	STA.b !CreditsPtr+1
	LDA.w #CreditsLineTable
	STA.b !CreditsPtr
	LDA [!CreditsPtr],Y
	STA.b !CreditsPtr
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

macro AddStat(address, type, shiftRight, bits, digits, xPos, lineNumber)
    db <xPos><<2|<type><<9|<lineNumber>>>8
    db <lineNumber>
    db <bits><<4|<shiftRight>
    db <digits><<5
    db $00
    dl <address>
endmacro

macro StripeStart(xPos, length)
    LDA $C8
    CLC
    ADC.w #<xPos>
    XBA
    STA $1002,x
    
    LDA.w #<length>*2-1
    XBA
    LDA #$0500
    STA $1004,x
endmacro

macro StripeTile()
    STA $1006,x
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
		STA $7F5003 : STA $7F5005 : STA $7F5006 ; clear digit storage
	PLA
	-
	CMP.w #10000 : !BLT +
	PHA : SEP #$20 : LDA $7F5003 : INC : STA $7F5003 : REP #$20 : PLA
	!SUB.w #10000 : BRA -
	+ -
	CMP.w #1000 : !BLT +
	PHA : SEP #$20 : LDA $7F5004 : INC : STA $7F5004 : REP #$20 : PLA
	!SUB.w #1000 : BRA -
	+ -
	CMP.w #100 : !BLT +
	PHA : SEP #$20 : LDA $7F5005 : INC : STA $7F5005 : REP #$20 : PLA
	!SUB.w #100 : BRA -
	+ -
	CMP.w #10 : !BLT +
	PHA : SEP #$20 : LDA $7F5006 : INC : STA $7F5006 : REP #$20 : PLA
	!SUB.w #10 : BRA -
	+ -
	CMP.w #1 : !BLT +
	PHA : SEP #$20 : LDA $7F5007 : INC : STA $7F5007 : REP #$20 : PLA
	!SUB.w #1 : BRA -
	+ 
	PLA
RTL

LastHexDigit: 
    TYA
    AND #$000F
    PHA
    TYA
    LSR #4
    TAY
    CLC
    LDA !StatsBottom
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
    STZ !StatsBottom
    CMP #$FFFF
    BEQ .noLine
    
    XBA
    AND #$01FF
    CMP !LineNumber
    BEQ .lineFound
    
    INC
    INC !StatsBottom
    CMP !LineNumber
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
    STZ <unitCounter>
?loop:
    LDA !ValueLow
    SEC
    SBC.w #<framesPerUnit>
    STA !Temp
    LDA !ValueHigh
    SBC.w #<framesPerUnit>>>16
    BCC ?end
    STA !ValueHigh
    LDA !Temp
    STA !ValueLow
    INC <unitCounter>
    BRA ?loop
?end:
endmacro

!ColonOffset = $83
!PeriodOffset = $80
!BlankTile = $883D

RenderCreditsStatCounter:
    PHB
    PHK
    PLB
    
    JSR FindLine
    BCS +
    BRL .endStats
+   
    
    ;   XXXX X00L   LLLL LLLL   BBBB SSSS   CCC- ----   ---- ----   AAAA AAAA   AAAA AAAA   AAAA AAAA
    
    ; == Determine stat type ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR
    AND #$0003          ; TT
    CMP.w #$0000
    BEQ .normalStat
    BRL .timeStat

.normalStat
    ; == Write Stripe header (VRAM address, i.e. tile coordinates) ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR #3
    AND #$001F          ; X XXXX
    CLC
    ADC $C8
    XBA
    STA $1002,x
    
    ; == Write Stripe header (Length of data) ==
    LDA.w #4*2-1    ; 4 tiles = 8 bytes
    XBA
    STA $1004,x
    PHX
    
    ; == Load tile base (upper or lower half of white two-line zero) ==
    LDA !StatsBottom
    BNE +
    LDA #$3D40
    BRA ++
+   LDA #$3D50
++  STA !Temp

    ; == Load the actual stat word ==
    LDA.w CreditsStats+5,y
    STA.b !StatsPtr
    LDA.w CreditsStats+6,y
    STA.b !StatsPtr+1
    LDA.b [!StatsPtr]
    STA !ValueLow
    
    ; == Shift value ==
    LDA.w CreditsStats+2,y;   CCC- ---- BBBB SSSS
    AND.w #$000F        ;   SSSS
    BEQ +
    TAX
    LDA !ValueLow
-   LSR
    DEX
    BNE -
    STA !ValueLow
+   
    ; == Mask value ==
    LDA.w CreditsStats+2,y;   CCC- ---- BBBB SSSS
    ;LSR #4
    ;AND.w #$000F        ;   BBBB
	LSR #3
	AND.w #$001E
    TAX
    LDA BitMasks,x
    AND !ValueLow
    STA !ValueLow
    
    ; == Cap value ==
    LDA.w CreditsStats+3,y;   ---- ---- CCC- ----
    LSR #5
    AND.w #$0007        ;   CCC
    BEQ +
    ASL : TAX
    LDA ValueCaps,x
    CMP !ValueLow
    !BGE +
    STA !ValueLow
+   
    ; == Display value ==
    LDA !ValueLow
    JSL HexToDecStats
    PLX
    STZ !RemoveZero
    
    LDA $7F5004
    AND #$00FF
    CMP !RemoveZero
    BNE +
    LDA !BlankTile
    BRA ++
+   DEC !RemoveZero
    CLC
    ADC !Temp
++  %StripeTile()
    
    LDA $7F5005
    AND #$00FF
    CMP !RemoveZero
    BNE +
    LDA !BlankTile
    BRA ++
+   DEC !RemoveZero
    CLC
    ADC !Temp
++  %StripeTile()
    
    LDA $7F5006
    AND #$00FF
    CMP !RemoveZero
    BNE +
    LDA !BlankTile
    BRA ++
+   DEC !RemoveZero
    CLC
    ADC !Temp
++  %StripeTile()
    
    LDA $7F5007
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    %StripeEnd()
.endStats

    ;JSR RenderLineNumber

    PLB
    RTL
    
.timeStat
    ; Output format: HH:MM:SS.FF
    
    ; == Write Stripe header (VRAM address, i.e. tile coordinates) ==
    LDA.w CreditsStats,y  ;   LLLL LLLL XXXX XTTL
    LSR #3
    AND #$001F          ; X XXXX
    CLC
    ADC $C8
    XBA
    STA $1002,x
    
    ; == Write Stripe header (Length of data) ==
    LDA.w #11*2-1    ; 11 tiles = 22 bytes
    XBA
    STA $1004,x
    PHX
    
    ; == Load the actual stat words ==
    LDA.w CreditsStats+5,y
    STA.b !StatsPtr
    LDA.w CreditsStats+6,y
    STA.b !StatsPtr+1
    LDA.b [!StatsPtr]
    STA !ValueLow
    INC !StatsPtr
    INC !StatsPtr
    LDA.b [!StatsPtr]
    STA !ValueHigh
    
    CMP.w #!MAX_FRAME_COUNT>>16+1
    !BGE ++
    
    ; == Convert total frames into hours, minutes, seconds and frames ==
    %CountUnits(!FRAMES_PER_HOUR, !Hours)
    %CountUnits(!FRAMES_PER_MINUTE, !Minutes)
    %CountUnits(!FRAMES_PER_SECOND, !Seconds)
    
    ; == Cap at 99:59:59.59 ==
    LDA !Hours
    CMP.w #100
    !BLT +
++  LDA.w #99
    STA !Hours
    LDA.w #59
    STA !Minutes
    STA !Seconds
    STA !ValueLow
+
    
    ; == Load tile base (upper or lower half of white two-line zero) ==
    LDA !StatsBottom
    BNE +
    LDA #$3D40
    BRA ++
+   LDA #$3D50
++  STA !Temp
    
    PLX
    
    ; == Display value ==
    LDA !Hours
    JSL HexToDecStats
    
    LDA $7F5006
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA $7F5007
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA.w #!ColonOffset
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA !Minutes
    JSL HexToDecStats
    LDA $7F5006
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA $7F5007
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA.w #!ColonOffset
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA !Seconds
    JSL HexToDecStats
    LDA $7F5006
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA $7F5007
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA.w #!PeriodOffset
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA !ValueLow
    JSL HexToDecStats
    LDA $7F5006
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    LDA $7F5007
    AND #$00FF
    CLC
    ADC !Temp
    %StripeTile()
    
    %StripeEnd()
    BRL .endStats
    
    
RenderLineNumber:
    %StripeStart(0, 3)
    
    STZ !StatsBottom
    LDA $CA
    TAY
    AND #$0001
    BEQ +
    DEY
    INC !StatsBottom
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
    LDA.b #$02 : STA $2101
    
    ; increment on writes to $2119
    LDA.b #$80 : STA $2115
    
    ; set bank of the source address (see below)
    LDA.b #FontGfx>>16 : STA $02
    
    REP #$30
    
    ; vram target address is $7000 (word)
    LDA.w #$7000 : STA $2116
    
    ; $00[3] = $0E8000 (offset for the font data)
    LDA.w #FontGfx : STA $00
    
    ; going to write 0x1000 bytes (0x800 words)
    LDX.w #FontGfxEnd-FontGfx/2-1
    
.nextWord

    ; read a word from the font data
    LDA [$00] : STA $2118
    
    ; increment source address by 2
    INC $00 : INC $00
    
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
    
FontTable:
    incbin stats/fonttable.bin

CreditsStats:
incsrc stats/statConfig.asm
dw $FFFF
    
org $0EE651
    JSL LoadModifiedFont

org $0EE828
	JSL PreparePointer
	LDA [!CreditsPtr],Y
	NOP
org $0EE83F
	LDA [!CreditsPtr],Y
	NOP
org $0EE853
	LDA [!CreditsPtr],Y
	NOP
    AND.w #$00ff
    ASL A
    JSL CheckFontTable
    
org $0ee86d
    JSL RenderCreditsStatCounter
    JMP.w AfterDeathCounterOutput
    
org $0ee8fd
    AfterDeathCounterOutput: