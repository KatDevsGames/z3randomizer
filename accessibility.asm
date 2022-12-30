;================================================================================
; Accessibility Fixes
;================================================================================
ConditionalLightning:
        CMP.b #$05 : BEQ ++
        CMP.b #$2C : BEQ ++
        CMP.b #$5A : BEQ ++
            LDA.l DisableFlashing : BNE ++
                LDA.b #$32 : STA.w CGADSUBQ
                RTL
        ++
                LDA.b #$72
        STA.b CGADSUBQ
RTL
;================================================================================
ConditionalWhitenBg:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.b Scrap00,X
            JSR WhitenLoopReal
            RTL
        +
            LDA.b Scrap00
            JSR WhitenLoopDummy
            RTL
;================================================================================
WhitenLoopReal:
        -
            LDA.l PaletteBufferAux+$40, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$40, X
            LDA.l PaletteBufferAux+$50, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$50, X
            LDA.l PaletteBufferAux+$60, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$60, X
            LDA.l PaletteBufferAux+$70, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$70, X
            LDA.l PaletteBufferAux+$80, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$80, X
            LDA.l PaletteBufferAux+$90, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$90, X
            LDA.l PaletteBufferAux+$A0, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$A0, X
            LDA.l PaletteBufferAux+$B0, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$B0, X
            LDA.l PaletteBufferAux+$C0, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$C0, X
            LDA.l PaletteBufferAux+$D0, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$D0, X
            LDA.l PaletteBufferAux+$E0, X : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA.l PaletteBufferAux+$F0 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F0
            LDA.l PaletteBufferAux+$F2 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F2
            LDA.l PaletteBufferAux+$F4 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F4
            LDA.b GameMode : CMP.w #$0007 : BNE +
            LDA.b RoomIndex
            CMP.w #$003C : BEQ ++
            CMP.w #$009D : BEQ ++
            CMP.w #$009C : BEQ ++
            CMP.w #$00A5 : BEQ ++
            +
                LDA.l PaletteBufferAux+$F6 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F6
                LDA.l PaletteBufferAux+$F8 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F8
                BRA +++
            ++
                LDA.l PaletteBuffer+$F6 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F6
                LDA.l PaletteBuffer+$F8 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F8
                BRA +++
            +++
            LDA.l PaletteBufferAux+$FA : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$FA
            LDA.l PaletteBufferAux+$FC : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$FC
            LDA.l PaletteBufferAux+$FE : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$FE
            REP #$10
            LDA.l PaletteBuffer+$40 : TAY
            LDA.l PaletteBufferAux : BNE +
                TAY
        +
            TYA : STA.l PaletteBuffer
            SEP #$30
RTS
;================================================================================
WhitenLoopDummy:
        -
            LDA.l PaletteBufferAux+$40, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$40, X
            LDA.l PaletteBufferAux+$50, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$50, X
            LDA.l PaletteBufferAux+$60, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$60, X
            LDA.l PaletteBufferAux+$70, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$70, X
            LDA.l PaletteBufferAux+$80, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$80, X
            LDA.l PaletteBufferAux+$90, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$90, X
            LDA.l PaletteBufferAux+$A0, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$A0, X
            LDA.l PaletteBufferAux+$B0, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$B0, X
            LDA.l PaletteBufferAux+$C0, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$C0, X
            LDA.l PaletteBufferAux+$D0, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$D0, X
            LDA.l PaletteBufferAux+$E0, X : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA.l PaletteBufferAux+$F0 : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$F0
            LDA.l PaletteBufferAux+$F2 : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$F2
            LDA.l PaletteBufferAux+$F4 : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$F4
            LDA.b GameMode : CMP.w #$0007 : BNE + ; only light invisifloor if we're in dungeon submodule
            LDA.b RoomIndex
            CMP.w #$003C : BEQ ++ ; hookshot cave
            CMP.w #$009D : BEQ ++ ; gt right
            CMP.w #$009C : BEQ ++ ; gt big room
            CMP.w #$00A5 : BEQ ++ ; wizzrobes 1
            +
                LDA.l PaletteBufferAux+$F6 : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$F6
                LDA.l PaletteBufferAux+$F8 : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$F8
                BRA +++
            ++
                LDA.l PaletteBufferAux+$F6 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F6
                LDA.l PaletteBufferAux+$F8 : JSL Filter_Majorly_Whiten_Color : STA.l PaletteBuffer+$F8
                BRA +++
            +++
            LDA.l PaletteBufferAux+$FA : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$FA
            LDA.l PaletteBufferAux+$FC : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$FC
            LDA.l PaletteBufferAux+$FE : JSL Filter_Majorly_Whiten_Color : LDA.l PaletteBuffer+$FE
            REP #$10
            LDA.l PaletteBuffer+$40 : TAY
            LDA.l PaletteBufferAux : BNE +
                TAY
        +
            TYA : STA.l PaletteBuffer
            SEP #$30
RTS
;================================================================================
RestoreBgEther:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
        -
            LDA.b Scrap00,X
            LDA.l PaletteBufferAux+$40, X : STA.l PaletteBuffer+$40, X
            LDA.l PaletteBufferAux+$50, X : STA.l PaletteBuffer+$50, X
            LDA.l PaletteBufferAux+$60, X : STA.l PaletteBuffer+$60, X
            LDA.l PaletteBufferAux+$70, X : STA.l PaletteBuffer+$70, X
            LDA.l PaletteBufferAux+$80, X : STA.l PaletteBuffer+$80, X
            LDA.l PaletteBufferAux+$90, X : STA.l PaletteBuffer+$90, X
            LDA.l PaletteBufferAux+$A0, X : STA.l PaletteBuffer+$A0, X
            LDA.l PaletteBufferAux+$B0, X : STA.l PaletteBuffer+$B0, X
            LDA.l PaletteBufferAux+$C0, X : STA.l PaletteBuffer+$C0, X
            LDA.l PaletteBufferAux+$D0, X : STA.l PaletteBuffer+$D0, X
            LDA.l PaletteBufferAux+$E0, X : STA.l PaletteBuffer+$E0, X
            LDA.l PaletteBufferAux+$F0, X : STA.l PaletteBuffer+$F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        +
        -
            LDA.b Scrap00
            LDA.l PaletteBufferAux+$40, X : LDA.l PaletteBuffer+$40, X
            LDA.l PaletteBufferAux+$50, X : LDA.l PaletteBuffer+$50, X
            LDA.l PaletteBufferAux+$60, X : LDA.l PaletteBuffer+$60, X
            LDA.l PaletteBufferAux+$70, X : LDA.l PaletteBuffer+$70, X
            LDA.l PaletteBufferAux+$80, X : LDA.l PaletteBuffer+$80, X
            LDA.l PaletteBufferAux+$90, X : LDA.l PaletteBuffer+$90, X
            LDA.l PaletteBufferAux+$A0, X : LDA.l PaletteBuffer+$A0, X
            LDA.l PaletteBufferAux+$B0, X : LDA.l PaletteBuffer+$B0, X
            LDA.l PaletteBufferAux+$C0, X : LDA.l PaletteBuffer+$C0, X
            LDA.l PaletteBufferAux+$D0, X : LDA.l PaletteBuffer+$D0, X
            LDA.l PaletteBufferAux+$E0, X : LDA.l PaletteBuffer+$E0, X
            LDA.l PaletteBufferAux+$F0, X : LDA.l PaletteBuffer+$F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        ++
JML $82FF51 ; Bank0E.asm : 3936 vanilla restore routine after loop which RTLs
;================================================================================
DDMConditionalLightning:
        LDA.l DisableFlashing 
        REP #$20
        BNE +
            LDA.w Scrap
            LDX.b #$02
            JML $87FA7F ; Bank0E.asm : 4738 vanilla loop equivalent to below beginning at LDY #$00
        +
            LDA.b Scrap00 : LDX.b #$02 : LDY.b #$00
        -
            LDA.w $F4EB, Y : LDA.l PaletteBuffer+$60, X
            LDA.w $F4F9, Y : LDA.l PaletteBuffer+$70, X
            LDA.w $F507, Y : LDA.l PaletteBuffer+$90, X
            LDA.w $F515, Y : LDA.l PaletteBuffer+$E0, X
            LDA.w $F523, Y : LDA.l PaletteBuffer+$F0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            JML $87FAAC ; Bank0E.asm : 4754 both branches converge here
;================================================================================
ConditionalGTFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.w Scrap
        -
            LDA.w $F9C1, Y : STA.l PaletteBuffer+$D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
        +
            LDA.b Scrap00
        -
            LDA.w $F9C1, Y : LDA.l PaletteBuffer+$D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
;================================================================================
ConditionalRedFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.b Scrap,X
            LDA.w #$1D59 : STA.l PaletteBuffer+$DA
            LDA.w #$25FF : STA.l PaletteBuffer+$DC
            LDA.w #$001A
            RTL
        +
            LDA.b Scrap00
            LDA.w #$1D59 : LDA.l PaletteBuffer+$DA
            LDA.w #$25FF : LDA.l PaletteBuffer+$DC
            LDA.w #$0000
            RTL
;================================================================================
ConditionalPedAncilla:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.b Scrap,X
            LDA.b Scrap00 : STA.b Scrap04
            LDA.b Scrap02 : STA.b Scrap06
            RTL
        +
            LDA.b Scrap
            LDA.b Scrap00 : LDA.b Scrap04
            LDA.b Scrap02 : LDA.b Scrap06
            RTL
;================================================================================
LoadElectroPalette:
        REP #$20
        LDA.w #$0202 : STA.b Scrap0C
        LDA.w #$0404 : STA.b Scrap0E
        LDA.w #$001B : STA.b Scrap02
        SEP #$10
        LDX.b Scrap0C : LDA.l $9BEBB4, X : AND.w #$00FF : ADC.w #$D630
        REP #$10 : LDX.w #$01B2 : LDY.w #$0002
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX.b Scrap0D
        LDA.l $9BEBC1, X : AND.w #$00FF : ADC.w #$D648
        REP #$10 : LDX.w #$01B8 : LDY.w #$0003
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX.b Scrap0E
        LDA.l $9BEC06, X : AND.w #$00FF : ASL A : ADC.w #$D308
        REP #$10 : LDX.w #$01E2 : LDY.w #$000E
        JSR ConditionalLoadGearPalette
        SEP #$30
        INC.b NMICGRAM
RTL
;================================================================================
ConditionalLoadGearPalette:
        STA.b Scrap00
        SEP #$20
        LDA.l DisableFlashing : REP #$20 : BNE +
                LDA.b Scrap,X
        -
                LDA.b [Scrap00]
                STA.l PaletteBuffer, X
                INC.b Scrap00 : INC.b Scrap00
                INX #2
                DEY
                BPL -
        RTS
        +
                LDA.b Scrap
        -
                LDA.b [Scrap00]
                LDA.l PaletteBuffer, X
                INC.b Scrap00 : INC.b Scrap00
                INX #2
                DEY
                BPL -
        RTS
;================================================================================
RestoreElectroPalette:
        REP #$30
        LDX.w #$01B2 : LDY.w #$0002
        JSR FillPaletteBufferFromAux
        LDX.w #$01B8 : LDY.w #$0003
        JSR FillPaletteBufferFromAux
        LDX.w #$01E2 : LDY.w #$000E
        JSR FillPaletteBufferFromAux
        SEP #$30
        INC.b NMICGRAM
RTL
;================================================================================
FillPaletteBufferFromAux:
        -
            LDA.l PaletteBufferAux, X
            STA.l PaletteBuffer, X
            INX #2
            DEY
            BPL -
RTS
