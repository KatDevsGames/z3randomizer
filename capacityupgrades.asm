;================================================================================
; Capacity Logic
;================================================================================
!BOMB_UPGRADES = "$7EF370"
!BOMB_CURRENT = "$7EF343"
;--------------------------------------------------------------------------------
IncrementBombs:
    LDA !BOMB_UPGRADES ; get bomb upgrades
	!ADD.l StartingMaxBombs : DEC

    CMP !BOMB_CURRENT
	
	!BLT +
    	LDA !BOMB_CURRENT
		CMP.b #99 : !BGE +
		INC : STA !BOMB_CURRENT
	+
RTL
;--------------------------------------------------------------------------------
!ARROW_UPGRADES = "$7EF371"
!ARROW_CURRENT = "$7EF377"
;--------------------------------------------------------------------------------
IncrementArrows:
    LDA !ARROW_UPGRADES ; get arrow upgrades
	!ADD.l StartingMaxArrows : DEC

    CMP !ARROW_CURRENT
	
	!BLT +    
    	LDA !ARROW_CURRENT
		CMP.b #99 : !BGE +
		INC : STA !ARROW_CURRENT
	+
RTL
;--------------------------------------------------------------------------------
CompareBombsToMax:
    LDA !BOMB_UPGRADES ; get bomb upgrades
	!ADD.l StartingMaxBombs

    CMP !BOMB_CURRENT
RTL
;--------------------------------------------------------------------------------