;================================================================================
; Accessability Fixes
;================================================================================
FlipGreenPendant:
	LDA $0C : CMP #$38 : BNE + ; check if we have green pendant
		ORA #$40 : STA $0C ; flip it
	+
	
    LDA $0D : STA $0802, X ; stuff we wrote over "Set CHR, palette, and priority of the sprite"
    LDA $0C : STA $0803, X
RTL
;================================================================================
!WHITEN_TIMER = "$7F5041"
SetEtherFlicker:
	LDA DisableFlashing : BNE +
                LDA $00,X
		LDA !WHITEN_TIMER : INC : STA !WHITEN_TIMER

		LDA.b #$FF : CMP !WHITEN_TIMER : BNE +++
			LDA.b #$00 : STA !WHITEN_TIMER : BRA ++
		+++
			LSR : CMP !WHITEN_TIMER : !BLT ++
				LDA $031D : CMP.b #$0B
                                RTL
		++
		LDA $031D : CMP.b #$0B
                RTL
	+
                LDA $00
		LDA !WHITEN_TIMER : INC : STA !WHITEN_TIMER
		
		LDA.b #$FF : CMP !WHITEN_TIMER : BNE +++
			LDA.b #$00 : STA !WHITEN_TIMER : BRA ++
		+++
			LSR : CMP !WHITEN_TIMER : !BLT ++
				LDA $031D : SEP #$02
                                RTL
		++
		LDA $031D : REP #$02

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
        LDA.l DisableFlashing
        REP #$20 : BNE +
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
            CMP.w #$3C : BEQ ++ ; hookshot cave
            CMP.w #$9D : BEQ ++ ; gt right
            CMP.w #$9C : BEQ ++ ; gt big room
            CMP.w #$A5 : BEQ ++ ; wizzrobes 1
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
DDMConditionalLightning:
        LDA.l DisableFlashing 
        REP #$20
        BNE +
            LDA.w $0000
            LDX.b #$02
            JML $07FA7F
        +
            LDA.b $00
        -
            LDA $F4EB, Y : LDA $7EC560, X
            LDA $F4F9, Y : LDA $7EC570, X
            LDA $F507, Y : LDA $7EC590, X
            LDA $F515, Y : LDA $7EC5E0, X
            LDA $F523, Y : LDA $7EC5F0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE -

                LDX.b #$02
                JML $07FAAC

;================================================================================
ConditionalGTFlash:
        LDA.l DisableFlashing
            REP #$20
            BNE +
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
        LDA.l DisableFlashing
        REP #$20 : BNE +
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
