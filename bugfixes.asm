;================================================================================

;--------------------------------------------------------------------------------
AssignKiki:
    LDA.b #$00 : STA.l FollowerDropped ; defuse bomb
    LDA.b #$0A : STA.l FollowerIndicator ; assign kiki as follower
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Name: AllowSQ
; Returns: Accumulator = 0 if S&Q is disallowed, 1 if allowed
;--------------------------------------------------------------------------------
AllowSQ:
	LDA.l ProgressIndicator : BEQ .done ; thing we overwrote - check if link is in his bed
	LDA.l BusyItem : EOR.b #$01
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Reset Music
;1 = Don't Reset Music
MSMusicReset:
	LDA.b OverworldIndex : CMP.b #$80 : BNE +
		LDA.b LinkPosX+1
	+
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Become (Perma)bunny
DecideIfBunny:
	LDA.l MoonPearlEquipment : BNE .done
	LDA.l CurrentWorld : AND.b #$40
	PHA : LDA.l InvertedMode : BNE .inverted
	.normal
		PLA : EOR.b #$40
		BRA .done
	.inverted
		PLA
	.done
RTL
;--------------------------------------------------------------------------------
;0 = Become (Perma)bunny
DecideIfBunnyByScreenIndex:
	; If indoors we don't have a screen index. Return non-bunny to make mirror-based
	; superbunny work
	LDA.b IndoorsFlag : BNE .done
	LDA.l MoonPearlEquipment : BNE .done
	LDA.b OverworldIndex : AND.b #$40 : PHA
	LDA.l InvertedMode : BNE .inverted
	.normal
		PLA : EOR #$40
		BRA .done
	.inverted
		PLA
	.done
RTL
;--------------------------------------------------------------------------------
FixBunnyOnExitToLightWorld:
    LDA.w BunnyFlag : BEQ +
        JSL.l DecideIfBunny : BEQ +
        STZ.b LinkState ; set player mode to Normal
        STZ.w BunnyFlag : STZ.b BunnyFlagDP ; return player graphics to normal
    +
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; fix issue where if a player beats aga1 without moon pearl, they don't turn into
; bunny on the pyramid
FixAga2Bunny:
    LDA.l FixFakeWorld :  BEQ + ; Only use this fix is fakeworld fix is in use
        LDA.l InvertedMode : BEQ +++
            LDA.b #$00 : STA.l CurrentWorld ; Switch to light world
            BRA ++
        +++
        LDA.b #$40 : STA.l CurrentWorld ; Switch to dark world
    ++
	JSL DecideIfBunny : BNE +
		JSR MakeBunny
		LDA.b #$04 : STA.w MusicControlRequest ; play bunny music
		BRA .done
	+
	LDA.b #$09 : STA.w MusicControlRequest ; what we wrote over
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
MakeBunny:
    PHX : PHY
	LDA.b #$17 : STA.b LinkState ; set player mode to permabunny
	LDA.b #$01 : STA.w BunnyFlag : STA.b BunnyFlagDP ; make player look like bunny
	JSL LoadGearPalettes_bunny
    PLY : PLX
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; fix issue where cross world caves (in Entrance randomizer) don't cause
; frog to become smith or vice versa.
FixFrogSmith:
	LDA.l CurrentWorld : BNE .darkWorld
		LDA.l FollowerIndicator : CMP.b #$07 : BNE .done
		LDA.b #$08 ; make frog into smith in light world
		BRA .loadgfx
	.darkWorld
		LDA.l FollowerIndicator : CMP.b #$08 : BNE .done
		LDA.b #$07 ; make smith into frog in dark world
	.loadgfx
		STA.l FollowerIndicator
		JSL Tagalong_LoadGfx
	.done
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Fix for SQ jumping causing accidental Exploration Glitch
SQEGFix:
	LDA.l Bugfix_PodEG : BEQ ++
	STZ.w LayerAdjustment ; disarm exploration glitch
++	RTL

;--------------------------------------------------------------------------------
; Fix crystal not spawning when using somaria vs boss
TryToSpawnCrystalUntilSuccess:
	STX.w ItemReceiptID ; what we overwrote
	JSL AddAncillaLong : BCS .failed ; a clear carry flag indicates success
.spawned
	STZ.b RoomTag ; the "trying to spawn crystal" flag
	STZ.b RoomTag+1 ; the "trying to spawn pendant" flag
.failed
RTL

;--------------------------------------------------------------------------------
; Fix crystal not spawning when using somaria vs boss
WallmasterCameraFix:
	STZ.b CameraBoundV    ; disable vertical camera scrolling for current room
	REP #$20
	STZ.w CameraScrollN  ; something about scrolling, setting these to 0 tricks the game 
	STZ.w CameraScrollS  ; into thinking we're at the edge of the room so it doesn't scroll.
	SEP #$20
	JML Sound_SetSfx3PanLong ; what we wrote over, also this will RTL

;--------------------------------------------------------------------------------
; Fix losing glove colors
LoadActualGearPalettesWithGloves:
REP #$20
LDA.l SwordEquipment : STA.b Scrap0C
LDA.l ArmorEquipment : AND.w #$00FF
JSL LoadGearPalettes_variable
JSL SpriteSwap_Palette_ArmorAndGloves_part_two
RTL

;--------------------------------------------------------------------------------
; Fix Bunny Palette Map Bug
LoadGearPalette_safe_for_bunny:
LDA.b GameMode 
CMP.w #$030E : BEQ .new ; opening dungeon map
CMP.w #$070E : BEQ .new ; opening overworld map
.original
-
	LDA.b [Scrap00]
	STA.l PaletteBufferAux, X
	STA.l PaletteBuffer, X
	INC.b Scrap00 : INC.b Scrap00
	INX #2
	DEY
	BPL -
RTL
.new
-
	LDA.b [Scrap00]
	STA.l PaletteBuffer, X
	INC.b Scrap00 : INC.b Scrap00
	INX #2
	DEY
	BPL -
RTL

;--------------------------------------------------------------------------------
; Fix pedestal pull overlay
PedestalPullOverlayFix:
LDA.b #$09 : STA.w AncillaGeneral, X ; the thing we wrote over
LDA.b IndoorsFlag : BNE +
        LDA.b OverworldIndex : CMP.b #$80 : BNE +
                LDA.b OverlayID : CMP.b #$97
+
RTL

;--------------------------------------------------------------------------------
FixJingleGlitch:
	LDA.b GameSubMode
	BEQ .set_doors

	LDA.l AllowAccidentalMajorGlitch
	BEQ .exit

.set_doors
	LDA.b #$05
	STA.b GameSubMode

.exit
	RTL
;--------------------------------------------------------------------------------
; Fix spawning with more hearts than capacity when less than 3 heart containers
pushpc
        org $09F4AC ; <- module_death.asm:331
        db $08, $08, $10
pullpc
;--------------------------------------------------------------------------------
SetOverworldTransitionFlags:
	LDA.b #$01
	STA.w OWTransitionFlag
	STA.w RaceGameFlag
	RTL
;--------------------------------------------------------------------------------
ParadoxCaveGfxFix:
    ; Always upload line unless you're moving into paradox cave (0x0FF) from above (0x0EF)
    LDA.b IndoorsFlag  : BEQ .uploadLine
    LDX.b RoomIndex    : CPX.w #$00FF : BNE .uploadLine
    LDX.b PreviousRoom : CPX.w #$00EF : BNE .uploadLine

    ;Ignore uploading four specific lines of tiles to VRAM
    LDX.w VRAMUploadAddress
    ; Line 1
    CPX.w #$1800 : BEQ .skipMostOfLine
    ; Line 2
    CPX.w #$1A00 : BEQ .skipMostOfLine
    ; Line 3
    CPX.w #$1C00 : BEQ .uploadLine
    ; Line 4
    CPX.w #$1E00 : BEQ .uploadLine

.uploadLine
    LDA.b #$01 : STA.w MDMAEN

.skipLine
    RTL

.skipMostOfLine
    ; Set line length to 192 bytes (the first 6 8x8 tiles in the line)
    LDX.w #$00C0 : STX.w DAS0L
    BRA .uploadLine
;--------------------------------------------------------------------------------
SetItemRiseTimer:
        LDA.w ItemReceiptMethod : CMP #$01 : BNE .not_from_chest
                LDA.b #$38 : STA.w AncillaTimer, X
                RTL
        .not_from_chest
        TYA : STA.w AncillaTimer, X ; What we wrote over
RTL
