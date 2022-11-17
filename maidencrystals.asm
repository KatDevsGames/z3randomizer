;================================================================================
; Maiden Crystal Fixes
;================================================================================

;--------------------------------------------------------------------------------
; MaidenCrystalScript
;--------------------------------------------------------------------------------
MaidenCrystalScript:
        LDA.b #$00 : STA.l BusyItem
        STZ.w $02D8
        STZ.w $02DA
        STZ.b $2E
        LDA.b #$02 : STA.w $2F
        LDA.l CrystalsField : AND.b #$7F : CMP.b #$7F : BNE + ; check if we have all crystals
                LDA.b #$08 : STA.l MapIcons ; Update the map icon to just be Ganon's Tower
	+
JML.l $1ECF35 ; <- F4F35 - sprite_crystal_maiden.asm : 426
;--------------------------------------------------------------------------------
