;================================================================================
!CUCCO_STORM = "$7F50C5"
!IS_INDOORS = "$7E001B"
!ENEMY_STATE_TABLE = "$7E0DD0"
!ENEMY_TYPE_TABLE = "$7E0E20"
!ENEMY_AUX1_TABLE = "$7E0DA0"
!ENEMY_AUX2_TABLE = "$7E0DB0"
!ENEMY_DIRECTION_TABLE = "$7E0EB0"
!CUCCO = "#$0B"
!INERT = "#$00"
!INIT = "#$08"
!ALIVE = "#$09"
!CUCCO_ENRAGED = "#$23"
!LINK_POS_Y_LOW = "$20"
!LINK_POS_Y_HIGH = "$21"
!LINK_POS_X_LOW = "$22"
!LINK_POS_X_HIGH = "$23"
!ENEMY_POS_Y_LOW = "$7E0D00"
!ENEMY_POS_X_LOW = "$7E0D10"
!ENEMY_POS_Y_HIGH = "$7E0D20"
!ENEMY_POS_X_HIGH = "$7E0D30"
CuccoStorm:
	
	SEP #$30 ; set 8-bit accumulator index registers
	LDA.l !CUCCO_STORM : BEQ + ; only if storm is on
	LDA.b $10 : CMP.b #$09 : BNE + ; only if outdoors
	LDA.l LoopFrames : AND.b #$7F : BNE + ; check every 128 frames
	
	-
		;==== Find a Cucco
		
		LDY.b #$FF : PHY ; push "cucco not found"
	
		LDX.b #$00 : -- : CPX.b #$10 : !BGE .ldone
			LDA.w !ENEMY_STATE_TABLE, X : CMP.b !ALIVE : BEQ +++
				; enemy not found
				CMP.b !INERT : BNE ++
					; log inert enemy slot
					PLA : PHX
					BRA ++
			+++
			; found an enemy
			LDA.l !ENEMY_TYPE_TABLE, X : CMP.b !CUCCO : BNE ++
				; it's a cucco
				TXY ; record where we found the living cucco in case we don't find any angry ones
				LDA.w !ENEMY_AUX1_TABLE, X : CMP.b !CUCCO_ENRAGED : !BLT ++
					PLA : BRA + ; we found an angry cucco, done
		++ : INX : BRA -- : .ldone
		
		;==== Create a Cucco
	
		CPY.b #$FF : BNE ++
			; we didn't find a cucco, so try to create one
			PLY
			CPY.b #$FF : BEQ + ; fail if no slots found
			LDA.b !CUCCO : STA.w !ENEMY_TYPE_TABLE, Y
			LDA.b !INIT : STA.w !ENEMY_STATE_TABLE, Y
			LDA.b !LINK_POS_Y_LOW : STA.w !ENEMY_POS_Y_LOW, Y
			LDA.b !LINK_POS_Y_HIGH : STA.w !ENEMY_POS_Y_HIGH, Y
			LDA.b !LINK_POS_X_LOW : STA.w !ENEMY_POS_X_LOW, Y
			LDA.b !LINK_POS_X_HIGH : STA.w !ENEMY_POS_X_HIGH, Y
			BRA +++
		++
			PLA
		+++
		
		;==== Enrage a Cucco
		
		LDA.b !CUCCO_ENRAGED : STA.w !ENEMY_AUX1_TABLE, Y ; enrage the cucco
		LDA.b #$00 : STA.w !ENEMY_AUX2_TABLE, Y : STA.w !ENEMY_DIRECTION_TABLE, Y
		
		;====
	+
RTL
;================================================================================
