;================================================================================
; Accessibility Fixes
;================================================================================
ConditionalLightning:
        CMP.b #$05 : BEQ ++
        CMP.b #$2C : BEQ ++
        CMP.b #$5A : BEQ ++
            LDA.l DisableFlashing : BNE ++
                LDA.b #$32 : STA.w $9A
                RTL
        ++
                LDA.b #$72
        STA.b $9A
RTL
;================================================================================
ConditionalWhitenBg:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.b $00,X
            JSR WhitenLoopReal
            RTL
        +
            LDA.b Scrap00
            JSR WhitenLoopDummy
            RTL
;================================================================================
WhitenLoopReal:
        -
            LDA.l $7EC340, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC540, X
            LDA.l $7EC350, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC550, X
            LDA.l $7EC360, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC560, X
            LDA.l $7EC370, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC570, X
            LDA.l $7EC380, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC580, X
            LDA.l $7EC390, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC590, X
            LDA.l $7EC3A0, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5A0, X
            LDA.l $7EC3B0, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5B0, X
            LDA.l $7EC3C0, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5C0, X
            LDA.l $7EC3D0, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5D0, X
            LDA.l $7EC3E0, X : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA.l $7EC3F0 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F0
            LDA.l $7EC3F2 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F2
            LDA.l $7EC3F4 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F4
            LDA.b $10 : CMP.w #$0007 : BNE +
            LDA.w $048E
            CMP.w #$003C : BEQ ++
            CMP.w #$009D : BEQ ++
            CMP.w #$009C : BEQ ++
            CMP.w #$00A5 : BEQ ++
            +
                LDA.l $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F6
                LDA.l $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F8
                BRA +++
            ++
                LDA.l $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F6
                LDA.l $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F8
                BRA +++
            +++
            LDA.l $7EC3FA : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5FA
            LDA.l $7EC3FC : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5FC
            LDA.l $7EC3FE : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5FE
            REP #$10
            LDA.l $7EC540 : TAY
            LDA.l $7EC300 : BNE +
                TAY
        +
            TYA : STA.l $7EC500
            SEP #$30
RTS
;================================================================================
WhitenLoopDummy:
        -
            LDA.l $7EC340, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC540, X
            LDA.l $7EC350, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC550, X
            LDA.l $7EC360, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC560, X
            LDA.l $7EC370, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC570, X
            LDA.l $7EC380, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC580, X
            LDA.l $7EC390, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC590, X
            LDA.l $7EC3A0, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5A0, X
            LDA.l $7EC3B0, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5B0, X
            LDA.l $7EC3C0, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5C0, X
            LDA.l $7EC3D0, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5D0, X
            LDA.l $7EC3E0, X : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA.l $7EC3F0 : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5F0
            LDA.l $7EC3F2 : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5F2
            LDA.l $7EC3F4 : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5F4
            LDA.b $10 : CMP.w #$0007 : BNE + ; only light invisifloor if we're in dungeon submodule
            LDA.w $048E
            CMP.w #$003C : BEQ ++ ; hookshot cave
            CMP.w #$009D : BEQ ++ ; gt right
            CMP.w #$009C : BEQ ++ ; gt big room
            CMP.w #$00A5 : BEQ ++ ; wizzrobes 1
            +
                LDA.l $7EC3F6 : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5F6
                LDA.l $7EC3F8 : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5F8
                BRA +++
            ++
                LDA.l $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F6
                LDA.l $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA.l $7EC5F8
                BRA +++
            +++
            LDA.l $7EC3FA : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5FA
            LDA.l $7EC3FC : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5FC
            LDA.l $7EC3FE : JSL Filter_Majorly_Whiten_Color : LDA.l $7EC5FE
            REP #$10
            LDA.l $7EC540 : TAY
            LDA.l $7EC300 : BNE +
                TAY
        +
            TYA : STA.l $7EC500
            SEP #$30
RTS
;================================================================================
RestoreBgEther:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
        -
            LDA.b $00,X
            LDA.l $7EC340, X : STA.l $7EC540, X
            LDA.l $7EC350, X : STA.l $7EC550, X
            LDA.l $7EC360, X : STA.l $7EC560, X
            LDA.l $7EC370, X : STA.l $7EC570, X
            LDA.l $7EC380, X : STA.l $7EC580, X
            LDA.l $7EC390, X : STA.l $7EC590, X
            LDA.l $7EC3A0, X : STA.l $7EC5A0, X
            LDA.l $7EC3B0, X : STA.l $7EC5B0, X
            LDA.l $7EC3C0, X : STA.l $7EC5C0, X
            LDA.l $7EC3D0, X : STA.l $7EC5D0, X
            LDA.l $7EC3E0, X : STA.l $7EC5E0, X
            LDA.l $7EC3F0, X : STA.l $7EC5F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        +
        -
            LDA.b Scrap00
            LDA.l $7EC340, X : LDA.l $7EC540, X
            LDA.l $7EC350, X : LDA.l $7EC550, X
            LDA.l $7EC360, X : LDA.l $7EC560, X
            LDA.l $7EC370, X : LDA.l $7EC570, X
            LDA.l $7EC380, X : LDA.l $7EC580, X
            LDA.l $7EC390, X : LDA.l $7EC590, X
            LDA.l $7EC3A0, X : LDA.l $7EC5A0, X
            LDA.l $7EC3B0, X : LDA.l $7EC5B0, X
            LDA.l $7EC3C0, X : LDA.l $7EC5C0, X
            LDA.l $7EC3D0, X : LDA.l $7EC5D0, X
            LDA.l $7EC3E0, X : LDA.l $7EC5E0, X
            LDA.l $7EC3F0, X : LDA.l $7EC5F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        ++
JML $02FF51 ; Bank0E.asm : 3936 vanilla restore routine after loop which RTLs
;================================================================================
DDMConditionalLightning:
        LDA.l DisableFlashing 
        REP #$20
        BNE +
            LDA.w Scrap
            LDX.b #$02
            JML $07FA7F ; Bank0E.asm : 4738 vanilla loop equivalent to below beginning at LDY #$00
        +
            LDA.b Scrap00 : LDX.b #$02 : LDY.b #$00
        -
            LDA.w $F4EB, Y : LDA.l $7EC560, X
            LDA.w $F4F9, Y : LDA.l $7EC570, X
            LDA.w $F507, Y : LDA.l $7EC590, X
            LDA.w $F515, Y : LDA.l $7EC5E0, X
            LDA.w $F523, Y : LDA.l $7EC5F0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            JML $07FAAC ; Bank0E.asm : 4754 both branches converge here
;================================================================================
ConditionalGTFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.w Scrap
        -
            LDA.w $F9C1, Y : STA.l $7EC5D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
        +
            LDA.b Scrap00
        -
            LDA.w $F9C1, Y : LDA.l $7EC5D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
;================================================================================
ConditionalRedFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA.b Scrap,X
            LDA.w #$1D59 : STA.l $7EC5DA
            LDA.w #$25FF : STA.l $7EC5DC
            LDA.w #$001A
            RTL
        +
            LDA.b Scrap00
            LDA.w #$1D59 : LDA.l $7EC5DA
            LDA.w #$25FF : LDA.l $7EC5DC
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
        LDX.b Scrap0C : LDA.l $1BEBB4, X : AND.w #$00FF : ADC.w #$D630
        REP #$10 : LDX.w #$01B2 : LDY.w #$0002
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX.b Scrap0D
        LDA.l $1BEBC1, X : AND.w #$00FF : ADC.w #$D648
        REP #$10 : LDX.w #$01B8 : LDY.w #$0003
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX.b Scrap0E
        LDA.l $1BEC06, X : AND.w #$00FF : ASL A : ADC.w #$D308
        REP #$10 : LDX.w #$01E2 : LDY.w #$000E
        JSR ConditionalLoadGearPalette
        SEP #$30
        INC.b $15
RTL
;================================================================================
ConditionalLoadGearPalette:
        STA.b Scrap00
        SEP #$20
        LDA.l DisableFlashing : REP #$20 : BNE +
                LDA.b Scrap,X
        -
                LDA.b [Scrap00]
                STA.l $7EC500, X
                INC.b Scrap00 : INC.b Scrap00
                INX #2
                DEY
                BPL -
        RTS
        +
                LDA.b Scrap
        -
                LDA.b [Scrap00]
                LDA.l $7EC500, X
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
        INC.b $15
RTL
;================================================================================
FillPaletteBufferFromAux:
        -
            LDA.l $7EC300, X
            STA.l $7EC500, X
            INX #2
            DEY
            BPL -
RTS
