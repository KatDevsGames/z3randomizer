;================================================================================
; Stat Tracking
;================================================================================
; $7EF420 - $7EF466 - Stat Tracking
;--------------------------------------------------------------------------------
; $7EF420 - bonk counter
;--------------------------------------------------------------------------------
; $7EF421 yyyyyaaa
; y - y item counter
; a - a item counter
;--------------------------------------------------------------------------------
; $7EF422 ssshhccc
; s - sword counter
; h - shield counter
; c - crystal counter
;--------------------------------------------------------------------------------
; $7EF423 - item counter
;--------------------------------------------------------------------------------
; $7EF424 mmkkkkkk
; m - mail counter
; k - small keys
;--------------------------------------------------------------------------------
; $7EF425w[2] 1111 2222 3333 4444
; 1 - lvl 1 sword bosses
; 2 - lvl 2 sword bosses
; 3 - lvl 3 sword bosses
; 4 - lvl 4 sword bosses
;--------------------------------------------------------------------------------
; $7EF427 kkkkcccc
; k - big keys
; c - big chests
;--------------------------------------------------------------------------------
; $7EF428 mmmmcccc
; k - maps
; c - compases
;--------------------------------------------------------------------------------
; $7EF429 bbbb--pp
; b - heart containers
; p - pendant upgrades
;--------------------------------------------------------------------------------
; $7EF42A b-sccccc
; b - bomb acquired
; s - silver arrow bow acquired
; c - chests before gtower big key
;--------------------------------------------------------------------------------
; $7EF42Bw[2] - rupees spent
;--------------------------------------------------------------------------------
; $7EF42D - s&q counter
;--------------------------------------------------------------------------------
; $7EF42Ew[2] - loop frame counter (low)
;--------------------------------------------------------------------------------
; $7EF430w[2] - loop frame counter (high)
;--------------------------------------------------------------------------------
; $7EF432 - locations before boots
;--------------------------------------------------------------------------------
; $7EF433 - locations before mirror
;--------------------------------------------------------------------------------
; $7EF434 - hhhhdddd - item locations checked
; h - hyrule castle
; d - palace of darkness
;--------------------------------------------------------------------------------
; $7EF435 - dddhhhaa - item locations checked
; d - desert palace
; h - tower of hera
; a - agahnim's tower
;--------------------------------------------------------------------------------
; $7EF436 - gggggeee - item locations checked
; g - ganon's tower
; e - eastern palace
;--------------------------------------------------------------------------------
; $7EF437 - sssstttt - item locations checked
; s - skull woods
; t - thieves town
;--------------------------------------------------------------------------------
; $7EF438 - iiiimmmm - item locations checked
; i - ice palace
; m - misery mire
;--------------------------------------------------------------------------------
; $7EF439 - ttttssss - item locations checked
; t - turtle rock
; s - swamp palace
;--------------------------------------------------------------------------------
; $7EF43A - times mirrored outdoors
;--------------------------------------------------------------------------------
; $7EF43B - times mirrored in dungeons
;--------------------------------------------------------------------------------
; $7EF43Cw[2] - screen transition counter
;--------------------------------------------------------------------------------
; $7EF43Ew[2] - nmi frame counter (low)
;--------------------------------------------------------------------------------
; $7EF440w[2] - nmi frame counter (high)
;--------------------------------------------------------------------------------
; $7EF442 - chest counter
;--------------------------------------------------------------------------------
; $7EF443 - lock stats
;--------------------------------------------------------------------------------
; $7EF444w[2] - item menu frame counter (low)
;--------------------------------------------------------------------------------
; $7EF446w[2] - item menu frame counter (high)
;--------------------------------------------------------------------------------
; $7EF448 - ---hhhhh
; h - heart pieces
;--------------------------------------------------------------------------------
; $7EF449 - death counter
;--------------------------------------------------------------------------------
; $7EF44A - reserved
;--------------------------------------------------------------------------------
; $7EF44B - flute counter
;--------------------------------------------------------------------------------
; $7EF44Cl[3] - RTA-Timestamp (Start)
;--------------------------------------------------------------------------------
; $7EF44Fl[3] - RTA-Timestamp (End)
;--------------------------------------------------------------------------------
; $7EF452 - sssscccc
; s - swordless bosses
; c - capacity upgrades
;--------------------------------------------------------------------------------
; $7EF453 - fairy revival counter
;--------------------------------------------------------------------------------
; $7EF454w[2] - challenge timer (low)
;--------------------------------------------------------------------------------
; $7EF456w[2] - challenge timer (high)
;--------------------------------------------------------------------------------
; $7EF458w[2] - sword timestamp (low)
;--------------------------------------------------------------------------------
; $7EF45Aw[2] - sword timestamp (high)
;--------------------------------------------------------------------------------
; $7EF45Cw[2] - boots timestamp (low)
;--------------------------------------------------------------------------------
; $7EF45Ew[2] - boots timestamp (high)
;--------------------------------------------------------------------------------
; $7EF460w[2] - flute timestamp (low)
;--------------------------------------------------------------------------------
; $7EF462w[2] - flute timestamp (high)
;--------------------------------------------------------------------------------
; $7EF464w[2] - mirror timestamp (low)
;--------------------------------------------------------------------------------
; $7EF466w[2] - mirror timestamp (high)
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
!LOCK_STATS = "$7EF443"
;--------------------------------------------------------------------------------
!BONK_COUNTER = "$7EF420"
!BONK_REPEAT = "$7F503F"
!LOOP_FRAMES_LOW = "$7EF42E"
StatBonkCounter:
	PHA
		LDA !LOCK_STATS : BNE +
		LDA !LOOP_FRAMES_LOW : !SUB !BONK_REPEAT : CMP #30 : !BLT +
			LDA !LOOP_FRAMES_LOW : STA !BONK_REPEAT
			LDA !BONK_COUNTER : INC
			CMP.b #100 : BEQ + ; decimal 100
				STA !BONK_COUNTER
		+
	PLA
	JSL.l AddDashTremor ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
!SAVE_COUNTER = "$7EF42D"
StatSaveCounter:
	PHA
		LDA !LOCK_STATS : BNE +
		LDA $10 : CMP.b #$17 : BNE + ; not a proper s&q, link probably died
		LDA !SAVE_COUNTER : INC
		CMP.b #100 : BEQ + ; decimal 100
			STA !SAVE_COUNTER
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!SAVE_COUNTER = "$7EF42D"
DecrementSaveCounter:
	PHA
		LDA !LOCK_STATS : BNE +
			LDA !SAVE_COUNTER : DEC : STA !SAVE_COUNTER
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!TRANSITION_COUNTER = "$7EF43C"
DungeonHoleWarpTransition:
	LDA $01C31F, X
	BRA StatTransitionCounter
DungeonHoleEntranceTransition:
	JSL EnableForceBlank
	
	LDA.l SilverArrowsAutoEquip : AND.b #$02 : BEQ +
	LDA $010E : CMP.b #$7B : BNE + ; skip unless falling to ganon's room
	LDA !INVENTORY_SWAP_2 : AND.b #$40 : BEQ + ; skip if we don't have silvers
	LDA $7EF340 : BEQ + ; skip if we have no bow
	CMP.b #$03 : !BGE + ; skip if the bow is already silver
		!ADD #$02 : STA $7EF340 ; increase bow to silver
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
		LDA !LOCK_STATS : BNE +
		REP #$20 ; set 16-bit accumulator
		LDA !TRANSITION_COUNTER : INC
		CMP.w #999 : BEQ + ; decimal 999
			STA !TRANSITION_COUNTER
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
!FLUTE_COUNTER = "$7EF44B"
IncrementFlute:
	LDA !LOCK_STATS : BNE +
		LDA !FLUTE_COUNTER : INC : STA !FLUTE_COUNTER
	+
	JSL.l StatTransitionCounter ; also increment transition counter
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeys:
	STA $7EF36F ; thing we wrote over, write small key count
	PHX
		LDA !LOCK_STATS : BNE +
			JSL AddInventory_incrementKeyLong
		+
		JSL.l UpdateKeys
		PHY : LDY.b #24 : JSL.l FullInventoryExternal : PLY
		JSL.l HUD_RebuildLong
	PLX
RTL
;--------------------------------------------------------------------------------
IncrementSmallKeysNoPrimary:
	STA $7EF36F ; thing we wrote over, write small key count
	PHX
		LDA !LOCK_STATS : BNE +
			JSL AddInventory_incrementKeyLong
		+
		JSL.l UpdateKeys
		LDA $1B : BEQ + ; skip room check if outdoors
			PHP : REP #$20 ; set 16-bit accumulator
				LDA $048E : CMP.w #$0087 : BNE ++ ; hera basement
					PLP : PHY : LDY.b #24 : JSL.l FullInventoryExternal : PLY : BRA +
				++
			PLP
		+
		JSL.l HUD_RebuildLong
	PLX
RTL
;--------------------------------------------------------------------------------
DecrementSmallKeys:
	STA $7EF36F ; thing we wrote over, write small key count
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
		TYA : AND.B #$0F : BNE ++ ; If this is a sewers key, instead count it as an HC key
			INC
		++ TAX : BRA .count  ; use Key id instead of $040C (Keysanity)
		+ LDA $040C : LSR : TAX
		.count
		LDA $7EF4E0, X : INC : STA $7EF4E0, X
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
		LDA !LOCK_STATS : BNE +
			JSL AddInventory_incrementBossSwordLong
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!DEATH_COUNTER = "$7EF449"
IncrementDeathCounter:
	PHA
		LDA !LOCK_STATS : BNE +
		LDA $7EF36D : BNE + ; link is still alive, skip
			LDA !DEATH_COUNTER : INC : STA !DEATH_COUNTER
			;JSL.l DecrementSaveCounter
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!FAIRY_COUNTER = "$7EF453"
IncrementFairyRevivalCounter:
	STA $7EF35C, X ; thing we wrote over
	PHA
		LDA !LOCK_STATS : BNE +
			LDA !FAIRY_COUNTER : INC : STA !FAIRY_COUNTER
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!CHEST_COUNTER = "$7EF442"
IncrementChestCounter:
	LDA.b #$01 : STA $02E9 ; thing we wrote over
	PHA
		LDA !LOCK_STATS : BNE +
			LDA !CHEST_COUNTER : INC : STA !CHEST_COUNTER
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!CHEST_COUNTER = "$7EF442"
DecrementChestCounter:
	PHA
		LDA !LOCK_STATS : BNE +
			LDA !CHEST_COUNTER : DEC : STA !CHEST_COUNTER
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!ITEM_TOTAL = "$7EF423"
DecrementItemCounter:
	PHA
		LDA !LOCK_STATS : BNE +
			LDA !ITEM_TOTAL : DEC : STA !ITEM_TOTAL
		+
	PLA
RTL
;--------------------------------------------------------------------------------
IncrementBigChestCounter:
	JSL.l Dungeon_SaveRoomQuadrantData ; thing we wrote over
	PHA
		LDA !LOCK_STATS : BNE +
			%BottomHalf($7EF427)
		+
	PLA
RTL
;--------------------------------------------------------------------------------
!OW_MIRROR_COUNTER = "$7EF43A"
IncrementOWMirror:
	PHA
		LDA !LOCK_STATS : BNE +
		LDA $7EF3CA : BEQ + ; only do this for DW->LW
			LDA !OW_MIRROR_COUNTER : INC : STA !OW_MIRROR_COUNTER
		+
	PLA
JMP StatTransitionCounter
;--------------------------------------------------------------------------------
!UW_MIRROR_COUNTER = "$7EF43B"
IncrementUWMirror:
	PHA
		LDA !LOCK_STATS : BNE +
		LDA $040C : CMP #$FF : BEQ + ; skip if we're in a cave or house
			LDA !UW_MIRROR_COUNTER : INC : STA !UW_MIRROR_COUNTER
			JSL.l StatTransitionCounter
		+
	PLA
	JSL.l Dungeon_SaveRoomData ; thing we wrote over
RTL
;--------------------------------------------------------------------------------
!SPENT_RUPEES = "$7EF42B"
IncrementSpentRupees:
    DEC A : BPL .subtractRupees
    LDA.w #$0000 : STA $7EF360
RTL
	.subtractRupees
	PHA : PHP
	LDA !LOCK_STATS : AND.w #$00FF : BNE +
		LDA !SPENT_RUPEES : INC
		CMP.w #9999 : BEQ + ; decimal 9999
			STA !SPENT_RUPEES
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
!CHEST_COUNTER = "$7EF442"
!MAIL_COUNTER = "$7EF424" ; mmkkkkkk
!BOSS_KILLS = "$7F5037"
!SWORD_KILLS_1 = "$7EF425"
!SWORD_KILLS_2 = "$7EF426"
!GTOWER_PRE_BIG_KEY = "$7EF42A" ; ---ccccc
!NONCHEST_COUNTER = "$7F503E"
!SAVE_COUNTER = "$7EF42D"
!TRANSITION_COUNTER = "$7EF43C"

!NMI_COUNTER = "$7EF43E"
!LOOP_COUNTER = "$7EF42E"
!LAG_TIME = "$7F5038"

!RUPEES_COLLECTED = "$7F503C"
!ITEM_TOTAL = "$7EF423"

!RTA_END = "$7EF44F"
StatsFinalPrep:
	PHA : PHX : PHP
		SEP #$30 ; set 8-bit accumulator and index registers
		
		LDA !LOCK_STATS : BNE .ramPostOnly
		INC : STA !LOCK_STATS
	
		JSL.l AddInventory_incrementBossSwordLong
	
		LDA !MAIL_COUNTER : !ADD #$40 : STA !MAIL_COUNTER ; add green mail to mail count
	
		;LDA !GTOWER_PRE_BIG_KEY : DEC : AND #$1F : TAX
		;LDA !GTOWER_PRE_BIG_KEY : AND #$E0 : STA !GTOWER_PRE_BIG_KEY
		;TXA : ORA !GTOWER_PRE_BIG_KEY : STA !GTOWER_PRE_BIG_KEY
		
		LDA !TRANSITION_COUNTER : DEC : STA !TRANSITION_COUNTER ; remove extra transition from exiting gtower via duck
		
		.ramPostOnly
		LDA !SWORD_KILLS_1 : LSR #4 : !ADD !SWORD_KILLS_1 : STA !BOSS_KILLS
		LDA !SWORD_KILLS_2 : LSR #4 : !ADD !SWORD_KILLS_2 : !ADD !BOSS_KILLS : AND #$0F : STA !BOSS_KILLS
	
		LDA !NMI_COUNTER : !SUB !LOOP_COUNTER : STA !LAG_TIME
		LDA !NMI_COUNTER+1 : SBC !LOOP_COUNTER+1 : STA !LAG_TIME+1
		LDA !NMI_COUNTER+2 : SBC !LOOP_COUNTER+2 : STA !LAG_TIME+2
		LDA !NMI_COUNTER+3 : SBC !LOOP_COUNTER+3 : STA !LAG_TIME+3
	
		LDA !SPENT_RUPEES : !ADD $7EF362 : STA !RUPEES_COLLECTED
		LDA !SPENT_RUPEES+1 : ADC $7EF363 : STA !RUPEES_COLLECTED+1
	
		LDA !ITEM_TOTAL : !SUB !CHEST_COUNTER : STA !NONCHEST_COUNTER
		
		;LDA $FFFFFF
		;JSL.l Clock_IsSupported
		;BRA +
		;	REP #$20 ; set 16-bit accumulator
		;
		;	LDA $00 : PHA
		;	LDA $02 : PHA
		;
		;	JSL.l Clock_QuickStamp
		;	LDA $00 : STA !RTA_END
		;	LDA $02 : STA !RTA_END+2
		;
		;	PLA : STA $02
		;	PLA : STA $00
		;+
		
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
