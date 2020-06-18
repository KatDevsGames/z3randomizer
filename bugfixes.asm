;================================================================================

;--------------------------------------------------------------------------------
AssignKiki:
    LDA.b #$00 : STA $7EF3D3 ; defuse bomb
    LDA.b #$0A : STA $7EF3CC ; assign kiki as follower
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Name: AllowSQ
; Returns: Accumulator = 0 if S&Q is disallowed, 1 if allowed
;--------------------------------------------------------------------------------
!ITEM_BUSY = "$7F5091"
AllowSQ:
	LDA $7EF3C5 : BEQ .done ; thing we overwrote - check if link is in his bed
	LDA !ITEM_BUSY : EOR #$01
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Reset Music
;1 = Don't Reset Music
MSMusicReset:
	LDA $8A : CMP.b #$80 : BNE +
		LDA $23
	+
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Become (Perma)bunny
DecideIfBunny:
	LDA $7EF357 : BEQ + : RTL : +
	LDA $7EF3CA : AND.b #$40
	PHA : LDA.l InvertedMode : BNE .inverted
	.normal
		PLA : EOR #$40
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
	LDA $1B : BEQ + : RTL : +
	LDA $7EF357 : BEQ + : RTL : +
	LDA $8A : AND.b #$40 : PHA
	LDA.l InvertedMode : BNE .inverted
	.normal
		PLA : EOR #$40
		BRA .done
	.inverted
		PLA
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;ReadInventoryPond:
;	CPX.b #$1B : BNE + : LDA.b #$01 : RTL : +
;	LDA $7EF340, X
;RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
FixBunnyOnExitToLightWorld:
    LDA.w $02E0 : BEQ +
        JSL.l DecideIfBunny : BEQ +
        STZ $5D ; set player mode to Normal
        STZ $02E0 : STZ $56 ; return player graphics to normal
    +
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; fix issue where if a player beats aga1 without moon pearl, they don't turn into
; bunny on the pyramid
FixAga2Bunny:
    LDA.l FixFakeWorld :  BEQ + ; Only use this fix is fakeworld fix is in use
        LDA.l InvertedMode : BEQ +++
            LDA.b #$00 : STA !DARK_WORLD ; Switch to light world
            BRA ++
        +++
        LDA.b #$40 : STA !DARK_WORLD ; Switch to dark world
    ++
	JSL DecideIfBunny : BNE +
		JSR MakeBunny
		LDA.b #$04 : STA.w $012C ; play bunny music
		BRA .done
	+
	LDA.b #$09 : STA.w $012C ; what we wrote over
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
MakeBunny:
    PHX : PHY
	LDA.b #$17 : STA $5D ; set player mode to permabunny
	LDA.b #$01 : STA $02E0 : STA $56 ; make player look like bunny
	JSL LoadGearPalettes_bunny
    PLY : PLX
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; fix issue where cross world caves (in Entrance randomizer) don't cause
; frog to become smith or vice versa.
FixFrogSmith:
	LDA.l $7EF3CA : BNE .darkWorld
		LDA.l $7EF3CC : CMP.b #$07 : BNE .done
		LDA.b #$08 : STA.l $7EF3CC ; make frog into smith in light world
		BRA .loadgfx
	.darkWorld
		LDA.l $7EF3CC : CMP.b #$08 : BNE .done
		LDA.b #$07 : STA.l $7EF3CC ; make smith into frog in dark world
	.loadgfx
		JSL Tagalong_LoadGfx
	.done
RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;Fix for PoD causing accidental Exploration Glitch
PodEGFix:
    LDA Bugfix_PodEG : BNE .done
    LDA $040C : CMP.b #$0C : BNE .done ;check if we are in PoD
        STZ $047A ;disarm exploration glitch
    .done
RTL
;--------------------------------------------------------------------------------
; Fix crystal not spawning when using somaria vs boss
TryToSpawnCrystalUntilSuccess:
	STX $02D8 ; what we overwrote
	JSL AddAncillaLong : BCC .spawned ; a clear carry flag indicates success
		.failed
		RTL
	.spawned
	STZ $AE ; the "trying to spawn crystal" flag
	STZ $AF ; the "trying to spawn pendant" flag
RTL

;--------------------------------------------------------------------------------
; Fix crystal not spawning when using somaria vs boss
WallmasterCameraFix:
	STZ $A7    ; disable vertical camera scrolling for current room
	REP #$20
	STZ $0618  ; something about scrolling, setting these to 0 tricks the game 
	STZ $061A  ; into thinking we're at the edge of the room so it doesn't scroll.
	SEP #$20
	JML Sound_SetSfx3PanLong ; what we wrote over, also this will RTL

;--------------------------------------------------------------------------------
; Fix losing glove colors
LoadActualGearPalettesWithGloves:
REP #$20
LDA $7EF359 : STA $0C
LDA $7EF35B : AND.w #$00FF
JSL LoadGearPalettes_variable
JSL SpriteSwap_Palette_ArmorAndGloves_part_two
RTL

;--------------------------------------------------------------------------------
; Fix Bunny Palette Map Bug
LoadGearPalette_safe_for_bunny:
LDA $10 
CMP.w #$030E : BEQ .new ; opening dungeon map
CMP.w #$070E : BEQ .new ; opening overworld map
.original
-
	lda [$00]
	sta $7ec300, x
	sta $7ec500, x
	inc $00 : inc $00
	inx #2
	dey
	bpl -
RTL
.new
-
	lda [$00]
	sta $7ec500, x
	inc $00 : inc $00
	inx #2
	dey
	bpl -
RTL

;--------------------------------------------------------------------------------
; Fix pedestal pull overlay
PedestalPullOverlayFix:
LDA.b #$09 : STA $039F, X	; the thing we wrote over
LDA $1B : BNE +
	LDA $8A : CMP.b #$80 : BNE +
		LDA $8C : CMP.b #$97
+
RTL
