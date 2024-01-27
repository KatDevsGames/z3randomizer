;--------------------------------------------------------------------------------
; LockAgahnimDoors:
; Returns: 0=Unlocked - 1=Locked
;--------------------------------------------------------------------------------
LockAgahnimDoors:
	LDA.l AgahnimDoorStyle : AND.w #$00FF
	BNE +
		;#$0 = Never Locked
		LDA.w #$0000 : RTL
	+ : CMP.w #$0001 : BNE +
		LDA.l ProgressIndicator : AND.w #$000F : CMP.w #$0002 : !BGE .unlock ; if we rescued zelda, skip
			JSR.w LockAgahnimDoorsCore : RTL
	+ : CMP.w #$0002 : BNE +
		JSR.w LockAgahnimDoorsCore : BEQ .unlock
		PHX : PHY
		SEP #$30
		JSL.l CheckTowerOpen
		REP #$30
		PLY : PLX
		!BGE .crystalOrUnlock
		LDA.w #$0001 : RTL
		.crystalOrUnlock
		LDA.l InvertedMode : AND.w #$00FF : BEQ .unlock

		LDA.l OverworldEventDataWRAM+$43 : AND.w #$0020 : BNE .unlock ; Check if GT overlay is already on or not
		LDA.w AButtonAct : AND.w #$0080 : BEQ ++ ;If we are holding an item

	.locked
			LDA.w #$0001 : RTL ;Keep the door locked
		++
		SEP #$30
		JSL $899B6F ;Add tower break seal
		REP #$30
		LDA.w #$0001 ;Prevent door from opening that frame otherwise it glitchy
		RTL

	+
	.unlock

	LDA.w #$0000 ; fallback to never locked

RTL
;---------------------------------------------------------------------------------
FlagAgahnimDoor:
	LDA.l InvertedMode : BEQ .vanilla

	LDA.l OverworldEventDataWRAM+$43 : ORA.b #$20 : STA.l OverworldEventDataWRAM+$43 ; activate GT overlay

.vanilla
	LDA.b #$28 : STA.b ScrapBuffer72
	RTL


;--------------------------------------------------------------------------------
LockAgahnimDoorsCore:
	LDA.b LinkPosX : CMP.w #1992 : !BLT + ; door too far left, skip
			  CMP.w #2088 : !BGE + ; door too rat right, skip
	LDA.b LinkPosY : CMP.w #1720 : !BGE + ; door too low, skip
		LDA.w #$0001
RTS
	+
	LDA.w #$0000
RTS
;--------------------------------------------------------------------------------
SmithDoorCheck:
	LDA.l SmithTravelsFreely : AND.w #$00FF : BEQ .orig
		;If SmithTravelsFreely is set Frog/Smith can enter multi-entrance overworld doors
		JML.l Overworld_Entrance_BRANCH_RHO

	.orig ; The rest is equivlent to what we overwrote
	CPX.w #$0076 : !BGE +
		JML.l Overworld_Entrance_BRANCH_LAMBDA
	+

JML.l Overworld_Entrance_BRANCH_RHO
;--------------------------------------------------------------------------------
AllowStartFromSingleEntranceCave:
; 16 Bit A, 16 bit XY
; do not need to preserve A or X or Y
	LDA.l StartingEntrance : AND.w #$00FF ; What we wrote over
	PHA
		TAX
		LDA.l StartingAreaExitOffset, X
                AND.w #$00FF

		BNE +
			JMP .done
		+
		DEC
		STA.b Scrap00
		ASL #2 : !ADD Scrap00 : ASL #2 ; mult by 20
		TAX

		LDA.w #$0016 : STA.l EN_MAINDESQ ; Cache the main screen designation
		LDA.l StartingAreaExitTable+$05, X : STA.l EN_BG2VERT ; Cache BG1 V scroll
		LDA.l StartingAreaExitTable+$07, X : STA.l EN_BG2HORZ ; Cache BG1 H scroll
		LDA.l StartingAreaExitTable+$09, X : !ADD.w #$0010 : STA.l EN_POSY ; Cache Link's Y coordinate
		LDA.l StartingAreaExitTable+$0B, X : STA.l EN_POSX ; Cache Link's X coordinate
		LDA.l StartingAreaExitTable+$0D, X : STA.l EN_SCROLLATN ; Cache Camera Y coord lower bound.
		LDA.l StartingAreaExitTable+$0F, X : STA.l EN_SCROLLATW ; Cache Camera X coord lower bound.
		LDA.l StartingAreaExitTable+$03, X : STA.l EN_OWTMAPI ; Cache Link VRAM Location

		; Handle the 2 "unknown" bytes, which control what area of the backgound
		; relative to the camera? gets loaded with new tile data as the player moves around
		; (because some overworld areas like Kak are too big for a single VRAM tilemap)

		LDA.l StartingAreaExitTable+$11, X : AND.w #$00FF
		BIT.w #$0080 : BEQ + : ORA.w #$FF00 : + ; Sign extend
		STA.l EN_SCRMODYA

		LDA.l StartingAreaExitTable+$12, X  : AND.w #$00FF
		BIT.w #$0080 : BEQ + : ORA.w #$FF00 : + ; Sign extend
		STA.l EN_SCRMODXA

		LDA.w #$0000 : !SUB.l EN_SCRMODYA : STA.l EN_SCRMODYB
		LDA.w #$0000 : !SUB.l EN_SCRMODXA : STA.l EN_SCRMODXB

		LDA.l StartingAreaExitTable+$02, X : AND.w #$00FF
		STA.l EN_OWSCR ; Cache the overworld area number
		STA.l EN_OWSCR2 ; Cache the aux overworld area number

		STZ.w TileMapTile32 ;zero out door overlays in case starting overworld door is not set
		STZ.w TileMapTile32+1 ;zero out door overlays in case starting overworld door is not set

		SEP #$20 ; set 8-bit accumulator
		LDA.l StartingEntrance : TAX
		LDA.l StartingAreaOverworldDoor, X : STA.l PreviousOverworldDoor ;Load overworld door
		REP #$20 ; reset 16-bit accumulator
                JSL.l CacheDoorFrameData

		.done
	PLA
RTL
;--------------------------------------------------------------------------------
AllowStartFromExit:

	LDX.w MessageCursor
	LDA.l ShouldStartatExit, X : BNE .doStart

	LDA.l StartingEntrance ; what we wrote over
JML.l AllowStartFromExitReturn

	.doStart

	LDA.l $828481, X ;Module_LocationMenu_starting_points
	ASL : TAX

	LDA.l $82D8D2, X : STA.b RoomIndex
	LDA.l $82D8D3, X : STA.b RoomIndex+1

	; Go to pre-overworld mode
	LDA.b #$08 : STA.b GameMode

	STZ.b GameSubMode
	STZ.b SubSubModule
	STZ.w DeathReloadFlag
	STZ.w RespawnFlag
	LDA.b #$01 : STA.l UpdateHUDFlag

	JSL Equipment_SearchForEquippedItemLong
	JSL HUD_RebuildLong2
	JSL Equipment_UpdateEquippedItemLong
RTL

;--------------------------------------------------------------------------------
CheckHole:
	LDX.w #$0024
	.nextHoleClassic
		LDA.b Scrap00   : CMP.l $9BB800, X
		BNE .wrongMap16Classic
		LDA.b OverworldIndex : CMP.l $9BB826, X
		BEQ .matchedHoleClassic
	.wrongMap16Classic
		DEX #2 : BPL .nextHoleClassic

	LDX.w #$001E
	.nextHoleExtra
		LDA.b Scrap00   : CMP.l ExtraHole_Map16, X
		BNE .wrongMap16Extra
		LDA.b OverworldIndex : CMP.l ExtraHole_Area, X
		BEQ .matchedHoleExtra
	.wrongMap16Extra
		DEX #2 : BPL .nextHoleExtra
	JML Overworld_Hole_GotoHoulihan

	.matchedHoleClassic
		JML Overworld_Hole_matchedHole
	.matchedHoleExtra
		SEP #$30
		TXA : LSR A : TAX
		LDA.l ExtraHole_Entrance, X : STA.w EntranceIndex : STZ.w EntranceIndex+1
JML Overworld_Hole_End
;--------------------------------------------------------------------------------
PreventEnterOnBonk:
	STA.b Scrap00 ; part of what we wrote over
	LDA.l InvertedMode : AND.w #$00FF : BEQ .done
	LDA.b LinkState : AND.w #$00FF : CMP.w #$0014 : BNE .done ;in mirror mode?
	LDA.b OverworldIndex : AND.w #$0040 : CMP.b WorldCache : BEQ .done ; Are we bonking, or doing the superbunny glitch?

		; If in inverted, are in mirror mode, and are bonking then do not enter
		JML.l PreventEnterOnBonk_BRANCH_IX

	.done
	LDX.w #$0102 ; rest of what we wrote over
JML.l PreventEnterOnBonk_return
;--------------------------------------------------------------------------------
TurtleRockEntranceFix:
	LDA.l TurtleRockAutoOpenFix : BEQ .done
	LDA.b OverworldIndex : CMP.b #$47 : BNE .done
		;If exiting to turtle rock ensure the entrance is open
		LDA.l OverworldEventDataWRAM+$47 : ORA.b #$20 : STA.l OverworldEventDataWRAM+$47
.done
RTL
;--------------------------------------------------------------------------------
AnimatedEntranceFix: ;when an entrance animation tries to start
	PHA
	LDA.l InvertedMode : BEQ + ;If we are in inverted mode
	LDA.b OverworldIndex : AND.b #$40 : BNE + ;and in the light world
		PLA
		STZ.w OWEntranceCutscene ; skip it.
		LDA.b #$00
		RTL
	+
	PLA
	STA.w CutsceneFlag ;what we wrote over
	STA.w FreezeSprites ;what we wrote over
	STA.w SkipOAM ;what we wrote over
RTL
