;================================================================================
; Maiden Crystal Fixes
;================================================================================

;--------------------------------------------------------------------------------
; MaidenCrystalScript
;--------------------------------------------------------------------------------
MaidenCrystalScript:
        LDA.b #$00 : STA.l BusyItem
        STZ.w ItemReceiptID
        STZ.w ItemReceiptPose
        STZ.b LinkAnimationStep
        LDA.b #$02 : STA.w LinkDirection
        LDA.l CrystalsField : AND.b #$7F : CMP.b #$7F : BNE + ; check if we have all crystals
                LDA.b #$08 : STA.l MapIcons ; Update the map icon to just be Ganon's Tower
	+
JML.l $9ECF35 ; <- F4F35 - sprite_crystal_maiden.asm : 426
;--------------------------------------------------------------------------------
