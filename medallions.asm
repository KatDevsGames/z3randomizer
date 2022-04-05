;================================================================================
; Medallion Changes & Fixes
;--------------------------------------------------------------------------------
TryOpenMire:
    ; Checks if we're in the Swamp of Evil.
    LDA $8A : CMP.b #$70 : BNE .untriggered
    
    ; Checks whether the Misery Mire dungeon is already revealed.
    LDA OverworldEventDataWRAM+$70 : AND.b #$20 : BNE .untriggered
    
    ; You have to be in the trigger window.
    LDY.b #$02 : JSL.l Ancilla_CheckIfEntranceTriggered : BCC .untriggered
    
    ; Do the 3rd animation for opening entrances
    LDA.b #$03 : STA $04C6
    
    STZ $B0 ; reset the sub-submodule index
    STZ $C8 ; reset this other index.
	
	.untriggered
RTL
;--------------------------------------------------------------------------------
TryOpenTRock:
    ; Checks if we're at Turtle Rock.
    LDA $8A : CMP.b #$47 : BNE .untriggered
    
    ; Checks whether the Turtle Rock dungeon is already revealed.
    LDA OverworldEventDataWRAM+$47 : AND.b #$20 : BNE .untriggered
    
    ; You have to be in the trigger window.
    LDY.b #$03 : JSL.l Ancilla_CheckIfEntranceTriggered : BCC .untriggered
    
	; Do the 4rd animation for opening entrances
    LDA.b #$04 : STA $04C6
    
    STZ $B0 ; reset the sub-submodule index
    STZ $C8 ; reset this other index.
	
	.untriggered
RTL
;--------------------------------------------------------------------------------
MedallionTrigger_Bombos:
    STZ $50 ; stuff we wrote over
    STZ $0FC1
	
	PHA
	LDA.l MireRequiredMedallion : BNE +
		JSL.l TryOpenMire
	+ LDA.l TRockRequiredMedallion : BNE +
		JSL.l TryOpenTRock
	+
	PLA
RTL
;--------------------------------------------------------------------------------
!EPILEPSY_TIMER = "$7F5041"
MedallionTrigger_Ether:
	PHA
	LDA.b #$00 : STA !EPILEPSY_TIMER
	LDA.l MireRequiredMedallion : CMP.b #$01 : BNE +
		JSL.l TryOpenMire
	+ LDA.l TRockRequiredMedallion : CMP.b #$01 : BNE +
		JSL.l TryOpenTRock
	+
	PLA
RTL
;--------------------------------------------------------------------------------
MedallionTrigger_Quake:
	PHA
	LDA.l MireRequiredMedallion : CMP.b #$02 : BNE +
		JSL.l TryOpenMire
	+ LDA.l TRockRequiredMedallion : CMP.b #$02 : BNE +
		JSL.l TryOpenTRock
	+
	PLA
RTL
;--------------------------------------------------------------------------------
