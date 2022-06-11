;--------------------------------------------------------------------------------
CheckZSNES:
    SEP #$28
    LDA #$FF
    CLC
    ADC #$FF
    CMP #$64
    CLD
    BEQ .zsnes
    REP #$20
    LDA #$01FF : TCS ; thing we wrote over - initialize stack
JML.l ReturnCheckZSNES
.zsnes
	JML DontUseZSNES
;--------------------------------------------------------------------------------
