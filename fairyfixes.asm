;================================================================================
; Fairy Changes & Fixes
;--------------------------------------------------------------------------------
RefillHealthPlusMagic:
    LDA BigFairyHealth : STA $7EF372
RTL
;--------------------------------------------------------------------------------
RefillHealthPlusMagic8bit:
    LDA BigFairyHealth : STA $7EF372
    LDA BigFairyMagic : STA $7EF373
RTL
;--------------------------------------------------------------------------------
CheckFullHealth:
    LDA BigFairyHealth : BEQ +
        LDA $7EF36D : CMP $7EF36C : BNE .player_hp_not_full_yet
    +
    LDA BigFairyMagic : BEQ +
        LDA $7EF36E : CMP.b #$80 : BNE .player_mp_not_full_yet
    +
    LDA.b #$00
RTL
    .player_hp_not_full_yet
    .player_mp_not_full_yet
    LDA.b #$01
RTL
;--------------------------------------------------------------------------------