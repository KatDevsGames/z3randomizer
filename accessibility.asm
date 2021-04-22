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
!EPILEPSY_TIMER = "$7F5041"
SetEtherFlicker:
	LDA.l Seizure_Safety : BNE +
		LDA $031D : CMP.b #$0B : RTL
	+
		LDA !EPILEPSY_TIMER : INC : STA !EPILEPSY_TIMER
		
		LDA.l Seizure_Safety : CMP !EPILEPSY_TIMER : BNE +++
			LDA.b #$00 : STA !EPILEPSY_TIMER : BRA ++
		+++
			LSR : CMP !EPILEPSY_TIMER : !BLT ++
				SEP #$02 : RTL
		++
		REP #$02
	+
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
ConditionalWhitenColor:
        PHA
        STA $00
        AND.w #$001F : ADC.w #$000E
        CMP.w #$001F : BCC +
            LDA.w #$001F
    +
        STA $02   
        LDA $00 : AND.w #$03E0 : ADC.w #$01C0
        CMP.w #$03E0 : BCC +
            LDA.w #$03E0
    +
        STA $04
        LDA $00 : AND.w #$7C00 : ADC.w #$3800
        CMP.w #$7C00 : BCC +
            LDA.w #$7C00
    +
        ORA $02 : ORA $04
        PHA
        LDA.l DisableFlashing : BNE +
            PLA : PLY : PLY
            RTL
    +
            PLA : PLA : LDY $0000
        
RTL
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
        LDA.l DisableFlashing : BNE +
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
        --
            LDA $F9C1, Y : LDA $7EC5D0, X
            INY #2
            INX #2 : CPX.b #$10 : BNE --
RTL
;================================================================================
ConditionalRedFlash:
        REP #$20
        LDA.l DisableFlashing : BEQ +
            LDA $00,X
            LDA.w #$1D59 : LDA $7EC5DA
            LDA.w #$25FF : LDA $7EC5DC
            LDA.w #$0000
            RTL

        +
            LDA $00
            LDA.w #$1D59 : STA $7EC5DA
            LDA.w #$25FF : STA $7EC5DC
            LDA.w #$001A

RTL
