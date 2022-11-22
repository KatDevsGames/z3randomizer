;================================================================================
!CUCCO = $0B
!INERT = $00
!INIT = $08
!ALIVE = $09
!CUCCO_ENRAGED = $23

CuccoStorm:

	SEP #$30 ; set 8-bit accumulator index registers
	LDA.l CuccoStormer : BEQ + ; only if storm is on
	LDA.b GameMode : CMP.b #$09 : BNE + ; only if outdoors
	LDA.l LoopFrames : AND.b #$7F : BNE + ; check every 128 frames

	-
		;==== Find a Cucco

		LDY.b #$FF : PHY ; push "cucco not found"

		LDX.b #$00 : -- : CPX.b #$10 : !BGE .ldone
			LDA.w SpriteAITable, X : CMP.b #!ALIVE : BEQ +++
				; enemy not found
				CMP.b #!INERT : BNE ++
					; log inert enemy slot
					PLA : PHX
					BRA ++
			+++
			; found an enemy
			LDA.l SpriteTypeTable, X : CMP.b #!CUCCO : BNE ++
				; it's a cucco
				TXY ; record where we found the living cucco in case we don't find any angry ones
				LDA.w SpriteAuxTable, X : CMP.b #!CUCCO_ENRAGED : !BLT ++
					PLA : BRA + ; we found an angry cucco, done
		++ : INX : BRA -- : .ldone
		
		;==== Create a Cucco
	
		CPY.b #$FF : BNE ++
			; we didn't find a cucco, so try to create one
			PLY
			CPY.b #$FF : BEQ + ; fail if no slots found
			LDA.b #!CUCCO : STA.w SpriteTypeTable, Y
			LDA.b #!INIT : STA.w SpriteAITable, Y
			LDA.b LinkPosY : STA.w SpritePosYLow, Y
			LDA.b LinkPosY+1 : STA.w SpritePosYHigh, Y
			LDA.b LinkPosX : STA.w SpritePosXLow, Y
			LDA.b LinkPosX+1 : STA.w SpritePosXHigh, Y
			BRA +++
		++
			PLA
		+++

		;==== Enrage a Cucco

		LDA.b #!CUCCO_ENRAGED : STA.w SpriteAuxTable, Y ; enrage the cucco
		LDA.b #$00 : STA.w SpriteAuxTable+$10, Y : STA.w SpriteDirectionTable, Y

		;====
	+
RTL
;================================================================================
