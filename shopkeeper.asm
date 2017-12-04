;================================================================================
; Randomize 300 Rupee NPC
;--------------------------------------------------------------------------------
Set300RupeeNPCItem:
	INC $0D80, X ; thing we wrote over

	PHA : PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #291 : BNE +
		LDA RupeeNPC_MoldormCave : TAY ; load moldorm cave value into Y
		BRA .done
	+ CMP.w #286 : BNE +
		LDA RupeeNPC_NortheastDarkSwampCave : TAY ; load northeast dark swamp cave value into Y
		BRA .done
	+
	LDY.b #$46 ; default to a normal 300 rupees
	.done
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
; 291 - Moldorm Cave
; 286 - Northeast Dark Swamp Cave
;--------------------------------------------------------------------------------
!BIGRAM = "$7EC900";
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
; $0A : Digit Offset
; $0C-$0D : Value to Display
; $0E-$0F : Base Coordinate
;--------------------------------------------------------------------------------
macro DrawDigit(value,offset)
	STZ $0A ; clear digit buffer
	LDA $0C ; load value
	--
	CMP.w <value> : !BLT ++
		!SUB.w <value>
		INC $0A
		BRA --
	++
	STA $0C ; save value
	CPY.b #$FF : BNE +
		LDY.b <offset>
		LDA $0E : !ADD.w .digit_offsets, Y : STA $0E
	+
	LDA $0E : STA !BIGRAM, X : INX : INX
	LDA.w #56 : STA !BIGRAM, X : INX : INX
	LDY $0A : TYA : ASL : TAY : LDA .digit_properties, Y : STA !BIGRAM, X : INX : INX
	LDA.w #$0000 : STA !BIGRAM, X : INX : INX

	LDA $0E : !ADD.w #$0008 : STA $0E ; move offset 8px right
endmacro
;--------------------------------------------------------------------------------
DrawPrice:
	PHX : PHY : PHP
		LDY.b #$FF
		LDX #$00 ; clear bigram pointer

		LDA $0C : CMP.w #1000 : !BLT + : BRL .len4 : +
				  CMP.w #100 : !BLT + : BRL .len3 : +
				  CMP.w #10 : !BLT + : BRL .len2 : +
				  CMP.w #1 : !BLT + : BRL .len1 : +

			.len4
				%DrawDigit(#1000,#6)
			
			.len3
				%DrawDigit(#100,#4)
			
			.len2
				%DrawDigit(#10,#2
			
			.len1
				%DrawDigit(#1,#0)
				
		SEP #$20 ; set 8-bit accumulator
		TXA : LSR #3 : STA $06 ; request 1-4 OAM slots
		ASL #2 : JSL.l OAM_AllocateFromRegionA ; request 4-16 bytes
		TXA : LSR #3
	PLP : PLY : PLX
RTS
;--------------------------------------------------------------------------------
.digit_properties
dw $0230, $0231, $0202, $0203, $0212, $0213, $0222, $0223, $0232, $0233
;--------------------------------------------------------------------------------
.digit_offsets
dw 4, 0, -4, -8
;--------------------------------------------------------------------------------
SpritePrep_ShopKeeper:
	
RTL
;--------------------------------------------------------------------------------
Sprite_ShopKeeper:
	PHB : PHK : PLB
		JSL.l Sprite_PlayerCantPassThrough
		
		; Draw Shopkeeper
		LDA.b #$02 : STA $06 ; request 2 OAM slots
		LDA #$08 : JSL.l OAM_AllocateFromRegionB ; request 8 bytes
		LDA.b #$02 : STA $06 ; request 2 OAM slots
		STZ $07
		LDA $1A : AND #$10 : BEQ +
			LDA.b #.oam_shopkeeper_f1 : STA $08
			LDA.b #.oam_shopkeeper_f1>>8 : STA $09
			BRA ++
		+
			LDA.b #.oam_shopkeeper_f2 : STA $08
			LDA.b #.oam_shopkeeper_f2>>8 : STA $09
		++
		;LDA.b #$01 : STA.l !SKIP_EOR
		JSL.l Sprite_DrawMultiple_quantity_preset
		LDA $90 : !ADD.b #$04*2 : STA $90 ; increment oam pointer
		LDA $92 : INC #2 : STA $92
	
		; Draw Items
		LDA.b #$03 : STA $06 ; request 3 OAM slots
		LDA #$0C : JSL.l OAM_AllocateFromRegionB ; request 12 bytes
		LDA.b #$03 : STA $06 ; request 3 OAM slots
		STZ $07
		LDA.b #.oam_items : STA $08
		LDA.b #.oam_items>>8 : STA $09
		JSL.l Sprite_DrawMultiple_quantity_preset
		LDA $90 : !ADD.b #$04*3 : STA $90 ; increment oam pointer
		LDA $92 : INC #3 : STA $92
	
		; Draw Prices
		;LDA.b #$0C : STA $06 ; request 12 OAM slots
		;LDA #$30 : JSL.l OAM_AllocateFromRegionA ; request 48 bytes
		;LDA.b #$0C : STA $06 ; request 12 OAM slots
		;STZ $07
		;LDA.b #.oam_prices : STA $08
		;LDA.b #.oam_prices>>8 : STA $09
		;JSL.l Sprite_DrawMultiple_quantity_preset
		;LDA $90 : !ADD.b #4*12 : STA $90 ; increment oam pointer
		;LDA $92 : INC #12 : STA $92
		
		LDA.b #$00 : STA.l !SKIP_EOR
		
		REP #$20 ; set 16-bit accumulator
		LDA.w #651 : STA $0C ; set value
		LDA.w #8 : STA $0E ; set coordinate
		JSR.w DrawPrice
		SEP #$20 : STA $06 ; set 8-bit accumulator & store result
		PHA
			STZ $07
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E
			JSL.l Sprite_DrawMultiple_quantity_preset
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
		
		REP #$20 ; set 16-bit accumulator
		LDA.w #55 : STA $0C ; set value
		LDA.w #56 : STA $0E ; set coordinate
		JSR.w DrawPrice
		SEP #$20 : STA $06 ; set 8-bit accumulator & store result
		PHA
			STZ $07
			LDA.b #!BIGRAM : STA $08
			LDA.b #!BIGRAM>>8 : STA $09
			LDA.b #$7E : PHA : PLB ; set data bank to $7E
			JSL.l Sprite_DrawMultiple_quantity_preset
			LDA 1,s
			ASL #2 : !ADD $90 : STA $90 ; increment oam pointer
		PLA
		!ADD $92 : STA $92
	PLB
RTL
;--------------------------------------------------------------------------------
.oam_shopkeeper_f1
dw 8, -8 : db $00, $0C, $00, $02
dw 8, 0 : db $10, $0C, $00, $02
.oam_shopkeeper_f2
dw 8, -8 : db $00, $0C, $00, $02
dw 8, 0 : db $10, $4C, $00, $02
;--------------------------------------------------------------------------------
.oam_items
dw -40, 40 : db $C0, $08, $00, $02
dw 8, 40 : db $C2, $04, $00, $02
dw 56, 40 : db $C4, $02, $00, $02
;--------------------------------------------------------------------------------
.oam_prices
dw -48, 56 : db $30, $02, $00, $00
dw -40, 56 : db $31, $02, $00, $00
dw -32, 56 : db $02, $02, $00, $00
dw -24, 56 : db $03, $02, $00, $00

dw 0, 56 : db $12, $02, $00, $00
dw 8, 56 : db $13, $02, $00, $00
dw 16, 56 : db $22, $02, $00, $00
dw 24, 56 : db $23, $02, $00, $00

dw 48, 56 : db $32, $02, $00, $00
dw 56, 56 : db $33, $02, $00, $00
dw 64, 56 : db $30, $02, $00, $00
dw 72, 56 : db $31, $02, $00, $00
;--------------------------------------------------------------------------------