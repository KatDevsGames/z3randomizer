;================================================================================
; Boots State Modifier
;--------------------------------------------------------------------------------
!BOOTS_MODIFIER = "$7F50CE"
ModifyBoots:
    PHA
        LDA !BOOTS_MODIFIER : CMP.b #$01 : BNE +
            PLA : AND AbilityFlags : ORA.b #$04 : RTL ; yes boots
        + : CMP.b #$02 : BNE +
            PLA : AND AbilityFlags : AND.b #$FB : RTL ; no boots
        + : LDA FakeBoots : CMP.b #$01 : BNE +
            LDA $5B : BEQ ++ : LDA $59 : BNE + ; hover check
                ++ : PLA : AND AbilityFlags : ORA.b #$04 : RTL ; yes boots, not hovering
        +
    PLA
    AND AbilityFlags ; regular boots
RTL
;--------------------------------------------------------------------------------
AddBonkTremors:
    PHA
        LDA $46 : BNE + ; Check for incapacitated Link
            JSL.l IncrementBonkCounter
        +
        LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
        LDA BootsEquipment : BNE + ; Check for Boots
            PLA : RTL
        +
    PLA
    JSL.l AddDashTremor : JSL.l Player_ApplyRumbleToSprites ; things we wrote over
RTL
;--------------------------------------------------------------------------------
BonkBreakableWall:
    PHX : PHP
        SEP #$30 ; set 8-bit accumulator and index registers
        LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
        LDA BootsEquipment : BNE + ; Check for Boots
            PLP : PLX : LDA.w #$0000 : RTL
        +
    PLP : PLX
    LDA $0372 : AND.w #$00FF ; things we wrote over
RTL
;--------------------------------------------------------------------------------
BonkRockPile:
    LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
    LDA BootsEquipment : BNE + ; Check for Boots
        LDA.b #$00 : RTL
    +
    LDA $02EF : AND.b #$70 ; things we wrote over
RTL
;--------------------------------------------------------------------------------
GravestoneHook:
    LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
    LDA BootsEquipment : BEQ .done ; Check for Boots
    +
    LDA $0372 : BEQ .done ; things we wrote over
        JML.l moveGravestone
    .done
    JML.l GravestoneHook_continue
;--------------------------------------------------------------------------------
JumpDownLedge:
    LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
    LDA BootsEquipment : BNE + ; Check for Boots
        ; Disarm Waterwalk
        LDA $5B : CMP.b #$01 : BNE +
            STZ $5B
    +
    LDA $1B : BNE .done : LDA.b #$02 : STA $EE ; things we wrote over
    .done
RTL
;--------------------------------------------------------------------------------
BonkRecoil:
    LDA !BOOTS_MODIFIER : CMP.b #$01 : BEQ +
    LDA BootsEquipment : BNE + ; Check for Boots
        LDA.b #$16 : STA $29 : RTL
    +
    LDA.b #$24 : STA $29 ; things we wrote over
RTL
