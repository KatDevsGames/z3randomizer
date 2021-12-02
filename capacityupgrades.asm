;================================================================================
; Capacity Logic
;================================================================================
IncrementBombs:
    LDA BombCapacityUpgrades ; get bomb upgrades
	!ADD.l StartingMaxBombs : BEQ + ; Skip if we can't have bombs
	DEC

    CMP BombsEquipment
	
	!BLT +
    	LDA BombsEquipment
		CMP.b #99 : !BGE +
		INC : STA BombsEquipment
	+
RTL
;--------------------------------------------------------------------------------
IncrementArrows:
    LDA ArrowCapacityUpgrades ; get arrow upgrades
	!ADD.l StartingMaxArrows : DEC

    CMP CurrentArrows
	
	!BLT +    
    	LDA CurrentArrows
		CMP.b #99 : !BGE +
		INC : STA CurrentArrows
	+
RTL
;--------------------------------------------------------------------------------
CompareBombsToMax:
    LDA BombCapacityUpgrades ; get bomb upgrades
	!ADD.l StartingMaxBombs

    CMP BombsEquipment
RTL
;--------------------------------------------------------------------------------
