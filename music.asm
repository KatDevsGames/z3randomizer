;--------------------------------------------------------------------------------
PreOverworld_LoadProperties_ChooseMusic:
    ; A: scratch space (value never used)
    ; Y: set to overworld animated tileset
    ; X: set to music track/command id
    JSR.w FixFrogSmith ; Just a convenient spot to install this hook 

    LDY.b #$58 ; death mountain animated tileset.

    LDX.b #$02 ; Default light world theme

    LDA.b OverworldIndex : ORA.b #$40 ; check both light and dark world DM at the same time
    CMP.b #$43 : BEQ .endOfLightWorldChecks
    CMP.b #$45 : BEQ .endOfLightWorldChecks
    CMP.b #$47 : BEQ .endOfLightWorldChecks

    LDY.b #$5A ; Main overworld animated tileset

    ; Skip village and lost woods checks if entering dark world or a special area
    LDA.b OverworldIndex : CMP.b #$40 : !BGE .notVillageOrWoods

    LDX.b #$07 ; Default village theme

    ; Check if we're entering the village
    LDA.b OverworldIndex : CMP.b #$18 : BEQ .endOfLightWorldChecks
    ; For NA release would we also branch on indexes #$22 #$28 #$29

    LDX.b #$05 ; Lost woods theme

    ; check if we've pulled from the master sword pedestal
    LDA.b OverworldEventDataWRAM+$80 : AND.b #$40 : BEQ +
        LDX.b #$02 ; Default light world theme
    +

    ; check if we are entering lost woods
    LDA.b OverworldIndex : BEQ .endOfLightWorldChecks

    .notVillageOrWoods
    ; Use the normal overworld (light world) music
    LDX.b #$02

    ; Check phase        ; In phase >= 2
    LDA.l ProgressIndicator : CMP.b #$02 : !BGE +
        ; If phase < 2, play the legend music
        LDX.b #$03
    +

    .endOfLightWorldChecks
    ; if we are in the light world go ahead and set chosen selection
    LDA.l CurrentWorld : BEQ .checkInverted+4

    LDX.b #$0F ; dark woods theme

    ; This music is used in dark woods
    LDA.b OverworldIndex
    CMP.b #$40 : BEQ +
        LDX.b #$0D  ; dark death mountain theme

    ; This music is used in dark death mountain
    CMP.b #$43 : BEQ + : CMP.b #$45 : BEQ + : CMP.b #$47 : BEQ +
        LDX.b #$09 ; dark overworld theme
    +

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    .checkInverted
    LDA.l CurrentWorld : CLC : ROL #$03 : CMP.l InvertedMode : BEQ .lastCheck

    ; Does Link have a moon pearl?
    LDA.l MoonPearlEquipment : BNE +
        LDX.b #$04 ; bunny theme
    +

    .lastCheck
    LDA.w MusicControlQueue : CMP.b #$F2 : BNE +
    CPX.w LastAPUCommand : BNE +
        ; If the last played command (MusicControlQueue) was half volume (#$F2)
        ; and the actual song playing (LastAPUCommand) is same as the one for this area (X)
        ; then play the full volume command (#F3) instead of restarting the song
        LDX.b #$F3
    +

    JML.l PreOverworld_LoadProperties_SetSong
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
Overworld_FinishMirrorWarp:
    REP #$20

    LDA.w #$2641 : STA.w DMAP7

    LDX.b #$3E

    LDA.w #$FF00

.clear_hdma_table

    STA.w IrisPtr+$0000, X : STA.w IrisPtr+$0040, X
    STA.w IrisPtr+$0080, X : STA.w IrisPtr+$00C0, X
    STA.w IrisPtr+$0100, X : STA.w IrisPtr+$0140, X
    STA.w IrisPtr+$0180, X

    DEX #2 : BPL .clear_hdma_table
    LDA.w #$0000 : STA.l FadeTimer : STA.l FadeDirection

    SEP #$20
    JSL $80D7C8
    LDA.b #$80 : STA.b HDMAENQ
    LDX.b #$04  ; bunny theme

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    LDA.l CurrentWorld : CLC : ROL #$03 : CMP.l InvertedMode : BEQ +
        LDA.l MoonPearlEquipment : BEQ .endOfLightWorldChecks
    +

    LDX.b #$09  ; default dark world theme

    LDA.b OverworldIndex : CMP.b #$40 : !BGE .endOfLightWorldChecks

    LDX.b #$02  ; hyrule field theme

    ; Check if we're entering the lost woods
    CMP.b #$00 : BNE +
        LDA.l OverworldEventDataWRAM+$80 : AND.b #$40 : BNE .endOfLightWorldChecks
        LDX.b #$05 ; lost woods theme
        BRA .endOfLightWorldChecks
    +

    ; Check if we're entering the village
    CMP.b #$18 : BNE .endOfLightWorldChecks

    ; Check what phase we're in
        LDX.b #$07 ; Default village theme (phase <3)

.endOfLightWorldChecks
    STX.w MusicControlRequest

    LDA.b OverworldIndex : CMP.b #$40 : BNE +
        LDX.b #$0F    ; dark woods theme
        BRA .bunny
    +

    CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BNE .notDarkMountain

.darkMountain
    LDA.b #$09 : STA.w SFX1    ; set storm ambient SFX
    LDX.b #$0D  ; dark mountain theme

.bunny
    LDA.l MoonPearlEquipment : ORA.l InvertedMode : BNE +
        LDX.b #$04    ; bunny theme
    +

    STX.w MusicControlRequest

.notDarkMountain

    LDA.b GameSubMode : STA.w GameSubModeCache ; GameModeCache

    STZ.b GameSubMode
    STZ.b SubSubModule
    STZ.w SubModuleInterface
    STZ.w SkipOAM

    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
BirdTravel_LoadTargetAreaMusic:
    ; Skip village and lost woods checks if entering dark world or a special area
    LDA.b OverworldIndex : CMP.b #$43 : BEQ .endOfLightWorldChecks
    CMP.b #$40 : !BGE .notVillageOrWoods

    LDX.b #$07 ; Default village theme

    ; Check if we're entering the village
    LDA.b OverworldIndex : CMP.b #$18 : BEQ .endOfLightWorldChecks
    ; For NA release would we also branch on indexes #$22 #$28 #$29

    ; check if we are entering lost woods
    LDA.b OverworldIndex : BEQ .endOfLightWorldChecks

    .notVillageOrWoods
    ; Use the normal overworld (light world) music
    LDX.b #$02

    ; Check phase        ; In phase >= 2
    LDA.l ProgressIndicator : CMP.b #$02 : !BGE +
        ; If phase < 2, play the legend music
        LDX.b #$03
    +

    .endOfLightWorldChecks
    ; if we are in the light world go ahead and set chosen selection
    LDA.l CurrentWorld : BEQ .checkInverted+4

    LDX.b #$09 ; dark overworld theme

    LDA.b OverworldIndex
    ; Misery Mire rain SFX
    CMP.b #$70 : BNE ++
        LDA.l OverworldEventDataWRAM+$70 : AND.b #$20 : BNE ++
            LDA.b #$01 : CMP.w LastSFX1 : BEQ +
                STA.w SFX1
            + : BRA .checkInverted
    ++

    ; This music is used in dark death mountain
    CMP.b #$43 : BEQ .darkMountain
        LDA.b #$05 : STA.w SFX1
        BRA .checkInverted

.darkMountain
    LDA.l CrystalsField : CMP.b #$7F : BEQ +
        LDX.b #$0D  ; dark death mountain theme
    + : LDA.b #$09 : STA.w SFX1

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    .checkInverted
    LDA.l CurrentWorld : CLC : ROL #$03 : CMP.l InvertedMode : BEQ .lastCheck

    ; Does Link have a moon pearl?
    LDA.l MoonPearlEquipment : BNE +
        LDX.b #$04 ; bunny theme
    +

    .lastCheck
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Is Kakariko Overworld
;1 = Not Kakariko Overworld
PsychoSolder_MusicCheck:
    LDA.b OverworldIndex : CMP.b #$18 : BNE .done ; thing we overwrote - check if overworld location is Kakariko
        LDA.b IndoorsFlag  ; Also check that we are outdoors
    .done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Additional dark world checks to determine whether or not to fade out music
; on mosaic transitions
; 
; On entry, A = $8A (overworld area being loaded)
Overworld_MosaicDarkWorldChecks:
    CMP.b #$40 : BEQ .checkCrystals
    CMP.b #$42 : BEQ .checkCrystals
    CMP.b #$50 : BEQ .checkCrystals
    CMP.b #$51 : BNE .doFade

.checkCrystals
    LDA.l CrystalsField : CMP.b #$7F : BEQ .done

.doFade
    LDA.b #$F1 : STA.w MusicControlRequest  ; thing we wrote over, fade out music

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Check if the boss in ToH has been defeated (16-bit accumulator)
CheckHeraBossDefeated:
    LDA.l RoomDataWRAM[$07].l : AND.w #$FF00
    RTL
;--------------------------------------------------------------------------------
