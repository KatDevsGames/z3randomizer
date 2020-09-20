;================================================================================
; Item Downgrade Fix
;--------------------------------------------------------------------------------
ItemDowngradeFix:
	JSR ItemDowngradeFixMain
	JSL CountChestKeyLong
RTL

ItemDowngradeFixMain:
	JSL.l AddInventory
	BMI .dontWrite ; thing we wrote over part 1
	
	CPY.b #$1B : BEQ .isPowerGloves ; Power Gloves
	CPY.b #$05 : BEQ .isRedShield ; Red Shield
	CPY.b #$04 : BEQ .isBlueShield ; Blue Shield
	CPY.b #$0C : BEQ .isBlueBoomerang ; Blue Boomerang
	CPY.b #$0B : BEQ .isBow ; Bow
	CPY.b #$3A : BEQ .isBowAndArrows ; Bow
	
	CPY.b #$49 : BEQ .isFightersSword ; Fighter's Sword
	CPY.b #$01 : BEQ .isMasterSword ; Master Sword
	CPY.b #$50 : BEQ .isMasterSword ; Master Sword (Safe)
	CPY.b #$02 : BEQ .isTemperedSword ; Tempered Sword
	
	CPY.b #$3B : BEQ .isSilverArrowBow ; Silver Arrow Bow
	CPY.b #$2A : BEQ .isRedBoomerang ; Red Boomerang
	CPY.b #$0D : BEQ .isMagicPowder ; Magic Powder
	CPY.b #$14 : BEQ .isFlute ; Flute
	CPY.b #$13 : BEQ .isShovel ; Shovel
	CPY.b #$29 : BEQ .isMushroom ; Mushroom
	
	.done
	STA [$00] ; thing we wrote over part 2
	.dontWrite
RTS
	.isPowerGloves
	.isBlueShield
	.isRedShield
	.isBlueBoomerang
	.isBow
	.isBowAndArrows
	CMP [$00] : !BGE .done ; finished if we're upgrading
	LDA [$00] ; reload old value
RTS
	.isSilverArrowBow
	.isRedBoomerang
	.isMagicPowder
	.isFlute
	.isShovel
	.isMushroom
	PHA
	LDA [$00] : BNE + ; don't upgrade if we already have the toggle for it
			PLA
			STA [$00]
		RTS
	+
	PLA
RTS
	.isFightersSword
	.isMasterSword
	.isTemperedSword
	PHA
		TYA ; load sword item
		CMP.b #$49 : BNE + : LDA.b #$00 : + ; convert extra fighter's sword to normal one
		CMP.b #$50 : BNE + : LDA.b #$01 : + ; convert extra master sword to normal one
		INC : CMP !HIGHEST_SWORD_LEVEL : !BGE + ; skip if highest is lower (this is an upgrade)
			LDA !HIGHEST_SWORD_LEVEL : DEC ; convert to item id
			TAY : PLA : LDA !HIGHEST_SWORD_LEVEL ; put sword id into the thing to write
			BRL .done
		+
	PLA
BRL .done
;================================================================================