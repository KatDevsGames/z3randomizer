;===================================================================================================
; Up here at the top of ROM for easy viewing
;===================================================================================================
ItemReceiptGraphicsROM:
	; we need some empty space here so that 0000 can mean nothing
	fillbyte $00 : fill 32
	incbin "data/customitems.4bpp"

;===================================================================================================
; Get the item's graphic from WRAM/ROM
; Bit 7 set indicates an explicit WRAM address
; Bit 7 reset indicates an offset into the ROM buffer
;===================================================================================================
;---------------------------------------------------------------------------------------------------
; Enters with A for parameter
;---------------------------------------------------------------------------------------------------
TransferItemReceiptToBuffer_using_GraphicsID:
	PHP
	PHB

	REP #$30
	PHX
	PHY

	SEP #$30
	LDX.b #$00

.find_reverse
	CMP.l ItemReceipts_graphics,X
	BEQ .found

	INX
	BNE .find_reverse

.found
	TXA
	REP #$30
	BRA ++

;===================================================================================================

TransferRupeesProperly:
	PHP
	PHB

	REP #$31
	PHX
	PHY

	AND.w #$00FF
	SBC.w #$0023

	XBA
	LSR
	LSR
	LSR
	ADC.w #BigDecompressionBuffer+$800

	BRA TransferItemReceiptToBuffer_using_ExplicitBufferAddress

;===================================================================================================

TransferItemReceiptToBuffer_using_ReceiptID:
	PHP
	PHB

	REP #$30
	PHX
	PHY

++	AND.w #$00FF
	ASL
	TAX
	LDA.l ItemReceiptGraphicsOffsets,X
	BMI TransferItemReceiptToBuffer_using_ExplicitBufferAddress

.rom_address
	ADC.w #ItemReceiptGraphicsROM
	PHK
	BRA .continue

#TransferItemReceiptToBuffer_using_ExplicitBufferAddress:
	PEA.w $7F7F
	PLB

.continue
	PLB
	TAY
	LDX.w #62

.next_write
	LDA.w $003E,Y
	STA.l ItemGetGFX+$00,X

	LDA.w $023E,Y
	STA.l ItemGetGFX+$40,X

	DEY
	DEY
	DEX
	DEX
	BPL .next_write


	REP #$30
	PLY
	PLX
	PLB
	PLP
	RTL

;===================================================================================================

TransferItemReceiptToVRAM:
	REP #$21
	SEP #$10

	LDA.w ItemGFXPtr
	BEQ .exit
	BMI .wram_address

.rom_address
	ADC.w #ItemReceiptGraphicsROM

	LDX.b #ItemReceiptGraphicsROM>>16

.set_address
	STA.w $4202
	ADC.w #$0200
	STA.w $4212

	STX.w $4304
	STX.w $4314

	LDX.b #$80
	STX.w $2115

	LDA.w #$1801
	STA.w $4300
	STA.w $4310

	LDA.w #$0040
	STA.w $4305
	STA.w $4315

	LDA.w ItemGFXTgt
	STA.w $2116

	LDX.b #$01
	STX.w $420B

	ADC.w #$0100
	STA.w $2116

	INX
	STX.w $420B

	STZ.w ItemGFXPtr

.exit
	RTL

.wram_address
	LDX.b #$7F
	BRA .set_address

;===================================================================================================
; Decompress everything at the start of the game
;===================================================================================================
DecompBufferOffset = $18
DecompTestByte = $04
DecompCommand = $02
DecompSize = $00
DecompTileCount = $1A
DecompSaveY = $1A
Decomp3BPPScratch = $20

;===================================================================================================

DecompressAllItemGraphics:
	PHP
	PHB
	PHD

	REP #$38

	; Stack change for safety
	TSX

	LDA.w #$1400
	TCS

	PHX

	; direct page change for speed
	LDA.w #$1200
	TCD

	STZ.b DecompBufferOffset

	SEP #$34

	STA.l $4200 ; already 0 from the LDA above

	LDX.b #$5D+$73 : JSR FastSpriteDecomp
	LDX.b #$5C+$73 : JSR FastSpriteDecomp
	LDX.b #$5B+$73 : JSR FastSpriteDecomp
	LDX.b #$5A+$73 : JSR FastSpriteDecomp

	REP #$30
	PLX
	TXS

	SEP #$20

	LDA.b #$81
	STA.l $4200


	PLD
	PLB
	PLP

	RTL

;===================================================================================================
; I normally hate macros like this... but I don't feel like constantly rewriting this
;===================================================================================================
macro GetNextByte()
	LDA.w $0000,Y
	INY
	BNE ?++

	; Y pulls more than it needs, but that's fine
	; the high byte should only be affected if we somehow have FF as our bank
	; and if that happens, we have other problems
	PHB
	PLY
	INY
	PHY
	PLB

	LDY.w #$8000

?++
endmacro

;===================================================================================================
; There's no long vanilla routine, and we're going to make heavy use of this
; so might as well rewrite it to be fast
;===================================================================================================
FastSpriteDecomp:
	SEP #$30

	LDA.l $00CFC0,X : PHA : PLB ; bank
	LDA.l $00D09F,X : XBA ; high
	LDA.l $00D17E,X ; low

	REP #$10

	TAY

	LDX.w #$0000

.next_command
	%GetNextByte()

	CMP.b #$FF
	BNE .continue

;---------------------------------------------------------------------------------------------------

	JMP Unrolled3BPPConvert

;---------------------------------------------------------------------------------------------------

.continue
	CMP.b #$E0
	BCS .expanded

	STA.b DecompTestByte

	REP #$20

	AND.w #$001F

	BRA .normal

;---------------------------------------------------------------------------------------------------
; Putting some commands up here for branch distance
;---------------------------------------------------------------------------------------------------
.nonrepeating
	%GetNextByte()
	STA.l DecompBuffer2,X

	INX

	DEC.b DecompSize+0
	BNE .nonrepeating

	DEC.b DecompSize+1
	BPL .nonrepeating

	BRA .next_command

;---------------------------------------------------------------------------------------------------

.repeating
	%GetNextByte()

	STY.b DecompSaveY

	LDY.b DecompSize

.next_repeating
	STA.l DecompBuffer2,X

	INX
	DEY
	BNE .next_repeating

	LDY.b DecompSaveY
	BRA .next_command

;---------------------------------------------------------------------------------------------------
; Rest of command handling
;---------------------------------------------------------------------------------------------------
.expanded
	STA.b DecompCommand

	ASL
	ASL
	ASL
	AND.b #$E0
	STA.b DecompTestByte

	LDA.b DecompCommand
	AND.b #$03
	XBA

	%GetNextByte()

	REP #$20

;---------------------------------------------------------------------------------------------------

.normal
	INC
	STA.b DecompSize

	SEP #$20

	LDA.b DecompTestByte

	AND.b #$E0
	BEQ .nonrepeating
	BMI .copy

	ASL
	BPL .repeating

	ASL
	BPL .repeating_word

;---------------------------------------------------------------------------------------------------

.incremental
	%GetNextByte()

	STY.b DecompSaveY

	LDY.b DecompSize

.next_incremental
	STA.l DecompBuffer2,X

	INC
	INX

	DEY
	BNE .next_incremental

	LDY.b DecompSaveY
	JMP .next_command

;---------------------------------------------------------------------------------------------------

.repeating_word
	JSR .get_next_word
	REP #$20

	STY.b DecompSaveY

	LDY.b DecompSize

.next_word
	STA.l DecompBuffer2,X

	INX
	DEY
	BEQ .done_restore_y

	INX
	DEY
	BNE .next_word

.done_restore_y
	SEP #$20

	LDY.b DecompSaveY

	JMP .next_command

;---------------------------------------------------------------------------------------------------

.copy
	JSR .get_next_word

	STY.b DecompSaveY

	TAY

	PHB
	LDA.b #$7F
	PHA
	PLB

.next_copy
	LDA.w DecompBuffer2,Y
	STA.w DecompBuffer2,X

	INX
	INY

	DEC.b DecompSize+0
	BNE .next_copy

	DEC.b DecompSize+1
	BPL .next_copy

	PLB

	LDY.b DecompSaveY

	JMP .next_command

;---------------------------------------------------------------------------------------------------
; These are only used once per command, so I'm fine with letting them be a JSR I guess
;---------------------------------------------------------------------------------------------------
.get_next_word
	%GetNextByte()
	XBA

	%GetNextByte()
	XBA

	RTS

;===================================================================================================
; More macros, because lazy
;===================================================================================================

macro DoPlanesA(offset)
	LDA.w DecompBuffer2+<offset>+<offset>,Y
	STA.w BigDecompressionBuffer+<offset>+<offset>,X

	ORA.w DecompBuffer2+<offset>+<offset>-1,Y
	AND.w #$FF00
	STA.b Decomp3BPPScratch

	LDA.w DecompBuffer2+$10+<offset>,Y
	AND.w #$00FF
	TSB.b Decomp3BPPScratch

	XBA
	ORA.b Decomp3BPPScratch
	STA.w BigDecompressionBuffer+$10+<offset>+<offset>,X

endmacro

;===================================================================================================

Unrolled3BPPConvert:
	LDA.b #$7F
	PHA
	PLB

	REP #$21

	LDY.w #$0000
	LDX.b DecompBufferOffset

.next_3bpp_tile
	%DoPlanesA(0) ; 8 times
	%DoPlanesA(1)
	%DoPlanesA(2)
	%DoPlanesA(3)
	%DoPlanesA(4)
	%DoPlanesA(5)
	%DoPlanesA(6)
	%DoPlanesA(7)

	; carry will always be clear
	; don't worry
	TXA
	ADC.w #32
	TAX

	; just trust me
	TYA
	ADC.w #24
	TAY

	CMP.w #24*64
	BCS .done

	JMP .next_3bpp_tile

.done
	STX.b DecompBufferOffset
	SEP #$30

	RTS

;===================================================================================================

ItemReceiptGraphicsOffsets:
	dw $0860                               ; 00 - Fighter sword
	dw BigDecompressionBuffer+$11C0        ; 01 - Master sword
	dw BigDecompressionBuffer+$11C0        ; 02 - Tempered sword
	dw BigDecompressionBuffer+$11C0        ; 03 - Butter sword
	dw BigDecompressionBuffer+$09E0        ; 04 - Fighter shield
	dw BigDecompressionBuffer+$1940        ; 05 - Fire shield
	dw BigDecompressionBuffer+$0C80        ; 06 - Mirror shield
	dw BigDecompressionBuffer+$1C80        ; 07 - Fire rod
	dw BigDecompressionBuffer+$1C80        ; 08 - Ice rod
	dw BigDecompressionBuffer+$1CA0        ; 09 - Hammer
	dw BigDecompressionBuffer+$1C60        ; 0A - Hookshot
	dw BigDecompressionBuffer+$1C00        ; 0B - Bow
	dw BigDecompressionBuffer+$1DE0        ; 0C - Boomerang
	dw BigDecompressionBuffer+$1CC0        ; 0D - Powder
	dw BigDecompressionBuffer+$09A0        ; 0E - Bottle refill (bee)
	dw BigDecompressionBuffer+$1440        ; 0F - Bombos
	dw BigDecompressionBuffer+$1400        ; 10 - Ether
	dw BigDecompressionBuffer+$1480        ; 11 - Quake
	dw BigDecompressionBuffer+$10C0        ; 12 - Lamp
	dw BigDecompressionBuffer+$11E0        ; 13 - Shovel
	dw BigDecompressionBuffer+$0C40        ; 14 - Flute
	dw BigDecompressionBuffer+$1C40        ; 15 - Somaria
	dw BigDecompressionBuffer+$14C0        ; 16 - Bottle
	dw BigDecompressionBuffer+$0C00        ; 17 - Heart piece
	dw BigDecompressionBuffer+$1C40        ; 18 - Byrna
	dw BigDecompressionBuffer+$1100        ; 19 - Cape
	dw BigDecompressionBuffer+$1040        ; 1A - Mirror
	dw BigDecompressionBuffer+$1D40        ; 1B - Glove
	dw BigDecompressionBuffer+$1D40        ; 1C - Mitts
	dw BigDecompressionBuffer+$1D80        ; 1D - Book
	dw BigDecompressionBuffer+$1000        ; 1E - Flippers
	dw BigDecompressionBuffer+$1180        ; 1F - Pearl
	dw BigDecompressionBuffer+$08A0        ; 20 - Crystal
	dw BigDecompressionBuffer+$0860        ; 21 - Net
	dw BigDecompressionBuffer+$1900        ; 22 - Blue mail
	dw BigDecompressionBuffer+$1900        ; 23 - Red mail
	dw BigDecompressionBuffer+$1DC0        ; 24 - Small key
	dw BigDecompressionBuffer+$1140        ; 25 - Compbutt
	dw BigDecompressionBuffer+$18C0        ; 26 - Heart container from 4/4
	dw BigDecompressionBuffer+$1080        ; 27 - Bomb
	dw BigDecompressionBuffer+$1840        ; 28 - 3 bombs
	dw BigDecompressionBuffer+$1540        ; 29 - Mushroom
	dw BigDecompressionBuffer+$1DE0        ; 2A - Red boomerang
	dw BigDecompressionBuffer+$1500        ; 2B - Full bottle (red)
	dw BigDecompressionBuffer+$1500        ; 2C - Full bottle (green)
	dw BigDecompressionBuffer+$1500        ; 2D - Full bottle (blue)
	dw BigDecompressionBuffer+$1500        ; 2E - Potion refill (red)
	dw BigDecompressionBuffer+$1500        ; 2F - Potion refill (green)
	dw BigDecompressionBuffer+$1500        ; 30 - Potion refill (blue)
	dw BigDecompressionBuffer+$1D00        ; 31 - 10 bombs
	dw BigDecompressionBuffer+$15C0        ; 32 - Big key
	dw BigDecompressionBuffer+$1580        ; 33 - Map
	dw BigDecompressionBuffer+$0800        ; 34 - 1 rupee
	dw BigDecompressionBuffer+$0800        ; 35 - 5 rupees
	dw BigDecompressionBuffer+$0800        ; 36 - 20 rupees
	dw BigDecompressionBuffer+$0080        ; 37 - Green pendant
	dw BigDecompressionBuffer+$0080        ; 38 - Blue pendant
	dw BigDecompressionBuffer+$0080        ; 39 - Red pendant
	dw BigDecompressionBuffer+$0920        ; 3A - Tossed bow
	dw BigDecompressionBuffer+$08E0        ; 3B - Silvers
	dw BigDecompressionBuffer+$09A0        ; 3C - Full bottle (bee)
	dw BigDecompressionBuffer+$0960        ; 3D - Full bottle (fairy)
	dw BigDecompressionBuffer+$18C0        ; 3E - Boss heart
	dw BigDecompressionBuffer+$18C0        ; 3F - Sanc heart
	dw BigDecompressionBuffer+$0D20        ; 40 - 100 rupees
	dw BigDecompressionBuffer+$0D60        ; 41 - 50 rupees
	dw BigDecompressionBuffer+$0CC0        ; 42 - Heart
	dw BigDecompressionBuffer+$0DD0        ; 43 - Arrow
	dw BigDecompressionBuffer+$1880        ; 44 - 10 arrows
	dw BigDecompressionBuffer+$0CE0        ; 45 - Small magic
	dw BigDecompressionBuffer+$0DA0        ; 46 - 300 rupees
	dw BigDecompressionBuffer+$0000        ; 47 - 20 rupees green
	dw BigDecompressionBuffer+$09A0        ; 48 - Full bottle (good bee)
	dw BigDecompressionBuffer+$1C20        ; 49 - Tossed fighter sword
	dw BigDecompressionBuffer+$09A0        ; 4A - Bottle refill (good bee)
	dw BigDecompressionBuffer+$0040        ; 4B - Boots

	; Rando items
	dw $04A0                               ; 4C - Bomb capacity (50)
	dw $05A0                               ; 4D - Arrow capacity (70)
	dw $01A0                               ; 4E - 1/2 magic
	dw $01E0                               ; 4F - 1/4 magic
	dw $0                                  ; 50 - Safe master sword
	dw $0420                               ; 51 - Bomb capacity (+5)
	dw $0460                               ; 52 - Bomb capacity (+10)
	dw $0520                               ; 53 - Arrow capacity (+5)
	dw $0560                               ; 54 - Arrow capacity (+10)
	dw $0                                  ; 55 - Programmable item 1
	dw $0                                  ; 56 - Programmable item 2
	dw $0                                  ; 57 - Programmable item 3
	dw $0                                  ; 58 - Upgrade-only silver arrows
	dw $0                                  ; 59 - Rupoor
	dw $0020                               ; 5A - Nothing
	dw $0                                  ; 5B - Red clock
	dw $0                                  ; 5C - Blue clock
	dw $0                                  ; 5D - Green clock
	dw $0                                  ; 5E - Progressive sword
	dw $0                                  ; 5F - Progressive shield
	dw $0                                  ; 60 - Progressive armor
	dw $0                                  ; 61 - Progressive glove
	dw $0                                  ; 62 - RNG pool item (single)
	dw $0                                  ; 63 - RNG pool item (multi)
	dw $0                                  ; 64 - Progressive bow
	dw $0                                  ; 65 - Progressive bow
	dw $0                                  ; 66 - 
	dw $0                                  ; 67 - 
	dw $0                                  ; 68 - 
	dw $0                                  ; 69 - 
	dw $0060                               ; 6A - Triforce
	dw $0                                  ; 6B - Power star
	dw $0                                  ; 6C - 
	dw $0                                  ; 6D - Server request item
	dw $0                                  ; 6E - Server request item (dungeon drop)
	dw $0                                  ; 6F - 

	dw BigDecompressionBuffer+$1580        ; 70 - Map of Light World
	dw BigDecompressionBuffer+$1580        ; 71 - Map of Dark World
	dw BigDecompressionBuffer+$1580        ; 72 - Map of Ganon's Tower
	dw BigDecompressionBuffer+$1580        ; 73 - Map of Turtle Rock
	dw BigDecompressionBuffer+$1580        ; 74 - Map of Thieves' Town
	dw BigDecompressionBuffer+$1580        ; 75 - Map of Tower of Hera
	dw BigDecompressionBuffer+$1580        ; 76 - Map of Ice Palace
	dw BigDecompressionBuffer+$1580        ; 77 - Map of Skull Woods
	dw BigDecompressionBuffer+$1580        ; 78 - Map of Misery Mire
	dw BigDecompressionBuffer+$1580        ; 79 - Map of Dark Palace
	dw BigDecompressionBuffer+$1580        ; 7A - Map of Swamp Palace
	dw BigDecompressionBuffer+$1580        ; 7B - Map of Agahnim's Tower
	dw BigDecompressionBuffer+$1580        ; 7C - Map of Desert Palace
	dw BigDecompressionBuffer+$1580        ; 7D - Map of Eastern Palace
	dw BigDecompressionBuffer+$1580        ; 7E - Map of Hyrule Castle
	dw BigDecompressionBuffer+$1580        ; 7F - Map of Sewers

	dw BigDecompressionBuffer+$1140        ; 80 - Compass of Light World
	dw BigDecompressionBuffer+$1140        ; 81 - Compass of Dark World
	dw BigDecompressionBuffer+$1140        ; 82 - Compass of Ganon's Tower
	dw BigDecompressionBuffer+$1140        ; 83 - Compass of Turtle Rock
	dw BigDecompressionBuffer+$1140        ; 84 - Compass of Thieves' Town
	dw BigDecompressionBuffer+$1140        ; 85 - Compass of Tower of Hera
	dw BigDecompressionBuffer+$1140        ; 86 - Compass of Ice Palace
	dw BigDecompressionBuffer+$1140        ; 87 - Compass of Skull Woods
	dw BigDecompressionBuffer+$1140        ; 88 - Compass of Misery Mire
	dw BigDecompressionBuffer+$1140        ; 89 - Compass of Dark Palace
	dw BigDecompressionBuffer+$1140        ; 8A - Compass of Swamp Palace
	dw BigDecompressionBuffer+$1140        ; 8B - Compass of Agahnim's Tower
	dw BigDecompressionBuffer+$1140        ; 8C - Compass of Desert Palace
	dw BigDecompressionBuffer+$1140        ; 8D - Compass of Eastern Palace
	dw BigDecompressionBuffer+$1140        ; 8E - Compass of Hyrule Castle
	dw BigDecompressionBuffer+$1140        ; 8F - Compass of Sewers
	dw $0                                  ; 90 - Skull key
	dw $0                                  ; 91 - Reserved

	dw BigDecompressionBuffer+$15C0        ; 92 - Big key of Ganon's Tower
	dw BigDecompressionBuffer+$15C0        ; 93 - Big key of Turtle Rock
	dw BigDecompressionBuffer+$15C0        ; 94 - Big key of Thieves' Town
	dw BigDecompressionBuffer+$15C0        ; 95 - Big key of Tower of Hera
	dw BigDecompressionBuffer+$15C0        ; 96 - Big key of Ice Palace
	dw BigDecompressionBuffer+$15C0        ; 97 - Big key of Skull Woods
	dw BigDecompressionBuffer+$15C0        ; 98 - Big key of Misery Mire
	dw BigDecompressionBuffer+$15C0        ; 99 - Big key of Dark Palace
	dw BigDecompressionBuffer+$15C0        ; 9A - Big key of Swamp Palace
	dw BigDecompressionBuffer+$15C0        ; 9B - Big key of Agahnim's Tower
	dw BigDecompressionBuffer+$15C0        ; 9C - Big key of Desert Palace
	dw BigDecompressionBuffer+$15C0        ; 9D - Big key of Eastern Palace
	dw BigDecompressionBuffer+$15C0        ; 9E - Big key of Hyrule Castle
	dw BigDecompressionBuffer+$15C0        ; 9F - Big key of Sewers

	dw BigDecompressionBuffer+$1DC0        ; A0 - Small key of Sewers
	dw BigDecompressionBuffer+$1DC0        ; A1 - Small key of Hyrule Castle
	dw BigDecompressionBuffer+$1DC0        ; A2 - Small key of Eastern Palace
	dw BigDecompressionBuffer+$1DC0        ; A3 - Small key of Desert Palace
	dw BigDecompressionBuffer+$1DC0        ; A4 - Small key of Agahnim's Tower
	dw BigDecompressionBuffer+$1DC0        ; A5 - Small key of Swamp Palace
	dw BigDecompressionBuffer+$1DC0        ; A6 - Small key of Dark Palace
	dw BigDecompressionBuffer+$1DC0        ; A7 - Small key of Misery Mire
	dw BigDecompressionBuffer+$1DC0        ; A8 - Small key of Skull Woods
	dw BigDecompressionBuffer+$1DC0        ; A9 - Small key of Ice Palace
	dw BigDecompressionBuffer+$1DC0        ; AA - Small key of Tower of Hera
	dw BigDecompressionBuffer+$1DC0        ; AB - Small key of Thieves' Town
	dw BigDecompressionBuffer+$1DC0        ; AC - Small key of Turtle Rock
	dw BigDecompressionBuffer+$1DC0        ; AD - Small key of Ganon's Tower
	dw $0                                  ; AE - Reserved
	dw BigDecompressionBuffer+$1DC0        ; AF - Generic small key

	dw $0                                  ; B0 - 
	dw $0                                  ; B1 - 
	dw $0                                  ; B2 - 
	dw $0                                  ; B3 - 
	dw $0                                  ; B4 - 
	dw $0                                  ; B5 - 
	dw $0                                  ; B6 - 
	dw $0                                  ; B7 - 
	dw $0                                  ; B8 - 
	dw $0                                  ; B9 - 
	dw $0                                  ; BA - 
	dw $0                                  ; BB - 
	dw $0                                  ; BC - 
	dw $0                                  ; BD - 
	dw $0                                  ; BE - 
	dw $0                                  ; BF - 
	dw $0                                  ; C0 - 
	dw $0                                  ; C1 - 
	dw $0                                  ; C2 - 
	dw $0                                  ; C3 - 
	dw $0                                  ; C4 - 
	dw $0                                  ; C5 - 
	dw $0                                  ; C6 - 
	dw $0                                  ; C7 - 
	dw $0                                  ; C8 - 
	dw $0                                  ; C9 - 
	dw $0                                  ; CA - 
	dw $0                                  ; CB - 
	dw $0                                  ; CC - 
	dw $0                                  ; CD - 
	dw $0                                  ; CE - 
	dw $0                                  ; CF - 
	dw $0                                  ; D0 - 
	dw $0                                  ; D1 - 
	dw $0                                  ; D2 - 
	dw $0                                  ; D3 - 
	dw $0                                  ; D4 - 
	dw $0                                  ; D5 - 
	dw $0                                  ; D6 - 
	dw $0                                  ; D7 - 
	dw $0                                  ; D8 - 
	dw $0                                  ; D9 - 
	dw $0                                  ; DA - 
	dw $0                                  ; DB - 
	dw $0                                  ; DC - 
	dw $0                                  ; DD - 
	dw $0                                  ; DE - 
	dw $0                                  ; DF - 
	dw $0                                  ; E0 - 
	dw $0                                  ; E1 - 
	dw $0                                  ; E2 - 
	dw $0                                  ; E3 - 
	dw $0                                  ; E4 - 
	dw $0                                  ; E5 - 
	dw $0                                  ; E6 - 
	dw $0                                  ; E7 - 
	dw $0                                  ; E8 - 
	dw $0                                  ; E9 - 
	dw $0                                  ; EA - 
	dw $0                                  ; EB - 
	dw $0                                  ; EC - 
	dw $0                                  ; ED - 
	dw $0                                  ; EE - 
	dw $0                                  ; EF - 
	dw $0                                  ; F0 - 
	dw $0                                  ; F1 - 
	dw $0                                  ; F2 - 
	dw $0                                  ; F3 - 
	dw $0                                  ; F4 - 
	dw $0                                  ; F5 - 
	dw $0                                  ; F6 - 
	dw $0                                  ; F7 - 
	dw $0                                  ; F8 - 
	dw $0                                  ; F9 - 
	dw $0                                  ; FA - 
	dw $0                                  ; FB - 
	dw $0                                  ; FC - 
	dw $0                                  ; FD - 
	dw $0                                  ; FE - Server request (async)
	dw $0                                  ; FF - 

;===================================================================================================
