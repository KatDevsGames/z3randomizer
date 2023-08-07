;================================================================================
; Item Downgrade Fix
;--------------------------------------------------------------------------------
ItemDowngradeFix:
	JSL.l AddInventory
	BMI .dontWrite ; thing we wrote over part 1
	
	CPY.b #$1B : BEQ .isPowerGloves ; Power Gloves
	CPY.b #$05 : BEQ .isRedShield ; Red Shield
	CPY.b #$04 : BEQ .isBlueShield ; Blue Shield
	CPY.b #$0C : BEQ .isBlueBoomerang ; Blue Boomerang
	CPY.b #$0B : BEQ .isBow ; Bow
	CPY.b #$3A : BEQ .isBowAndArrows ; Bow
	
	CPY.b #$49 : BEQ .isSword ; Fighter's Sword
	CPY.b #$01 : BEQ .isSword ; Master Sword
	CPY.b #$50 : BEQ .isSword ; Master Sword (Safe)
	CPY.b #$02 : BEQ .isSword ; Tempered Sword
	
	CPY.b #$3B : BEQ .isSilverArrowBow ; Silver Arrow Bow
	CPY.b #$2A : BEQ .isRedBoomerang ; Red Boomerang
	CPY.b #$0D : BEQ .isMagicPowder ; Magic Powder
	CPY.b #$14 : BEQ .isFlute ; Flute
	CPY.b #$13 : BEQ .isShovel ; Shovel
	CPY.b #$29 : BEQ .isMushroom ; Mushroom
	
	CPY.b #$00 : BEQ .isUncleSwordShield ; Fighter's Sword & Shield

        .done
	STA.b [Scrap00] ; thing we wrote over part 2
	.dontWrite
RTL
	.isPowerGloves
	.isBlueShield
	.isRedShield
	.isBlueBoomerang
	.isBow
	.isBowAndArrows
	CMP.b [$00] : !BGE .done ; finished if we're upgrading
	LDA.b [$00] ; reload old value
RTL
	.isSilverArrowBow
	.isRedBoomerang
	.isMagicPowder
	.isFlute
	.isShovel
	.isMushroom
	PHA
	LDA.b [Scrap00] : BNE + ; don't upgrade if we already have the toggle for it
			PLA
			STA.b [Scrap00]
		RTL
	+
	PLA
RTL
	.isSword
	PHA
                LDA.l HighestSword : STA.b Scrap04
		TYA ; load sword item
		CMP.b #$49 : BNE + : LDA.b #$00 : + ; convert extra fighter's sword to normal one
		CMP.b #$50 : BNE + : LDA.b #$01 : + ; convert extra master sword to normal one
		INC : CMP.b Scrap04 : !BGE + ; skip if highest is lower (this is an upgrade)
			LDA.b Scrap04 : DEC ; convert to item id
			TAY : PLA : LDA.b Scrap04 ; put sword id into the thing to write
			JMP .done
		+
	PLA
JMP .done
        .isUncleSwordShield
	PHA
                LDA.l HighestSword : STA.b [Scrap00] ; already set to 1 if we had no sword, always keep highest
                INC.b Scrap00
                LDA.l HighestShield : STA.b [Scrap00]
	PLA
RTL
;================================================================================
