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
        LDA GoalItemRequirement : BEQ .despawn
        LDA InvincibleGanon : CMP #$05 : BEQ .despawn
        LDA TurnInGoalItems : BNE +
            .despawn
            STZ $0DD0, X ; despawn self
            RTS
        +
            
        LDA.b #$96
        LDY.b #$01
        
        JSL Sprite_ShowSolicitedMessageIfPlayerFacing_PreserveMessage : BCC .dont_show
            LDA !GOAL_COUNTER 
            CMP GoalItemRequirement : !BLT +
                JSL.l ActivateGoal
            +
        .dont_show
        
        .done
        LDA $1A : LSR #5 : AND.b #$01 : STA $0DC0, X
        RTS
    }