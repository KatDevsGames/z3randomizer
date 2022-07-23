NewElderCode:
{
LDA $8A : CMP #$1B : BEQ .newCodeContinue
;Restore Jump we can keep the RTL so JML
JML $05F0CD
.newCodeContinue
PHB : PHK : PLB
LDA.b #$07 : STA $0F50, X ;Palette 
JSR Elder_Draw
JSL Sprite_PlayerCantPassThrough
JSR Elder_Code

PLB
RTL


    Elder_Draw:
    {

        LDA.b #$02 : STA $06 : STZ $07 ;Number of Tiles
        
        LDA $0DC0, X : ASL #04
        
        ADC.b #.animation_states : STA $08
        LDA.b #.animation_states>>8 : ADC.b #$00 : STA $09
        
        JSL Sprite_DrawMultiple_player_deferred
        JSL Sprite_DrawShadowLong

        RTS

        .animation_states
        ;Frame0
        dw 0, -9 : db $C6, $00, $00, $02
        dw 0,  0 : db $C8, $00, $00, $02
        ;Frame1
        dw 0, -8 : db $C6, $00, $00, $02
        dw 0,  0 : db $CA, $40, $00, $02
    }

    Elder_Code:
    {
        REP #$20
        LDA.l GoalItemRequirement : BEQ .despawn
        LDA.l InvincibleGanon : AND.w #$00FF : CMP.w #$0005 : BEQ .despawn
        LDA.l TurnInGoalItems : AND.w #$00FF : BNE +
            .despawn
            SEP #$20
            STZ $0DD0, X ; despawn self
            RTS
        +
        SEP #$20
        LDA.b $11
        BNE .done
        LDA.b #$96
        LDY.b #$01
        
        JSL Sprite_ShowSolicitedMessageIfPlayerFacing_PreserveMessage : BCC .dont_show
            REP #$20
            LDA.l GoalCounter
            CMP.l GoalItemRequirement : !BLT +
                SEP #$20
                JSL.l ActivateGoal
            +
        .dont_show
        
        .done
        SEP #$20
        LDA.b $1A : LSR #5 : AND.b #$01 : STA.w $0DC0, X
        RTS
    }
