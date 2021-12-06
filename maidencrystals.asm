;================================================================================
; Maiden Crystal Fixes
;================================================================================

;--------------------------------------------------------------------------------
; MaidenCrystalScript
;--------------------------------------------------------------------------------
MaidenCrystalScript:
	LDA.b #$00 : STA $7F5091
    STZ $02D8
    STZ $02DA
    STZ $2E
    LDA #$02 : STA $2F
	
    ; Load the dungeon index. Is it the Dark Palace?
    ;LDA $040C : !SUB.b #$0A : TAY : CPY.b #$02 : BNE +
    ;	LDA MapIcons : CMP.b #$07 : BCS ++ : LDA.b #$07 : STA MapIcons : ++
	;+
    
    LDA CrystalsField : AND.b #$7F : CMP.b #$7F : BNE + ; check if we have all crystals
    	LDA.b #$08 : STA MapIcons ; Update the map icon to just be Ganon's Tower
	+
	
JML.l $1ECF35 ; <- F4F35 - sprite_crystal_maiden.asm : 426
;--------------------------------------------------------------------------------
