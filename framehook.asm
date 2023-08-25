;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
FrameHookAction:
        JSL $8080B5 ; Module_MainRouting
        JSL CheckMusicLoadRequest
        PHP : REP #$30 : PHA
        SEP #$20	
        LDA.l StatsLocked : BNE ++
                REP #$20 ; set 16-bit accumulator
                LDA.l LoopFrames : INC : STA.l LoopFrames : BNE +
                        LDA.l LoopFrames+2 : INC : STA.l LoopFrames+2
                                +
                                LDA.l GameMode : CMP.w #$010E : BNE ++ ; move this to nmi hook?
                                LDA.l MenuFrames : INC : STA.l MenuFrames : BNE ++
                                        LDA.l MenuFrames+2 : INC : STA.l MenuFrames+2
                ++
        REP #$30 : PLA : PLP

RTL
;--------------------------------------------------------------------------------
NMIHookAction:
        PHA : PHX : PHY : PHD ; thing we wrote over, push stuff
        LDA.l StatsLocked : AND.w #$00FF : BNE +
                LDA.l NMIFrames : INC : STA.l NMIFrames : BNE +
                        LDA.l NMIFrames+2 : INC : STA.l NMIFrames+2
                +

JML.l NMIHookReturn
;--------------------------------------------------------------------------------
PostNMIHookAction:
        LDA.w NMIAux : BEQ +
                PHK : PEA .return-1 ; push stack for RTL return
                JMP.w [NMIAux]
                .return
                STZ.w NMIAux ; zero bank byte of NMI hook pointer
        +
        JSR.w TransferItemGFX
        LDA.b INIDISPQ : STA.w INIDISP ; thing we wrote over, turn screen back on

JML.l PostNMIHookReturn
;--------------------------------------------------------------------------------
TransferItemGFX:
; Only used for shops now but could be used for anything. We should look at how door rando does this
; and try to unify one approach.
        REP #$30
        LDX.w ItemStackPtr : BEQ .done
        TXA : BIT #$0040 : BNE .fail ; Crash if we have more than 16 queued (should never happen.)
                DEX #2
                -
                        LDA.l ItemGFXStack,X : STA.w ItemGFXPtr
                        LDA.l ItemTargetStack,X : STA.w ItemGFXTarget
                        PHX
                        JSL.l TransferItemToVRAM
                        REP #$10
                        PLX
                        DEX #2
                BPL -

        STZ.w ItemStackPtr
        .done
        SEP #$30
RTS
        .fail
        BRK #$00
