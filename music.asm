;--------------------------------------------------------------------------------
PreOverworld_LoadProperties_ChooseMusic:
    ; A: scratch space (value never used)
    ; Y: set to overworld animated tileset
    ; X: set to music track/command id
    JSR.w FixFrogSmith ; Just a convenient spot to install this hook 

    LDY.b #$58 ; death mountain animated tileset.

    LDX.b #$02 ; Default light world theme

    LDA $8A : ORA #$40 ; check both light and dark world DM at the same time
    CMP.b #$43 : BEQ .endOfLightWorldChecks
    CMP.b #$45 : BEQ .endOfLightWorldChecks
    CMP.b #$47 : BEQ .endOfLightWorldChecks

    LDY.b #$5A ; Main overworld animated tileset

    ; Skip village and lost woods checks if entering dark world or a special area
    LDA $8A : CMP.b #$40 : !BGE .notVillageOrWoods

    LDX.b #$07 ; Default village theme

    ; Check what phase we're in
    ;LDA ProgressIndicator : CMP.b #$03 : !BLT +
    ;    LDX.b #$02 ; Default light world theme (phase >=3)
    ;+

    ; Check if we're entering the village
    LDA $8A : CMP.b #$18 : BEQ .endOfLightWorldChecks
    ; For NA release would we also branch on indexes #$22 #$28 #$29

    LDX.b #$05 ; Lost woods theme

    ; check if we've pulled from the master sword pedestal
    LDA OverworldEventDataWRAM+$80 : AND.b #$40 : BEQ +
        LDX.b #$02 ; Default light world theme
    +

    ; check if we are entering lost woods
    LDA $8A : BEQ .endOfLightWorldChecks

    .notVillageOrWoods
    ; Use the normal overworld (light world) music
    LDX.b #$02

    ; Check phase        ; In phase >= 2
    LDA ProgressIndicator : CMP.b #$02 : !BGE +
        ; If phase < 2, play the legend music
        LDX.b #$03
    +

    .endOfLightWorldChecks
    ; if we are in the light world go ahead and set chosen selection
    LDA CurrentWorld : BEQ .checkInverted+4

    LDX.b #$0F ; dark woods theme

    ; This music is used in dark woods
    LDA $8A
    CMP.b #$40 : BEQ +
        LDX.b #$0D  ; dark death mountain theme

    ; This music is used in dark death mountain
    CMP.b #$43 : BEQ + : CMP.b #$45 : BEQ + : CMP.b #$47 : BEQ +
        LDX.b #$09 ; dark overworld theme
    +

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    .checkInverted
    LDA CurrentWorld : CLC : ROL #$03 : CMP InvertedMode : BEQ .lastCheck

    ; Does Link have a moon pearl?
    LDA MoonPearlEquipment : BNE +
        LDX.b #$04 ; bunny theme
    +

    .lastCheck
    LDA $0132 : CMP.b #$F2 : BNE +
    CPX $0130 : BNE +
        ; If the last played command ($0132) was half volume (#$F2)
        ; and the actual song playing ($0130) is same as the one for this area (X)
        ; then play the full volume command (#F3) instead of restarting the song
        LDX.b #$F3
    +

    JML.l PreOverworld_LoadProperties_SetSong
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
Overworld_FinishMirrorWarp:
    REP #$20

    LDA.w #$2641 : STA $4370

    LDX.b #$3E

    LDA.w #$FF00

.clear_hdma_table

    STA $1B00, X : STA $1B40, X
    STA $1B80, X : STA $1BC0, X
    STA $1C00, X : STA $1C40, X
    STA $1C80, X

    DEX #2 : BPL .clear_hdma_table

    LDA.w #$0000 : STA $7EC007 : STA $7EC009

    SEP #$20

    JSL $00D7C8               ; $57C8 IN ROM

    LDA.b #$80 : STA $9B

    LDX.b #$04  ; bunny theme

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    LDA CurrentWorld : CLC : ROL #$03 : CMP InvertedMode : BEQ +
        LDA MoonPearlEquipment : BEQ .endOfLightWorldChecks
    +

    LDX.b #$09  ; default dark world theme

    LDA $8A : CMP.b #$40 : !BGE .endOfLightWorldChecks

    LDX.b #$02  ; hyrule field theme

    ; Check if we're entering the lost woods
    CMP.b #$00 : BNE +
        LDA OverworldEventDataWRAM+$80 : AND.b #$40 : BNE .endOfLightWorldChecks
        LDX.b #$05 ; lost woods theme
        BRA .endOfLightWorldChecks
    +

    ; Check if we're entering the village
    CMP.b #$18 : BNE .endOfLightWorldChecks

    ; Check what phase we're in
    ; LDA ProgressIndicator : CMP.b #$03 : !BGE .endOfLightWorldChecks
        LDX.b #$07 ; Default village theme (phase <3)

.endOfLightWorldChecks
    STX $012C

    LDA $8A : CMP.b #$40 : BNE +
        LDX #$0F    ; dark woods theme
        BRA .bunny
    +

    CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BNE .notDarkMountain

.darkMountain
    LDA.b #$09 : STA $012D    ; set storm ambient SFX
    LDX.b #$0D  ; dark mountain theme

.bunny
    LDA MoonPearlEquipment : ORA InvertedMode : BNE +
        LDX #$04    ; bunny theme
    +

    STX $012C

.notDarkMountain

    LDA $11 : STA $010C

    STZ $11
    STZ $B0
    STZ $0200
    STZ $0710

    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
BirdTravel_LoadTargetAreaMusic:
    ; Skip village and lost woods checks if entering dark world or a special area
    LDA $8A : CMP.b #$43 : BEQ .endOfLightWorldChecks
    CMP.b #$40 : !BGE .notVillageOrWoods

    LDX.b #$07 ; Default village theme

    ; Check what phase we're in
    ;LDA ProgressIndicator : CMP.b #$03 : !BLT +
    ;    LDX.b #$02 ; Default light world theme (phase >=3)
    ;+

    ; Check if we're entering the village
    LDA $8A : CMP.b #$18 : BEQ .endOfLightWorldChecks
    ; For NA release would we also branch on indexes #$22 #$28 #$29

    ;LDX.b #$05 ; Lost woods theme

    ; check if we've pulled from the master sword pedestal
    ;LDA OverworldEventDataWRAM+$80 : AND.b #$40 : BEQ +
    ;    LDX.b #$02 ; Default light world theme
    ;+

    ; check if we are entering lost woods
    LDA $8A : BEQ .endOfLightWorldChecks

    .notVillageOrWoods
    ; Use the normal overworld (light world) music
    LDX.b #$02

    ; Check phase        ; In phase >= 2
    LDA ProgressIndicator : CMP.b #$02 : !BGE +
        ; If phase < 2, play the legend music
        LDX.b #$03
    +

    .endOfLightWorldChecks
    ; if we are in the light world go ahead and set chosen selection
    LDA CurrentWorld : BEQ .checkInverted+4

    LDX.b #$09 ; dark overworld theme

    LDA $8A
    ; Misery Mire rain SFX
    CMP.b #$70 : BNE ++
        LDA OverworldEventDataWRAM+$70 : AND.b #$20 : BNE ++
            LDA.b #$01 : CMP $0131 : BEQ +
                STA $012D
            + : BRA .checkInverted
    ++

    ; This music is used in dark death mountain
    CMP.b #$43 : BEQ .darkMountain
    ; CMP.b #$45 : BEQ .darkMountain
    ; CMP.b #$47 : BEQ .darkMountain
        LDA.b #$05 : STA $012D
        BRA .checkInverted

.darkMountain
    LDA CrystalsField : CMP.b #$7F : BEQ +
        LDX.b #$0D  ; dark death mountain theme
    + : LDA.b #$09 : STA $012D

    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    .checkInverted
    LDA CurrentWorld : CLC : ROL #$03 : CMP InvertedMode : BEQ .lastCheck

    ; Does Link have a moon pearl?
    LDA MoonPearlEquipment : BNE +
        LDX.b #$04 ; bunny theme
    +

    .lastCheck
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Is Kakariko Overworld
;1 = Not Kakariko Overworld
PsychoSolder_MusicCheck:
    LDA $040A : CMP.b #$18 : BNE .done ; thing we overwrote - check if overworld location is Kakariko
        LDA $1B  ; Also check that we are outdoors
    .done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Additional dark world checks to determine whether or not to fade out music
; on mosaic transitions
; 
; On entry, A = $8A (overworld area being loaded)
Overworld_MosaicDarkWorldChecks:
    CMP.b #$40 : beq .checkCrystals
    CMP.b #$42 : beq .checkCrystals
    CMP.b #$50 : beq .checkCrystals
    CMP.b #$51 : bne .doFade

.checkCrystals
    LDA CrystalsField : CMP.b #$7F : BEQ .done

.doFade
    LDA.b #$F1 : STA $012C  ; thing we wrote over, fade out music

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Check if the boss in ToH has been defeated (16-bit accumulator)
CheckHeraBossDefeated:
    LDA $7EF00F : AND #$00FF
    RTL
;--------------------------------------------------------------------------------
