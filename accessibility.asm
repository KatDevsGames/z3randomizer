;================================================================================
; Accessibility Fixes
;================================================================================
FlipGreenPendant:
	LDA $0C : CMP #$38 : BNE + ; check if we have green pendant
		ORA #$40 : STA $0C ; flip it
	+
	
    LDA $0D : STA $0802, X ; stuff we wrote over "Set CHR, palette, and priority of the sprite"
    LDA $0C : STA $0803, X
RTL
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
        STA $9A
RTL
;================================================================================
ConditionalWhitenBg:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA $00,X
            JSR WhitenLoopReal
            RTL
        +
            LDA $00
            JSR WhitenLoopDummy
            RTL
;================================================================================
WhitenLoopReal:
        -
            LDA $7EC340, X : JSL Filter_Majorly_Whiten_Color : STA $7EC540, X
            LDA $7EC350, X : JSL Filter_Majorly_Whiten_Color : STA $7EC550, X
            LDA $7EC360, X : JSL Filter_Majorly_Whiten_Color : STA $7EC560, X
            LDA $7EC370, X : JSL Filter_Majorly_Whiten_Color : STA $7EC570, X
            LDA $7EC380, X : JSL Filter_Majorly_Whiten_Color : STA $7EC580, X
            LDA $7EC390, X : JSL Filter_Majorly_Whiten_Color : STA $7EC590, X
            LDA $7EC3A0, X : JSL Filter_Majorly_Whiten_Color : STA $7EC5A0, X
            LDA $7EC3B0, X : JSL Filter_Majorly_Whiten_Color : STA $7EC5B0, X
            LDA $7EC3C0, X : JSL Filter_Majorly_Whiten_Color : STA $7EC5C0, X
            LDA $7EC3D0, X : JSL Filter_Majorly_Whiten_Color : STA $7EC5D0, X
            LDA $7EC3E0, X : JSL Filter_Majorly_Whiten_Color : STA $7EC5E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA $7EC3F0 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F0
            LDA $7EC3F2 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F2
            LDA $7EC3F4 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F4
            LDA $10 : CMP.w #$07 : BNE +
            LDA $048E
            CMP.w #$3C : BEQ ++
            CMP.w #$9D : BEQ ++
            CMP.w #$9C : BEQ ++
            CMP.w #$A5 : BEQ ++
            +
                LDA $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F6
                LDA $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F8
                BRA +++
            ++
                LDA $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F6
                LDA $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F8
                BRA +++
            +++
            LDA $7EC3FA : JSL Filter_Majorly_Whiten_Color : STA $7EC5FA
            LDA $7EC3FC : JSL Filter_Majorly_Whiten_Color : STA $7EC5FC
            LDA $7EC3FE : JSL Filter_Majorly_Whiten_Color : STA $7EC5FE
            REP #$10
            LDA $7EC540 : TAY
            LDA $7EC300 : BNE +
                TAY
        +
            TYA : STA $7EC500
            SEP #$30
RTS
;================================================================================
WhitenLoopDummy:
        -
            LDA $7EC340, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC540, X
            LDA $7EC350, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC550, X
            LDA $7EC360, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC560, X
            LDA $7EC370, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC570, X
            LDA $7EC380, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC580, X
            LDA $7EC390, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC590, X
            LDA $7EC3A0, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC5A0, X
            LDA $7EC3B0, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC5B0, X
            LDA $7EC3C0, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC5C0, X
            LDA $7EC3D0, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC5D0, X
            LDA $7EC3E0, X : JSL Filter_Majorly_Whiten_Color : LDA $7EC5E0, X
            INX #2 : CPX.b #$10 : BEQ +
                JMP -
        +
            LDA $7EC3F0 : JSL Filter_Majorly_Whiten_Color : LDA $7EC5F0
            LDA $7EC3F2 : JSL Filter_Majorly_Whiten_Color : LDA $7EC5F2
            LDA $7EC3F4 : JSL Filter_Majorly_Whiten_Color : LDA $7EC5F4
            LDA $10 : CMP.w #$07 : BNE + ; only light invisifloor if we're in dungeon submodule
            LDA $048E
            CMP.w #$3C : BEQ ++ ; hookshot cave
            CMP.w #$9D : BEQ ++ ; gt right
            CMP.w #$9C : BEQ ++ ; gt big room
            CMP.w #$A5 : BEQ ++ ; wizzrobes 1
            +
                LDA $7EC3F6 : JSL Filter_Majorly_Whiten_Color : LDA $7EC5F6
                LDA $7EC3F8 : JSL Filter_Majorly_Whiten_Color : LDA $7EC5F8
                BRA +++
            ++
                LDA $7EC3F6 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F6
                LDA $7EC3F8 : JSL Filter_Majorly_Whiten_Color : STA $7EC5F8
                BRA +++
            +++
            LDA $7EC3FA : JSL Filter_Majorly_Whiten_Color : LDA $7EC5FA
            LDA $7EC3FC : JSL Filter_Majorly_Whiten_Color : LDA $7EC5FC
            LDA $7EC3FE : JSL Filter_Majorly_Whiten_Color : LDA $7EC5FE
            REP #$10
            LDA $7EC540 : TAY
            LDA $7EC300 : BNE +
                TAY
        +
            TYA : STA $7EC500
            SEP #$30
RTS
;================================================================================
RestoreBgEther:
        LDX.b #$00
        LDA.l DisableFlashing : REP #$20 : BNE +
        -
            LDA $00,X
            LDA $7EC340, X : STA $7EC540, X
            LDA $7EC350, X : STA $7EC550, X
            LDA $7EC360, X : STA $7EC560, X
            LDA $7EC370, X : STA $7EC570, X
            LDA $7EC380, X : STA $7EC580, X
            LDA $7EC390, X : STA $7EC590, X
            LDA $7EC3A0, X : STA $7EC5A0, X
            LDA $7EC3B0, X : STA $7EC5B0, X
            LDA $7EC3C0, X : STA $7EC5C0, X
            LDA $7EC3D0, X : STA $7EC5D0, X
            LDA $7EC3E0, X : STA $7EC5E0, X
            LDA $7EC3F0, X : STA $7EC5F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        +
        -
            LDA $00
            LDA $7EC340, X : LDA $7EC540, X
            LDA $7EC350, X : LDA $7EC550, X
            LDA $7EC360, X : LDA $7EC560, X
            LDA $7EC370, X : LDA $7EC570, X
            LDA $7EC380, X : LDA $7EC580, X
            LDA $7EC390, X : LDA $7EC590, X
            LDA $7EC3A0, X : LDA $7EC5A0, X
            LDA $7EC3B0, X : LDA $7EC5B0, X
            LDA $7EC3C0, X : LDA $7EC5C0, X
            LDA $7EC3D0, X : LDA $7EC5D0, X
            LDA $7EC3E0, X : LDA $7EC5E0, X
            LDA $7EC3F0, X : LDA $7EC5F0, X
            INX #2 : CPX.b #$10 : BNE -
            BRA ++
        ++
JML $02FF51 ; Bank0E.asm : 3936 vanilla restore routine after loop which RTLs
;================================================================================
DDMConditionalLightning:
        LDA.l DisableFlashing 
        REP #$20
        BNE +
            LDA.w $0000
            LDX.b #$02
            JML $07FA7F ; Bank0E.asm : 4738 vanilla loop equivalent to below beginning at LDY #$00
        +
            LDA.b $00 : LDX.b #$02 : LDY #$00
        -
            LDA $F4EB, Y : LDA $7EC560, X
            LDA $F4F9, Y : LDA $7EC570, X
            LDA $F507, Y : LDA $7EC590, X
            LDA $F515, Y : LDA $7EC5E0, X
            LDA $F523, Y : LDA $7EC5F0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            JML $07FAAC ; Bank0E.asm : 4754 both branches converge here
;================================================================================
ConditionalGTFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA $0000
        -
            LDA $F9C1, Y : STA $7EC5D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
        +
            LDA $00
        -
            LDA $F9C1, Y : LDA $7EC5D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -
            RTL
;================================================================================
ConditionalRedFlash:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA $00,X
            LDA.w #$1D59 : STA $7EC5DA
            LDA.w #$25FF : STA $7EC5DC
            LDA.w #$001A
            RTL
        +
            LDA $00
            LDA.w #$1D59 : LDA $7EC5DA
            LDA.w #$25FF : LDA $7EC5DC
            LDA.w #$0000
            RTL
;================================================================================
ConditionalPedAncilla:
        LDA.l DisableFlashing : REP #$20 : BNE +
            LDA $00,X
            LDA $00 : STA $04
            LDA $02 : STA $06
            RTL
        +
            LDA $00
            LDA $00 : LDA $04
            LDA $02 : LDA $06
            RTL
;================================================================================
LoadElectroPalette:
        REP #$20
        LDA.w #$0202 : STA $0C
        LDA.w #$0404 : STA $0E
        LDA.w #$001B : STA $02
        SEP #$10
        LDX $0C : LDA $1BEBB4, X : AND.w #$00FF : ADC #$D630
        REP #$10 : LDX.w #$01B2 : LDY.w #$0002
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX $0D
        LDA $1BEBC1, X : AND.w #$00FF : ADC #$D648
        REP #$10 : LDX.w #$01B8 : LDY.w #$0003
        JSR ConditionalLoadGearPalette
        SEP #$10
        LDX $0E
        LDA $1BEC06, X : AND.w #$00FF : ASL A : ADC #$D308
        REP #$10 : LDX.w #$01E2 : LDY.w #$000E
        JSR ConditionalLoadGearPalette
        SEP #$30
        INC $15
RTL
;================================================================================
ConditionalLoadGearPalette:
        STA $00
        SEP #$20
        LDA.l DisableFlashing : REP #$20 : BNE +
                LDA $00,X
        -
                LDA [$00]
                STA $7EC500, X
                INC $00 : INC $00
                INX #2
                DEY
                BPL -
        RTS
        +
                LDA $00
        -
                LDA [$00]
                LDA $7EC500, X
                INC $00 : INC $00
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
        INC $15
RTL
;================================================================================
FillPaletteBufferFromAux:
        -
            LDA $7EC300, X
            STA $7EC500, X
            INX #2
            DEY
            BPL -
RTS
