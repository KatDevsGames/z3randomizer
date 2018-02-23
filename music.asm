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
    LDA $7EF3C5 : CMP.b #$03 : !BLT +
        LDX.b #$02 ; Default light world theme (phase >=3)
    +

    ; Check if we're entering the village
    LDA $8A : CMP.b #$18 : BEQ .endOfLightWorldChecks
    ; For NA release would we also branch on indexes #$22 #$28 #$29

    LDX.b #$05 ; Lost woods theme

    ; check if we've pulled from the master sword pedestal
    LDA $7EF300 : AND.b #$40 : BEQ +
        LDX.b #$02 ; Default light world theme
    +

    ; check if we are entering lost woods
    LDA $8A : BEQ .endOfLightWorldChecks

    .notVillageOrWoods
    ; Use the normal overworld (light world) music
    LDX.b #$02

    ; Check phase        ; In phase >= 2
    LDA $7EF3C5 : CMP.b #$02 : !BGE +
        ; If phase < 2, play the legend music
        LDX.b #$03
    +

    .endOfLightWorldChecks
    ; if we are in the light world go ahead and set chosen selection
    LDA $7EF3CA : BEQ .lastCheck

    LDX.b #$0D ; dark woods theme

    ; This music is used in dark woods, and dark death mountain
    LDA $8A
    CMP.b #$40 : BEQ + : CMP.b #$43 : BEQ + : CMP.b #$45 : BEQ + : CMP.b #$47 : BEQ +
        LDX.b #$09 ; dark overworld theme
    +

    ; Does Link have a moon pearl?
    LDA $7EF357 : BNE +
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
;0 = Is Kakariko Overworld
;1 = Not Kakariko Overworld
PsychoSolder_MusicCheck:
    LDA $040A : CMP.b #$18 : BNE .done ; thing we overwrote - check if overworld location is Kakariko
        LDA $1B  ; Also check that we are outdoors
    .done
RTL
;--------------------------------------------------------------------------------
