;===================================================================================================

OWWriteSize = $00
OWWriteIncrement = $02
OWWriteTile = $06
OWWriteCommand = $08

;---------------------------------------------------------------------------------------------------

function OWW_RLESize(s) = s<<8

!OWW_STOP             = $8000
!OWW_END              = $FFFF

!OWW_SKIP             = $FFFF

!OWW_Vertical         = $0080
!OWW_Horizontal       = $0000

;===================================================================================================

Overworld_LoadNewTiles:
	LDA.b OverworldIndex
	CMP.w #$0080
	BCS .exit

	ASL
	TAX

	LDA.l OverworldMapChangePointers,X
	BNE .do_overlay

.exit
	LDX.w #$001E
	LDA.w #$0DBE

	RTL

.end
	PLB
	BRA .exit

.do_overlay
	PHB
	PHK
	PLB

	; give Y the pointer to our data
	TAY

.next_tile
	; format:
	;   dw <tile>, <pos>
	; or if bit 15 is set
	;   dw <command>, <params>...
	; commands are:
	;   1sss ssss dccc cccc
	;     s - size (if applicable)
	;     d - direction (if applicable)
	;     c - command id
	;  FFFF is end
	LDA.w $0000,Y
	INY
	INY
	TAX
	BMI .command

	LDX.w $0000,Y
	STA.l $7E0000,X

	INY
	INY

	BRA .next_tile

	; when using commands, list parameters will never have bit-15 set
	; so we use that as our sentinel in data lists
	; we could encode the size for everything
	; but that makes adjustments more burdensome
.command
	CMP.w #!OWW_END
	BEQ .end

	STA.b OWWriteCommand

	AND.w #$007F
	ASL
	TAX

	JSR (.command_vectors,X)

	BRA .next_tile

.command_vectors
	; dw !OWW_Stripe|!OWW_<direction>
	; dw <start>
	; dw <tile1>, <tile2>, ... <tileN>|!OWW_STOP
	;    use !SKIP to not place a tile but continue the stripe
	!OWW_Stripe                    = $8000
	dw .stripe                      ; 00

	; dw !OWW_StripeRLE|!OWW_<direction>|RLESize(<size>)
	; dw <tile>, <start>
	!OWW_StripeRLE                 = $8001
	dw .stripe_rle                  ; 01

	; dw !OWW_StripeRLEINC|!OWW_<direction>|RLESize(<size>)
	; dw <tile>, <start>
	!OWW_StripeRLEINC              = $8002
	dw .stripe_rle_inc              ; 02

	; dw !OWW_ArbTileCopy
	; dw <tile>
	; dw <pos1>, <pos2>, ... <posN>|!OWW_STOP
	!OWW_ArbTileCopy               = $8003
	dw .arbitrary_tile_copy         ; 03

	dw .nothing                     ; 04
	dw .nothing                     ; 05
	dw .nothing                     ; 06
	dw .nothing                     ; 07
	dw .nothing                     ; 08
	dw .nothing                     ; 09
	dw .nothing                     ; 0A
	dw .nothing                     ; 0B
	dw .nothing                     ; 0C

	; dw !OWW_SkipIfInverted, <address>
	;    skips to <address> when inverted mode
	!OWW_SkipIfInverted            = $800D
	dw .inverted_skip               ; 0D

	; dw !OWW_SkipIfNotInverted, <address>
	;    skips to <address> when not inverted
	!OWW_SkipIfNotInverted         = $800E
	dw .inverted_block              ; 0E

	; dw !OWW_InvertedOnly
	;    cancels everything if not inverted
	!OWW_InvertedOnly              = $800F
	dw .inverted_only               ; 0F

	; dw !OWW_CustomCommand, <vector>
	!OWW_CustomCommand             = $8010
	dw .custom_command              ; 10

	dw .nothing                     ; 11
	dw .nothing                     ; 12
	dw .nothing                     ; 13
	dw .nothing                     ; 14
	dw .nothing                     ; 15
	dw .nothing                     ; 16
	dw .nothing                     ; 17
	dw .nothing                     ; 18
	dw .nothing                     ; 19

;---------------------------------------------------------------------------------------------------

.custom_command
	TYX

	INY
	INY

	JMP.w ($0000,X)

;---------------------------------------------------------------------------------------------------

.inverted_skip
	LDX.w $0000,Y

	INY
	INY

	LDA.l InvertedMode
	AND.w #$00FF
	BEQ .dont_change_inverted

	TXY

.nothing
	RTS

;---------------------------------------------------------------------------------------------------

.inverted_block
	LDX.w $0000,Y
	INY
	INY
	BRA .check_inverted

#ReliableOWWSentinel:
	dw !OWW_END

.inverted_only
	LDX.w #ReliableOWWSentinel

.check_inverted
	LDA.l InvertedMode
	AND.w #$00FF
	BNE .dont_change_inverted

	TXY

.dont_change_inverted
	RTS

;---------------------------------------------------------------------------------------------------

.get_increment
	LDA.b OWWriteCommand
	AND.w #$0080
	BNE .vertical_increment

	LDA.w #$0002

.vertical_increment
	STA.b OWWriteIncrement

	RTS

;---------------------------------------------------------------------------------------------------

.stripe
	JSR .get_increment

	LDX.w $0000,Y

	BRA ++ ; to increment at start of loop properly

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

++	INY
	INY

	LDA.w $0000,Y
	BMI .end_stripe_maybe

	STA.l $7E0000,X
	BRA --

.end_stripe_maybe
	CMP.w #!OWW_SKIP ; just skip, so we can have fewer discontinuous commands
	BEQ --

	AND.w #$7FFF
	STA.l $7E0000,X

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.stripe_rle_inc
	JSR .get_increment
	JSR .get_rle_size_and_tile

	LDX.w $0000,Y
	BRA ++

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

	LDA.b OWWriteTile
	INC
	STA.b OWWriteTile

++	STA.l $7E0000,X

	DEC.b OWWriteSize
	BNE --

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.get_rle_size_and_tile
	LDA.b OWWriteCommand+1
	AND.w #$007F
	STA.b OWWriteSize

	LDA.w $0000,Y
	STA.b OWWriteTile

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

.stripe_rle
	JSR .get_increment
	JSR .get_rle_size_and_tile

	LDX.w $0000,Y
	BRA ++

--	TXA
	CLC
	ADC.b OWWriteIncrement
	TAX

	LDA.b OWWriteTile

++	STA.l $7E0000,X

	DEC.b OWWriteSize
	BNE --

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------
; Don't use SKIP with this, since that's not really meaningful anyways...
;---------------------------------------------------------------------------------------------------
.arbitrary_tile_copy
	LDA.w $0000,Y

--	INY
	INY

	LDX.w $0000,Y
	BMI .last_arb

	STA.l $7E0000,X
	BRA --

.last_arb
	PHA

	TXA
	AND.w #$7FFF
	TAX

	PLA

	STA.l $7E0000,X

	INY
	INY

	RTS

;---------------------------------------------------------------------------------------------------

;===================================================================================================

OverworldMapChangePointers:
	; light world
	dw $0000      ; 00
	dw $0000      ; 01
	dw $0000      ; 02
	dw .map03     ; 03
	dw $0000      ; 04
	dw .map05     ; 05
	dw $0000      ; 06
	dw .map07     ; 07
	dw $0000      ; 08
	dw $0000      ; 09
	dw $0000      ; 0A
	dw $0000      ; 0B
	dw $0000      ; 0C
	dw $0000      ; 0D
	dw .map0E     ; 0E
	dw $0000      ; 0F
	dw .map10     ; 10
	dw $0000      ; 11
	dw $0000      ; 12
	dw $0000      ; 13
	dw .map14     ; 14
	dw $0000      ; 15
	dw $0000      ; 16
	dw $0000      ; 17
	dw $0000      ; 18
	dw $0000      ; 19
	dw $0000      ; 1A
	dw .map1B     ; 1B
	dw $0000      ; 1C
	dw $0000      ; 1D
	dw $0000      ; 1E
	dw $0000      ; 1F
	dw $0000      ; 20
	dw $0000      ; 21
	dw $0000      ; 22
	dw $0000      ; 23
	dw $0000      ; 24
	dw $0000      ; 25
	dw $0000      ; 26
	dw $0000      ; 27
	dw $0000      ; 28
	dw .map29     ; 29
	dw $0000      ; 2A
	dw $0000      ; 2B
	dw $0000      ; 2C
	dw $0000      ; 2D
	dw $0000      ; 2E
	dw $0000      ; 2F
	dw .map30     ; 30
	dw .map31     ; 31
	dw .map32     ; 32
	dw .map33     ; 33
	dw $0000      ; 34
	dw .map35     ; 35
	dw $0000      ; 36
	dw $0000      ; 37
	dw .map38     ; 38
	dw $0000      ; 39
	dw .map3A     ; 3A
	dw $0000      ; 3B
	dw .map3C     ; 3C
	dw $0000      ; 3D
	dw $0000      ; 3E
	dw $0000      ; 3F

	; dark world
	dw $0000      ; 40
	dw $0000      ; 41
	dw $0000      ; 42
	dw .map43     ; 43
	dw .map44     ; 44
	dw .map45     ; 45
	dw $0000      ; 46
	dw .map47     ; 47
	dw $0000      ; 48
	dw $0000      ; 49
	dw $0000      ; 4A
	dw $0000      ; 4B
	dw $0000      ; 4C
	dw $0000      ; 4D
	dw .map4E     ; 4E
	dw $0000      ; 4F
	dw .map50     ; 50
	dw $0000      ; 51
	dw $0000      ; 52
	dw $0000      ; 53
	dw .map54     ; 54
	dw $0000      ; 55
	dw $0000      ; 56
	dw $0000      ; 57
	dw $0000      ; 58
	dw $0000      ; 59
	dw $0000      ; 5A
	dw .map5B     ; 5B
	dw $0000      ; 5C
	dw $0000      ; 5D
	dw $0000      ; 5E
	dw $0000      ; 5F
	dw $0000      ; 60
	dw $0000      ; 61
	dw $0000      ; 62
	dw $0000      ; 63
	dw $0000      ; 64
	dw $0000      ; 65
	dw $0000      ; 66
	dw $0000      ; 67
	dw $0000      ; 68
	dw $0000      ; 69
	dw $0000      ; 6A
	dw $0000      ; 6B
	dw $0000      ; 6C
	dw $0000      ; 6D
	dw $0000      ; 6E
	dw .map6F     ; 6F
	dw .map70     ; 70
	dw $0000      ; 71
	dw $0000      ; 72
	dw .map73     ; 73
	dw $0000      ; 74
	dw .map75     ; 75
	dw $0000      ; 76
	dw $0000      ; 77
	dw .map78     ; 78
	dw $0000      ; 79
	dw $0000      ; 7A
	dw $0000      ; 7B
	dw $0000      ; 7C
	dw $0000      ; 7D
	dw $0000      ; 7E
	dw $0000      ; 7F

;---------------------------------------------------------------------------------------------------

.map03
	dw !OWW_InvertedOnly

	; singles
	dw $0034, $2BE0

	dw !OWW_Stripe|!OWW_Horizontal
	dw $29B6 ; address
	dw $021A, $01F3, $00A0, $0104|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00C6 ; tile
	dw $2A34, $2A38, $2A3A|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map05
	dw $0101, $2E18 ; OWG sign

	dw !OWW_InvertedOnly

	; singles
	dw $0034, $21F2
	dw $0034, $3D4A
	dw $0116, $216E
	dw $0126, $21F4

	dw $0139, $2C6C
	dw $014B, $2C6E
	dw $016B, $29F0
	dw $016B, $2CEC
	dw $0182, $29F2
	dw $0182, $2CEE

	dw !OWW_Stripe|!OWW_Horizontal
	dw $206E ; address
	dw $0112, $0113, $0113, $0112|!OWW_STOP

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0111, $20EC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(3)
	dw $0116, $20F0 ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $216C ; address
	dw $0112, $0116, $011C, $011D, $011E|!OWW_STOP

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(3)
	dw $011C, $2170 ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0123, $21EC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0144, $2364 ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $01B3, $236C ; tile, start

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2970 ; address
	dw $0139, $014B|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0130 ; tile
	dw $21E2, $21F0, $22E2, $22F0|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0135 ; tile
	dw $2262, $2270, $2362, $2370|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0136 ; tile
	dw $2264, $2266, $226C, $226E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0137 ; tile
	dw $2268, $226A|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $22E4 ; start
	dw $013C, $013C, $013D, $013D, $013C, $013C|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map07
	dw !OWW_InvertedOnly

	; singles
	dw $0134, $269E
	dw $0134, $26A4
	dw $0034, $2826

	dw !OWW_ArbTileCopy
	dw $021B ; tile
	dw $259E, $25A2, $25A4, $261C
	dw $2626, $269A, $26A8, $271A
	dw $2728, $279A, $27A8, $281E
	dw $2820, $2822, $2824, $2828
	dw $289C, $28A6, $291E, $2924|!OWW_STOP

	dw !OWW_END
	
;---------------------------------------------------------------------------------------------------

.map0E
	dw !OWW_InvertedOnly

	dw $0034, $3D4A

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map10
	dw !OWW_InvertedOnly

	dw $0034, $2B2E

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map14
	dw !OWW_InvertedOnly

	dw !OWW_Stripe|!OWW_Vertical
	dw $2422
	dw $02F1, $0184, $0184|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2424
	dw $02F2, $0185, $0185|!OWW_STOP

	dw !OWW_END

;===================================================================================================

.map1B
	dw !OWW_InvertedOnly

	; singles
	dw $0476, $2522
	dw $04D7, $2528

	dw !OWW_Stripe|!OWW_Vertical
	dw $2424 ; address
	dw $0485, $0454, $0460, !OWW_SKIP
	dw $04DD, $04E0, $04E4, $0034|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2426 ; address
	dw $0485, $0454, $0460, !OWW_SKIP
	dw $04DE, $04E1, $04E5, $0034|!OWW_STOP


	; Eye removed
	dw !OWW_ArbTileCopy
	dw $046D ; tile
	dw $243E, $24BC, $24BE, $253E
	dw $2440, $24C0, $24C2, $2540|!OWW_STOP

	; new trees

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2D2C ; address
	dw $00B0, $0014, $0015, $00A8
	dw $04BB, $0034|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2DAC ; address
	dw $0089, $001C, $001D, $0076
	dw $04BA, $0034|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2E2C ; address
	dw $00F1, $004E, $004F, $00D9
	dw $04BB|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $28AC, $28AE
	dw $28B0, $28CE, $28D0, $28D2
	dw $2C2C, $2C2E, $2CB6, $2EB6
	dw $2F30, $2F36, $2FAA, $2FB0
	dw $2FB4, $2FB6, $3028, $302C|!OWW_STOP

	; TODO still need to optimize this last section ugh
	dw $0035, $2C28
	dw $0035, $2FAE
	dw $0035, $302A
	dw $0035, $3032
	dw $007E, $2CB0
	dw $007F, $2CB2
	dw $0095, $2EB2
	dw $009A, $2EAC
	dw $009B, $2EAE
	dw $009C, $2EB0
	dw $00AE, $2CAC
	dw $00AF, $2CAE
	dw $00DA, $302E
	dw $00E2, $2C36
	dw $00E2, $2FA8
	dw $00E2, $3030
	dw $0451, $282E
	dw $0451, $2830
	dw $0451, $284E
	dw $0451, $2850
	dw $0451, $2852
	dw $0454, $272C
	dw $0454, $272E
	dw $0454, $274E
	dw $0454, $2750
	dw $0459, $27CE
	dw $0459, $27D0
	dw $045E, $27AE
	dw $045E, $27D2
	dw $0476, $2522
	dw $0486, $26B0
	dw $0487, $26B2
	dw $048E, $2730
	dw $048F, $2732
	dw $0494, $27B0
	dw $0495, $27B2
	dw $0499, $282C
	dw $049E, $27B4
	dw $04BA, $2CB4
	dw $04BA, $2EB4
	dw $04BB, $2F34
	dw $04CA, $27AC
	dw $04D7, $2528
	dw $0608, $2752

	dw !OWW_CustomCommand, .map1B_check_aga

	dw $046D, $243E
	dw $0E39, $2440

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3A, $24BC ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(4)
	dw $0E3E, $253C ; tile, start

	dw $0490, $25BE
	dw $0491, $25C0

.map1B_no_hole
	; add sign for tower entry
	dw $0101, $222C
	dw $0101, $2252

	dw !OWW_END

.map1B_check_aga
	LDA.l OverworldEventDataWRAM+$5B
	AND.w #$0020
	BNE ++

	LDY.w #.map1B_no_hole

++	RTS

;---------------------------------------------------------------------------------------------------

.map29
	dw !OWW_InvertedOnly

	; singles
	dw $0036, $2386

	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $2288, $2308, $2388, $2408
	dw $2488, $248A|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------
.map30
	dw !OWW_InvertedOnly

	dw $0178, $224E
	dw $00D3, $22E2
	dw $0302, $22E4
	dw $00AA, $2368
	dw $00AB, $236C
	dw $01C2, $245C
	dw $015C, $23E0
	dw $0218, $245E
	dw $0162, $2460
	dw $0105, $255A
	dw $01D4, $24DC
	dw $0219, $24DE
	dw $0171, $25DE
	dw $0166, $255E
	dw $0766, $2560
	dw $06E1, $27D6
	dw $00CF, $27DA
	dw $0034, $3D94

	dw !OWW_ArbTileCopy
	dw $017E
	dw $2050, $20CE|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00D1, $2052

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00D1, $21E6

	dw !OWW_ArbTileCopy
	dw $00D2
	dw $2060, $20E2, $2164|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0183
	dw $20D0, $214E|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00C9, $20D2

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00C9, $2152

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00C9, $2266
	dw $00C9, $22CC

	dw !OWW_ArbTileCopy
	dw $00D0
	dw $20E0, $2162, $21E4|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(3)
	dw $0153, $2150

	dw !OWW_ArbTileCopy
	dw $0153
	dw $21CE, $22CE|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00C8
	dw $2160, $21E2, $2264, $28DA, $295C|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00CA
	dw $21E0, $2262, $285A, $28DC|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00DC, $21D2
	dw $00DC, $224C

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(2)
	dw $00E3, $2252

	dw !OWW_ArbTileCopy
	dw $0186
	dw $22D0, $234E|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $0034, $22D2

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(7)
	dw $0034, $22D4

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(7)
	dw $0034, $22D6

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $0034, $2350

	dw !OWW_ArbTileCopy
	dw $0034
	dw $2458, $2656|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00CC, $22E6
	dw $00CC, $234C

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $00CE, $2362

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $00CE, $25D8

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $00C5, $2364

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $00C5, $25DC

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $06AB, $2366

	dw !OWW_ArbTileCopy
	dw $06AB
	dw $24E4, $2760|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0384
	dw $236A, $236E, $23EC, $246A|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0384, $24E8

	dw !OWW_ArbTileCopy
	dw $0759
	dw $23C8, $244A, $24CC, $254E, $26D0, $2752, $27D4|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0757
	dw $23CA, $244C, $24CE, $2550, $26D2, $2754|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $01FF
	dw $23CC, $244E, $24D0, $2652, $26D4, $2756|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $017C
	dw $23CE, $2450, $24D2, $2654, $26D6|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0100
	dw $245A, $24D8|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0104
	dw $24DA, $2558|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0106
	dw $2462, $24E0, $255C|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0107
	dw $2464, $24E2|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $0179, $2552

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $06B4, $2562

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $06E5, $25D0

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $00C4, $25DA

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $0165, $25E4

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $06E4, $27D2

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $06E4, $2854

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(3)
	dw $06E4, $2856

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $06E4, $2958
	dw $06E4, $29DA

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $02FD, $27D8

	dw !OWW_ArbTileCopy
	dw $06E7
	dw $28D8, $295A, $29DC|!OWW_STOP

	dw !OWW_END
;---------------------------------------------------------------------------------------------------

.map31
	dw !OWW_InvertedOnly

	; singles
	dw $017E, $20CE
	dw $017E, $2050
	dw $0183, $20D0
	dw $0183, $214E

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0034, $2050

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00D1, $2052

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00D1, $21E6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00C9, $20D2

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00C9, $2152

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00C9, $2266

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $00DC, $21D2

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $00CC, $22E6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0034, $2452

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $06B4, $2562

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $0165, $25E4

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0384, $24E8

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0034, $23D0

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0034, $22D2

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map38
	dw !OWW_InvertedOnly

	dw $0034, $3D94

	dw !OWW_END

;---------------------------------------------------------------------------------------------------


.map3C
	dw !OWW_InvertedOnly

	dw !OWW_ArbTileCopy
	dw $02E5
	dw $27AE, $282C, $282E, $2832
	dw $28AC, $28AE, $2928, $292C
	dw $29A8, $29B0, $2A28, $2A30
	dw $2AAC, $2AB2|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $078A
	dw $28AA, $28B0, $2AAA, $2B2A
	dw $2B30, $2BAE|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EB
	dw $28B4, $2930, $29AE, $2A2C
	dw $2A32, $2AAE|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $02EC
	dw $2934, $2B28, $2B2C, $2B2E
	dw $2B32|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map32
	dw !OWW_InvertedOnly

	dw !OWW_Stripe|!OWW_Vertical
	dw $2486
	dw $01D5, $0165, $00C6|!OWW_STOP

	dw $0166, $2508
	dw $0171, $2588

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $00C6, $2608

	dw $0166, $258A
	dw $016A, $278C
	dw $016A, $280C
	dw $00C6, $2806

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $021C, $260A

	dw !OWW_ArbTileCopy
	dw $0034
	dw $270E, $278E, $2790, $2918, $291A, $2998, $299A, $291C, $291E, $2920|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(8)
	dw $0034, $280E

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $0034, $2892

	dw !OWW_Stripe|!OWW_Horizontal
	dw $288C
	dw $01FA, $0034, $00DA|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $290C
	dw $0186
	dw $0034, $0034, $0034
	dw $0036, $0036|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(7)
	dw $0034, $2818

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2986
	dw $00E4, $00E5, $0186
	dw $0034, $0034, $0034, $0034
	dw $0036, $0036
	dw $0034, $0034
	dw $00DA
	dw $0034, $0034
	dw $0100|!OWW_STOP

	dw $0186, $2A04

	; a couple of these will be overwritten in a second
	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(13)
	dw $0034, $2A06

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(13)
	dw $0034, $2A84

	; leave these after the above
	dw $0071, $2A0E
	dw $0071, $2A1A
	dw $0035, $2A8C

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(5)
	dw $0034, $2B84

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(6)
	dw $0034, $2C86

	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $2B06, $2B0A, $2B0E, $2B12
	dw $2B1A, $2B92, $2B94
	dw $2B98, $2B9A, $2C04, $2C08
	dw $2C0A, $2C0E, $2C12, $2C14
	dw $2C18, $2C98
	dw $2D0A, $2D0C, $2D10, $2D14
	dw $2D16, $2D8A, $2D8C, $2D8E
	dw $2D94|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0035 ; tile
	dw $2B08, $2C06, $2D0E, $2D90|!OWW_STOP

	dw $0104, $2A22
	dw $01D4, $2A24
	dw $00F8, $2C1A
	dw $00CE, $2C1C
	dw $0071, $2C8C
	dw $00CE, $2C9C
	dw $0167, $2D04
	dw $0036, $2D12
	dw $0167, $2D86
	dw $0172, $2E08
	dw $0174, $2E16

	dw !OWW_ArbTileCopy
	dw $00DA ; tile
	dw $2B14, $2B16, $2B18, $2B96
	dw $2C16, $2C96, $2D08, $2D92|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $00E2 ; tile
	dw $2B04, $2B0C, $2B10, $2B8C, $2B90
	dw $2C0C, $2C10, $2C8E|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $015C ; tile
	dw $2A20, $2A9E, $2B1C, $2C9A, $2D18
	dw $2D96|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $015E ; tile
	dw $2E0A, $2E0C, $2E0E, $2E10
	dw $2E12, $2E14|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0160 ; tile
	dw $2C84, $2D06, $2D88|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0162 ; tile
	dw $2AA0, $2B1E, $2B9C, $2D1A
	dw $2D98|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $016A ; tile
	dw $2A82, $2B02, $2B82, $2C02
	dw $2C82|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map33
	dw !OWW_InvertedOnly

	dw $0034, $22A8

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map35
	dw !OWW_InvertedOnly

	dw !OWW_Stripe|!OWW_Vertical
	dw $2BB0
	dw $02F1, $0184, $0392, $0394|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2BB2
	dw $02F2, $0185, $0393, $0395|!OWW_STOP

	dw $0034, $2F56

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map3A
	dw !OWW_InvertedOnly

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2800
	dw $0774, $06E1, $0757|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2880
	dw $0779, $02EC, $0759, $0757|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2900
	dw $02E5, $02E5, $02E5, $0759, $076A|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $2980
	dw $02F3, $02F3, $02F1, $02F2, $038A|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $0184, $2A04

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(4)
	dw $0185, $2A06

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map43
	dw !OWW_SkipIfInverted, .map43_inverted
	dw $0101, $2550 ; GT sign

	.map43_inverted
	dw !OWW_InvertedOnly

	dw $0212, $2BE0
	
	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $0E96, $235E

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $0E97, $2360

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0E94, $25DE ; tile, start

	dw !OWW_StripeRLEINC|!OWW_Horizontal|OWW_RLESize(2)
	dw $0180, $275E

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $0184, $27DE

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(2)
	dw $0185, $27E0

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map44
	dw !OWW_InvertedOnly

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $0E96, $235E

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(5)
	dw $0E97, $2360

	dw $0E94, $25DE
	dw $0E95, $25E0
	dw $0212, $2BE0

	dw !OWW_Stripe|!OWW_Vertical
	dw $275E
	dw $0180, $0184, $0184|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $276E
	dw $0181, $0185, $0185|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------
.map45
	dw !OWW_InvertedOnly

	dw $0239, $3D4A

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map47
	dw !OWW_InvertedOnly

	dw $0398, $25A0
	dw $0522, $25A2
	dw $0125, $2620
	dw $0126, $2622
	dw $0239, $269E
	dw $0239, $26A4

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map4E
	dw !OWW_InvertedOnly

	dw $0239, $3D4A

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map50
	dw !OWW_InvertedOnly

	dw $020F, $2B2E

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map54
	dw !OWW_InvertedOnly

	dw !OWW_Stripe|!OWW_Vertical
	dw $2422
	dw $02F3, $00C9, $00E3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $2424
	dw $02F3, $00C9, $00E3|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

; Pyramid
.map5B
	dw !OWW_SkipIfInverted, .map5B_inverted_mode

	dw $0101, $27B6 ; sign to statue
	dw $05C2, $27B4 ; peg left of sign

.map5B_inverted_mode
	dw !OWW_InvertedOnly

	dw $0323, $39B6

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0324, $39B8

	dw $02FE, $3A34
	dw $02FF, $3A36
	dw $0235, $3BB4

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0326, $3A38

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3AB2
	dw $039D, $0303, $0232
	dw $0233, $0233, $0233, $0233|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3B32
	dw $03A2, $0232, $0235, $046A
	dw $0333, $0333, $0333|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $3BB6, $3BBA, $3BBC, $3C3A
	dw $3C3C, $3C3E|!OWW_STOP


	; pegs
	dw !OWW_ArbTileCopy
	dw $0034 ; tile
	dw $321C, $329C, $32A0|!OWW_STOP

	dw $00E2, $321A
	dw $0071, $321E
	dw $00DA, $3220

	dw $00DA, $329A
	dw $00E1, $329E

	dw $0382, $3318
	dw $037C, $3322

	dw $00F2, $3BB8
	dw $0108, $3C38

	dw !OWW_ArbTileCopy
	dw $021B ; tile
	dw $3218, $3222, $3298, $32A2
	dw $331A, $331C, $331E, $3320|!OWW_STOP


	dw !OWW_CustomCommand, .map5B_pick_warp_tile

	dw !OWW_Stripe|!OWW_Horizontal
	dw $39C0 ; start
	dw $0324, $0324, $0324, $0325, $02D5
	dw !OWW_SKIP, $02CC|!OWW_STOP

	dw $02CC, $39D4

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3A40 ; start
	dw $0326, $0326, $0326
	dw $0327, $02F7, !OWW_SKIP
	dw $02E3, $02E3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3AC0 ; start
	dw $0233, $0233, $0233, $0234
	dw $02F6, $0396|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3B40
	dw $0333, $0333, $03AA, $03A3
	dw $0234, $0397|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3BC0 ; start
	dw $0034, $0034, $029C, $0034
	dw $03A3|!OWW_STOP

	dw !OWW_Stripe|!OWW_Horizontal
	dw $3C40 ; start
	dw $0034, $0034, $010A|!OWW_STOP

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(17)
	dw $010B, $3C46

	dw !OWW_END

.map5B_pick_warp_tile
	LDA.l ProgressIndicator
	AND.w #$00FF
	CMP.w #$0003

	LDA.w #$0034
	BCC ++

	LDA.w #$0212

++	STA.l $7E3BBE

	RTS

;---------------------------------------------------------------------------------------------------

.map6F
	dw !OWW_InvertedOnly

	dw $020F, $2BB2

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map70
	dw !OWW_InvertedOnly

	dw $0239, $3D94

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map73
	dw !OWW_InvertedOnly

	dw $020F, $22A8

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map75
	dw !OWW_InvertedOnly

	; singles
	dw $0239, $2F50

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0BA3, $3054

	dw !OWW_StripeRLE|!OWW_Horizontal|OWW_RLESize(4)
	dw $0BA3, $3254

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(3)
	dw $0BAD, $30D6

	dw !OWW_StripeRLE|!OWW_Vertical|OWW_RLESize(3)
	dw $0BA9, $30D8

	dw !OWW_Stripe|!OWW_Vertical
	dw $30D4 ; start
	dw $0BAC, $0BC5, $0BCA|!OWW_STOP

	dw !OWW_Stripe|!OWW_Vertical
	dw $30DA ; start
	dw $0BAA, $0BC8, $0BCD|!OWW_STOP

	dw !OWW_ArbTileCopy
	dw $0BA3 ; tile
	dw $2F52, $2FCE, $2FD0|!OWW_STOP

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

.map78
	dw !OWW_InvertedOnly

	dw $0239, $3D94

	dw !OWW_END

;---------------------------------------------------------------------------------------------------

;===================================================================================================
