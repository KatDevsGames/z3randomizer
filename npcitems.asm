;================================================================================
; Randomize NPC Items
;--------------------------------------------------------------------------------
; Old Man - Zora King - Sick Kid - Tree Kid - Sahasrala - Catfish - Rupee NPC
;=SET 1
;OLD_MAN = "#$01"
;ZORA_KING = "#$02"
;SICK_KID = "#$04"
;TREE_KID = "#$08"
;SAHASRALA = "#$10"
;CATFISH = "#$20"
;UNUSED = "#$40"
;BOOK_MUDORA = "#$80"
;=SET 2
;ETHER_TABLET = "#$01"
;BOMBOS_TABLET = "#$02"
;SMITH_SWORD = "#$04"
;FAIRY_SWORD = "#$08"
;MUSHROOM = "#$10"
;POWDER = "#$20"
;UNUSED = "#$40"
;MAGIC_BAT = "#$80"
;--------------------------------------------------------------------------------
!NPC_FLAGS   = "$7EF410"
!NPC_FLAGS_2 = "$7EF411"

ItemCheck_FairySword:
	LDA !NPC_FLAGS_2 : AND.b #$08
RTL

ItemCheck_SmithSword:
	LDA !NPC_FLAGS_2 : AND.b #$04
RTL

ItemCheck_MagicBat:
	LDA !NPC_FLAGS_2 : AND.b #$80
RTL

ItemCheck_OldMan:
	LDA !NPC_FLAGS : AND.b #$01 : CMP #$01
RTL

ItemCheck_ZoraKing:
	LDA !NPC_FLAGS : AND.b #$02
RTL

ItemCheck_SickKid:
	LDA !NPC_FLAGS : AND.b #$04
RTL

ItemCheck_TreeKid:
	LDA !NPC_FLAGS : AND.b #$08 ; FluteBoy_Chillin - 73: LDA $7EF34C
RTL

ItemCheck_TreeKid2:
	LDA !NPC_FLAGS : AND.b #$08 : LSR #$02 ; FluteAardvark_InitialStateFromFluteState - 225: LDA $7EF34C : AND.b #$03
RTL

ItemCheck_TreeKid3:
	JSL $0DD030 ; FluteAardvark_Draw - thing we wrote over
	LDA !NPC_FLAGS : AND.b #$08
	BEQ .normal
	BRA .done
	LDA.b #$05
	.normal
	LDA $0D80, X
	.done
RTL

ItemCheck_Sahasrala:
	LDA !NPC_FLAGS : AND.b #$10
RTL

ItemCheck_Library:
	LDA !NPC_FLAGS : AND.b #$80
RTL

ItemCheck_Mushroom:
	LDA !NPC_FLAGS_2 : ROL #4 ; does the same thing as below
;	LDA !NPC_FLAGS_2 : AND.b #$10 : BEQ .clear
;	SEC
;RTL
;	.clear
;	CLC
RTL

ItemCheck_Powder:
	LDA !NPC_FLAGS_2 : AND.b #$20
RTL

ItemCheck_Catfish:
	;LDA CatfishGoodItem : BEQ .junk
	;PHX
	;	LDA CatfishGoodItem+1 : TAX
	;	LDA $7EF340-1, X
	;PLX
	;--
	;CMP CatfishGoodItem : !BLT .oursNewer
	;.theirsNewer
	;LDA #$20 : RTL ; don't give item
	;.oursNewers
	;LDA #$00 : RTL ; give item
	;.junk
	LDA !NPC_FLAGS : AND.b #$20
RTL
;--------------------------------------------------------------------------------
ItemSet_FairySword:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$08 : STA !NPC_FLAGS_2 : PLA
RTL

ItemSet_SmithSword:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$04 : STA !NPC_FLAGS_2 : PLA
RTL

ItemSet_MagicBat:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$80 : STA !NPC_FLAGS_2 : PLA
RTL

ItemSet_OldMan:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$01 : STA !NPC_FLAGS : PLA
RTL

ItemSet_ZoraKing:
	;JSL $1DE1AA ; Sprite_SpawnFlippersItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$02 : STA !NPC_FLAGS : PLA
RTL

ItemSet_SickKid:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$04 : STA !NPC_FLAGS : PLA
RTL

ItemSet_TreeKid:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$08 : STA !NPC_FLAGS : PLA
RTL

ItemSet_Sahasrala:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$10 : STA !NPC_FLAGS : PLA
RTL

ItemSet_Catfish:
	;JSL $00D52D ; GetAnimatedSpriteTile.variable ; thing we wrote over
	;JSL.l LoadCatfishItemGFX
	PHA : LDA !NPC_FLAGS : ORA.b #$20 : STA !NPC_FLAGS : PLA
RTL

ItemSet_Library:
	JSL.l Link_ReceiveItem ; thing we wrote over
	PHA : LDA !NPC_FLAGS : ORA.b #$80 : STA !NPC_FLAGS : PLA
RTL

ItemSet_Mushroom:
	PHA
		LDA !NPC_FLAGS_2 : ORA.b #$10 : STA !NPC_FLAGS_2
		LDY $0E80, X ; Retrieve stored item type
		BNE +
			; if for any reason the item value is 0 reload it, just in case
			%GetPossiblyEncryptedItem(MushroomItem, SpriteItemValues) : TAY
		+
	PLA
	;LDY.b #$29
	STZ $02E9 ; thing we wrote over - the mushroom is an npc for item purposes apparently
RTL

ItemSet_Powder:
	PHA : LDA !NPC_FLAGS_2 : ORA.b #$20 : STA !NPC_FLAGS_2 : PLA
RTL
;================================================================================

;================================================================================
; Randomize 300 Rupee NPC
;--------------------------------------------------------------------------------
Set300RupeeNPCItem:
	INC $0D80, X ; thing we wrote over

	PHA : PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #291 : BNE +
		%GetPossiblyEncryptedItem(RupeeNPC_MoldormCave, SpriteItemValues)
		TAY ; load moldorm cave value into Y
		BRA .done
	+ CMP.w #286 : BNE +
		%GetPossiblyEncryptedItem(RupeeNPC_NortheastDarkSwampCave, SpriteItemValues)
		TAY ; load northeast dark swamp cave value into Y
		BRA .done
	+
	LDY.b #$46 ; default to a normal 300 rupees
	.done
	PLP : PLA
RTL
;================================================================================
