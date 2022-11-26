;================================================================================
; Boots State Modifier
;--------------------------------------------------------------------------------
ModifyBoots:
    PHA
        LDA.l BootsModifier : CMP.b #$01 : BNE +
            PLA : AND.l AbilityFlags : ORA.b #$04 : RTL ; yes boots
        + : CMP.b #$02 : BNE +
            PLA : AND.l AbilityFlags : AND.b #$FB : RTL ; no boots
        + : LDA.l FakeBoots : CMP.b #$01 : BNE +
            LDA.b LinkSlipping : BEQ ++ : LDA.b $59 : BNE + ; hover check
                ++ : PLA : AND.l AbilityFlags : ORA.b #$04 : RTL ; yes boots, not hovering
        +
    PLA
    AND.l AbilityFlags ; regular boots
RTL
;--------------------------------------------------------------------------------
AddBonkTremors:
    PHA
        LDA.b $46 : BNE + ; Check for incapacitated Link
            JSL.l IncrementBonkCounter
        +
        LDA.l BootsModifier : CMP.b #$01 : BEQ +
        LDA.l BootsEquipment : BNE + ; Check for Boots
            PLA : RTL
        +
    PLA
    JSL.l AddDashTremor : JSL.l Player_ApplyRumbleToSprites ; things we wrote over
RTL
;--------------------------------------------------------------------------------
BonkBreakableWall:
    PHX : PHP
        SEP #$30 ; set 8-bit accumulator and index registers
        LDA.l BootsModifier : CMP.b #$01 : BEQ +
        LDA.l BootsEquipment : BNE + ; Check for Boots
            PLP : PLX : LDA.w #$0000 : RTL
        +
    PLP : PLX
    LDA.w $0372 : AND.w #$00FF ; things we wrote over
RTL
;--------------------------------------------------------------------------------
BonkRockPile:
    LDA.l BootsModifier : CMP.b #$01 : BEQ +
    LDA.l BootsEquipment : BNE + ; Check for Boots
        LDA.b #$00 : RTL
    +
    LDA.w TileActBE : AND.b #$70 ; things we wrote over
RTL
;--------------------------------------------------------------------------------
GravestoneHook:
    LDA.l BootsModifier : CMP.b #$01 : BEQ +
    LDA.l BootsEquipment : BEQ .done ; Check for Boots
    +
    LDA.w $0372 : BEQ .done ; things we wrote over
        JML.l moveGravestone
    .done
    JML.l GravestoneHook_continue
;--------------------------------------------------------------------------------
JumpDownLedge:
    LDA.l BootsModifier : CMP.b #$01 : BEQ +
    LDA.l BootsEquipment : BNE + ; Check for Boots
        ; Disarm Waterwalk
        LDA.b LinkSlipping : CMP.b #$01 : BNE +
            STZ.b LinkSlipping
    +
    LDA.b IndoorsFlag : BNE .done : LDA.b #$02 : STA.b LinkLayer ; things we wrote over
    .done
RTL
;--------------------------------------------------------------------------------
BonkRecoil:
    LDA.l BootsModifier : CMP.b #$01 : BEQ +
    LDA.l BootsEquipment : BNE + ; Check for Boots
        LDA.b #$16 : STA.b LinkRecoilZ : RTL
    +
    LDA.b #$24 : STA.b LinkRecoilZ ; things we wrote over
RTL
