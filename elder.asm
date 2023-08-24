NewElderCode:
{
LDA.b OverworldIndex : CMP.b #$1B : BEQ .newCodeContinue
;Restore Jump we can keep the RTL so JML
JML $85F0CD
.newCodeContinue
PHB : PHK : PLB
LDA.b #$07 : STA.w SpriteOAMProp, X ; Palette 
JSR Elder_Draw
JSL Sprite_PlayerCantPassThrough
JSR Elder_Code

PLB
RTL


    Elder_Draw:
    {

        LDA.b #$02 : STA.b Scrap06 : STZ.b Scrap07 ;Number of Tiles
        
        LDA.w SpriteGFXControl, X : ASL #04
        
        ADC.b #.animation_states : STA.b Scrap08
        LDA.b #.animation_states>>8 : ADC.b #$00 : STA.b Scrap09
        
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
        LDA.l GanonVulnerableMode : AND.w #$00FF : CMP.w #$0005 : BEQ .despawn
        LDA.l TurnInGoalItems : AND.w #$00FF : BNE +
            .despawn
            SEP #$20
            STZ.w SpriteAITable, X ; despawn self
            RTS
        +
        SEP #$20
        LDA.b GameSubMode
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
        LDA.b FrameCounter : LSR #5 : AND.b #$01 : STA.w SpriteGFXControl, X
        RTS
    }
