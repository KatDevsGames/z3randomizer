;================================================================================
; Stat Tracking
;================================================================================
; $7EF420 - $7EF468 - Stat Tracking
;
; See sram.asm for adresses and documentation of stat values
;--------------------------------------------------------------------------------
IncrementBonkCounter:
	LDA StatsLocked : BNE +
		LDA BonkCounter : INC
		CMP.b #100 : BEQ + ; decimal 100
			STA BonkCounter
	+
RTL
;--------------------------------------------------------------------------------
StatSaveCounter:
	PHA
		LDA StatsLocked : BNE +
		LDA $10 : CMP.b #$17 : BNE + ; not a proper s&q, link probably died
		LDA SaveQuitCounter : INC
		CMP.b #100 : BEQ + ; decimal 100
			STA SaveQuitCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementSaveCounter:
	PHA
		LDA StatsLocked : BNE +
			LDA SaveQuitCounter : DEC : STA SaveQuitCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DungeonHoleWarpTransition:
	LDA $01C31F, X
	BRA StatTransitionCounter
DungeonHoleEntranceTransition:
	JSL EnableForceBlank
	
	LDA.l SilverArrowsAutoEquip : AND.b #$02 : BEQ +
	LDA $010E : CMP.b #$7B : BNE + ; skip unless falling to ganon's room
	LDA BowTracking : AND.b #$40 : BEQ + ; skip if we don't have silvers
	LDA BowEquipment : BEQ + ; skip if we have no bow
	CMP.b #$03 : !BGE + ; skip if the bow is already silver
		!ADD #$02 : STA BowEquipment ; increase bow to silver
	+
	
	BRA StatTransitionCounter
DungeonStairsTransition:
	JSL Dungeon_SaveRoomQuadrantData
	BRA StatTransitionCounter
DungeonExitTransition:
	LDA $7F50C7 : BEQ + ; ice physics
		JSL Player_HaltDashAttackLong
		LDA.b #$00 : STA $0301 ; stop item dashing
	+
	LDA.b #$0F : STA $10 ; stop running through the transition
StatTransitionCounter:
	PHA : PHP
		LDA StatsLocked : BNE +
		REP #$20 ; set 16-bit accumulator
		LDA ScreenTransitions : INC
		CMP.w #999 : BEQ + ; decimal 999
			STA ScreenTransitions
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IncrementFlute:
	LDA StatsLocked : BNE +
		LDA FluteCounter : INC : STA FluteCounter
	+
	JSL.l StatTransitionCounter ; also increment transition counter
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeys:
	STA CurrentSmallKeys ; thing we wrote over, write small key count
	PHX
		LDA StatsLocked : BNE +
			JSL AddInventory_incrementKeyLong
		+
		JSL.l UpdateKeys
		PHY : LDY.b #24 : JSL.l FullInventoryExternal : PLY
		JSL.l HUD_RebuildLong
	PLX
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeysNoPrimary:
	STA CurrentSmallKeys ; thing we wrote over, write small key count
	PHX
		LDA StatsLocked : BNE +
			JSL AddInventory_incrementKeyLong
		+
		JSL.l UpdateKeys
		LDA $1B : BEQ + ; skip room check if outdoors
			PHP : REP #$20 ; set 16-bit accumulator
				LDA $048E : CMP.w #$0087 : BNE ++ ; hera basement
					PLP : PHY : LDY.b #$24 : JSL.l FullInventoryExternal
					JSR CountChestKey : PLY : BRA +
				++
			PLP
		+
		JSL.l HUD_RebuildLong
	PLX
RTL
;--------------------------------------------------------------------------------
DecrementSmallKeys:
	STA CurrentSmallKeys ; thing we wrote over, write small key count
	JSL.l UpdateKeys
RTL
;--------------------------------------------------------------------------------
CountChestKeyLong: ; called from ItemDowngradeFix in itemdowngrade.asm
	JSR CountChestKey
RTL
;--------------------------------------------------------------------------------
CountChestKey: ; called by neighbor functions
	PHA : PHX
		CPY #$24 : BEQ +  ; small key for this dungeon - use $040C
			CPY #$A0 : !BLT .end ; Ignore most items
			CPY #$AE : !BGE .end ; Ignore reserved key and generic key
			TYA : AND.B #$0F : BNE ++ ; If this is an HC key, instead count it as a sewers key
				INC
			++ TAX : BRA .count  ; use Key id instead of $040C (Keysanity)
		+ LDA $040C : LSR
		BNE +
			INC ; combines HC and Sewer counts
		+ TAX
		.count
		LDA DungeonCollectedKeys, X : INC : STA DungeonCollectedKeys, X
   .end
	PLX : PLA
RTS
;--------------------------------------------------------------------------------
CountBonkItem: ; called from GetBonkItem in bookofmudora.asm
	LDA $A0 ; check room ID - only bonk keys in 2 rooms so we're just checking the lower byte
	CMP #115 : BNE + ; Desert Bonk Key
		LDA.L BonkKey_Desert : BRA ++
	+ : CMP #140 : BNE + ; GTower Bonk Key
		LDA.L BonkKey_GTower : BRA ++
	+ LDA.B #$24 ; default to small key
	++
	CMP #$24 : BNE +
		PHY
			TAY : JSR CountChestKey
		PLY
	+
RTL
;--------------------------------------------------------------------------------
IncrementAgahnim2Sword:
	PHA
		LDA StatsLocked : BNE +
			JSL AddInventory_incrementBossSwordLong
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementDeathCounter:
	PHA
		LDA StatsLocked : BNE +
		LDA CurrentHealth : BNE + ; link is still alive, skip
			LDA DeathCounter : INC : STA DeathCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementFairyRevivalCounter:
	STA BottleContents, X ; thing we wrote over
	PHA
		LDA StatsLocked : BNE +
			LDA FaerieRevivalCounter : INC : STA FaerieRevivalCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementChestTurnCounter:
	PHA
		LDA StatsLocked : BNE +
			LDA ChestTurnCounter : INC : STA ChestTurnCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementChestCounter:
	LDA.b #$01 : STA $02E9 ; thing we wrote over
	PHA
		LDA StatsLocked : BNE +
			LDA ChestsOpened : INC : STA ChestsOpened
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementChestCounter:
	PHA
		LDA StatsLocked : BNE +
			LDA ChestsOpened : DEC : STA ChestsOpened
		+
	PLA
RTL
;--------------------------------------------------------------------------------
DecrementItemCounter:
	PHA
		LDA StatsLocked : BNE +
                        REP #$20
			LDA TotalItemCounter : DEC : STA TotalItemCounter
                        SEP #$20
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementBigChestCounter:
	JSL.l Dungeon_SaveRoomQuadrantData ; thing we wrote over
	PHA
		LDA StatsLocked : BNE +
			%BottomHalf(BigKeysBigChests)
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementDamageTakenCounter_Eight:
	STA.l CurrentHealth
	PHA : PHP
	LDA StatsLocked : BNE +
	REP #$21
	LDA.l DamageCounter
	ADC.w #$0008
	BCC ++
	LDA.w #$FFFF
++	STA.l DamageCounter
+	PLP
	PLA
	RTL

IncrementDamageTakenCounter_Arb:
	PHP
	LDA StatsLocked : BNE +
	REP #$21
	LDA.b $00
	AND.w #$00FF
	ADC.l DamageCounter
	BCC ++
	LDA.w #$FFFF
++	STA.l DamageCounter
+	PLP

	LDA.l CurrentHealth
	RTL

IncrementMagicUseCounter:
	STA.l CurrentMagic

IncrementMagicUseCounterByrna:
	PHA : PHP
	LDA StatsLocked : BNE +
	REP #$21
	LDA.b $00
	AND.w #$00FF
	ADC.l MagicCounter
	BCC ++
	LDA.w #$FFFF
++	STA.l MagicCounter
+	PLP : PLA

	RTL

IncrementMagicUseCounterOne:
	LDA StatsLocked : BNE +
	REP #$20
	LDA.l MagicCounter
	INC
	BEQ ++
	STA.l MagicCounter
++	SEP #$20
+	LDA.l CurrentMagic
	RTL

;--------------------------------------------------------------------------------
IncrementOWMirror:
	PHA
		LDA #$08 : STA $021B ; fail race game
		LDA StatsLocked : BNE +
		LDA CurrentWorld : BEQ + ; only do this for DW->LW
			LDA OverworldMirrors : INC : STA OverworldMirrors
		+
	PLA
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
IncrementUWMirror:
	PHA
		LDA.b #$00 : STA $7F5035 ; bandaid patch bug with mirroring away from text
		LDA StatsLocked : BNE +
		LDA $040C : CMP #$FF : BEQ + ; skip if we're in a cave or house
			LDA UnderworldMirrors : INC : STA UnderworldMirrors
			JSL.l StatTransitionCounter
		+
	PLA
	JSL.l Dungeon_SaveRoomData ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
IncrementSpentRupees:
    DEC A : BPL .subtractRupees
    LDA.w #$0000 : STA CurrentRupees
RTL
	.subtractRupees
	PHA : PHP
	LDA StatsLocked : AND.w #$00FF : BNE +
		LDA RupeesSpent : INC
		CMP.w #9999 : BEQ + ; decimal 9999
			STA RupeesSpent
	+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IndoorTileTransitionCounter:
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
!REDRAW = "$7F5000"
IndoorSubtileTransitionCounter:
	LDA.b #$01 : STA !REDRAW ; set redraw flag for items
    STZ $0646 ; stuff we wrote over
    STZ $0642
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
!BOSS_KILLS = "$7F5037"
!NONCHEST_COUNTER = "$7F503E"

!LAG_TIME = "$7F5038"

!RUPEES_COLLECTED = "$7F503C"

StatsFinalPrep:
	PHA : PHX : PHP
		SEP #$30 ; set 8-bit accumulator and index registers
		
		LDA StatsLocked : BNE .ramPostOnly
		INC : STA StatsLocked
	
		JSL.l AddInventory_incrementBossSwordLong
	
		LDA HighestMail : INC : STA HighestMail ; add green mail to mail count
		
		LDA ScreenTransitions : DEC : STA ScreenTransitions ; remove extra transition from exiting gtower via duck
		
		.ramPostOnly
		LDA SwordBossKills : LSR #4 : !ADD SwordBossKills : STA !BOSS_KILLS
		LDA SwordBossKills+1 : LSR #4 : !ADD SwordBossKills+1 : !ADD !BOSS_KILLS : AND #$0F : STA !BOSS_KILLS
	
		LDA NMIFrames : !SUB LoopFrames : STA !LAG_TIME
		LDA NMIFrames+1 : SBC LoopFrames+1 : STA !LAG_TIME+1
		LDA NMIFrames+2 : SBC LoopFrames+2 : STA !LAG_TIME+2
		LDA NMIFrames+3 : SBC LoopFrames+3 : STA !LAG_TIME+3
	
		LDA RupeesSpent : !ADD DisplayRupees : STA !RUPEES_COLLECTED
		LDA RupeesSpent+1 : ADC DisplayRupees+1 : STA !RUPEES_COLLECTED+1

                REP #$20
		LDA TotalItemCounter : !SUB ChestsOpened : STA !NONCHEST_COUNTER

		.done
	PLP : PLX : PLA
	LDA.b #$19 : STA $10 ; thing we wrote over, load triforce room
        STZ $11
        STZ $B0
RTL
;--------------------------------------------------------------------------------
; Notes:
; s&q counter
;================================================================================
